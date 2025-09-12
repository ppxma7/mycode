import os
import subprocess
import glob
import argparse

# FSL and MNI paths
#FSLDIR = "/usr/local/fsl/"  # Update if needed
# FSLDIR = "/Users/spmic/fsl/"
# MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz"  # 1mm version
# MY_CONFIG_DIR = "/Users/spmic/data/"  # Update if needed

FSLDIR = "/usr/local/fsl/"
MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz"  # 1mm version
MY_CONFIG_DIR = "/Users/ppzma/data/"  # Update if needed

# Define paths
#FSLDIR = "/software/imaging/fsl/6.0.6.3"
#MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz"
#BRC_GLOBAL_DIR = "/software/imaging/BRC_pipeline/1.6.6//global"  # Change this to actual path
#MY_CONFIG_DIR = "/gpfs01/home/ppzma/"

def register_t1_to_mni_1mm(sub_dir, subject, data_dir):
    """Register T1 map to MPRAGE, move MPRAGE to MNI 1mm space, then apply transformation to T1."""


    # Step 0: Perform Brain Extraction (BET)
    t1_raw = os.path.join(sub_dir, f"{subject}_T1.nii.gz")
    #t1_brain = os.path.join(sub_dir, f"{subject}_T1_brain.nii.gz")
    t1_brain = os.path.join(sub_dir, f"{subject}_T1_brain_flipx.nii.gz")

    print(f"{t1_raw}")
    
    if not os.path.exists(t1_raw):
        print(f"❌ Missing raw T1 file for {subject}, skipping processing.")
        return
    
    if not os.path.exists(t1_brain):
        print(f"❌ Missing bet T1 file for {subject}, running bet.")
        #bet_cmd = ["bet", t1_raw, t1_brain, "-R", "-f", "0","-g","-0.2","-S","-B"]
        bet_cmd = ["bet", t1_raw, t1_brain, "-R", "-f", "0","-g","-0.2"]
        subprocess.run(bet_cmd, check=True)


    # Locate MPRAGE
    mprage_dir = os.path.join(data_dir, subject, "MPRAGE")
    mprage_files = glob.glob(os.path.join(mprage_dir, "*MPRAGE*.nii"))
    
    if not mprage_files:
        print(f"❌ Missing MPRAGE file for {subject}, skipping MNI registration.")
        return
    
    mprage_file = mprage_files[0]  # Use the first match
    print(f"✅ Found MPRAGE file for {subject}: {mprage_file}")

    mprage_brain = os.path.join(mprage_dir, f"{subject}_MPRAGE_brain.nii.gz")
    if not os.path.exists(mprage_brain):
        bet_cmd = ["bet", mprage_file, mprage_brain, "-R", "-F", "-f", "0.1"]
        subprocess.run(bet_cmd, check=True)


    # Locate the T1 map
    # t1_files = glob.glob(os.path.join(sub_dir, f"{subject}_T1.nii.gz"))
    
    # if not t1_files:
    #     print(f"❌ Missing T1 map for {subject}, skipping MNI registration.")
    #     return
    
    # t1_input = t1_files[0]
    # print(f"✅ Found T1 map for {subject}: {t1_input}")

    # Output paths
    t1_to_mprage = os.path.join(sub_dir, f"{subject}_T1_to_MPRAGE.nii.gz")
    affine_t1_to_mprage = os.path.join(sub_dir, f"{subject}_T1_to_MPRAGE.mat")

    mprage_to_mni = os.path.join(sub_dir,f"{subject}_MPRAGE_to_MNI_linear.nii.gz")
    affine_mprage_to_mni = os.path.join(sub_dir,f"{subject}_MPRAGE_to_MNI.mat")

    mprage_to_mni_nonlin = os.path.join(sub_dir, f"{subject}_MPRAGE_to_MNI_nonlin.nii.gz")
    fnirt_coeff = os.path.join(sub_dir,f"{subject}_MPRAGE_to_MNI_nonlin_coeff.nii.gz")

    t1_mni_output = os.path.join(sub_dir,f"{subject}_T1_to_MNI_nonlinear_1mm.nii.gz")

    t1_to_mprage_brain_masked = os.path.join(sub_dir,f"{subject}_T1_to_MPRAGE_masked.nii.gz")


    print("mprage_brain =", mprage_brain)
    print("t1_brain =", t1_brain)
    print("MNI_TEMPLATE =", MNI_TEMPLATE)
    print("mprage_to_mni =", mprage_to_mni)
    #print("affine_mprage_to_mni =", affine_mprage_to_mni)



    if not os.path.exists(t1_to_mprage):
        # Step 1: Register T1 to MPRAGE (native space)
        print("running T1 to native MPRAGE now")
        subprocess.run([
            f"{FSLDIR}/bin/flirt",
            "-in", t1_brain,
            "-ref", mprage_brain,
            "-omat", affine_t1_to_mprage,
            "-out", t1_to_mprage,
            "-cost", "normmi",  # Use MI instead of default corratio mutualinfo
            "-dof", "6",
            "-searchrx", "0", "0",
            "-searchry", "0", "0",
            "-searchrz", "0", "0",
            "-usesqform"
        ], check=True)
        print(f"✅ {subject} FLIRT: T1 map registered to MPRAGE.")


    if not os.path.exists(t1_to_mprage_brain_masked):
        mprage_brain_mask = os.path.join(mprage_dir, f"{subject}_MPRAGE_brain_mask.nii.gz")
        print("Masking T1 by MPRAGE mask")

        maths_cmd = [
            "fslmaths",  # assuming you mean fslmaths
            t1_to_mprage,
            "-mul", mprage_brain_mask,
            t1_to_mprage_brain_masked
        ]

        subprocess.run(maths_cmd, check=True)
        print(f"✅ {subject} T1 to MPRAGE image masked by MPRAGE brain mask")


    # **Move MPRAGE to MNI 1mm space (linear)**
    if not os.path.exists(mprage_to_mni):
        print("running MPRAGE to MNI now")
        subprocess.run([
            f"{FSLDIR}/bin/flirt",
            "-in", mprage_brain,
            "-ref", MNI_TEMPLATE,
            "-omat", affine_mprage_to_mni,
            "-out", mprage_to_mni,
            "-bins", "256",
            "-dof", "6",
            "-cost", "corratio",
            "-searchrx", "-90", "90",
            "-searchry", "-90", "90",
            "-searchrz", "-90", "90",
            "-interp", "trilinear"
        ], check=True)
        print(f"✅ {subject} FLIRT: MPRAGE map registered to MNI 1mm space.")

    # Just skip the FNIRT for now    
    # **Refine MPRAGE to MNI using FNIRT (nonlinear)**
    if not os.path.exists(mprage_to_mni_nonlin):
        print("running fnirt MPRAGE to MNI now")
        subprocess.run([
            f"{FSLDIR}/bin/fnirt",
            f"--in={mprage_file}",
            f"--ref={MNI_TEMPLATE}",
            f"--aff={affine_mprage_to_mni}",
            f"--config={MY_CONFIG_DIR}/config/bb_fnirt.cnf",
            f"--cout={fnirt_coeff}",
            f"--iout={mprage_to_mni_nonlin}",
            f"--refmask={FSLDIR}/data/standard/MNI152_T1_1mm_brain_mask.nii.gz",
            "--interp=spline"
        ], check=True)
        print(f"✅ {subject} FNIRT: MPRAGE map registered to MNI 1mm space.")

    # Linear registration: apply MPRAGE→MNI affine directly to masked T1
    t1_to_mni_linear = os.path.join(sub_dir, f"{subject}_T1_to_MNI_linear_1mm.nii.gz")

    print("applying MPRAGE→MNI affine directly to masked T1 (already in MPRAGE space)…")
    subprocess.run([
        f"{FSLDIR}/bin/flirt",
        "-in", t1_to_mprage_brain_masked,
        "-ref", MNI_TEMPLATE,
        "-applyxfm",
        "-init", affine_mprage_to_mni,
        "-out", t1_to_mni_linear,
        "-interp", "spline"
    ], check=True)

    print(f"✅ {subject} FLIRT: Masked T1 map linearly registered to MNI 1mm space.")

    # Nonlinear registration: apply FNIRT warp to masked T1
    t1_to_mni_nonlin = os.path.join(sub_dir, f"{subject}_T1_to_MNI_nonlinear_1mm.nii.gz")

    print("applying FNIRT (nonlinear) warp to masked T1 (already in MPRAGE space)…")
    subprocess.run([
        f"{FSLDIR}/bin/applywarp",
        f"--in={t1_to_mprage_brain_masked}",
        f"--ref={MNI_TEMPLATE}",
        f"--warp={fnirt_coeff}",
        f"--out={t1_to_mni_nonlin}",
        "--interp=spline"
    ], check=True)

    print(f"✅ {subject} FNIRT: Masked T1 map nonlinearly registered to MNI 1mm space.")



    # if not os.path.exists(t1_mni_output):
    #     # **Apply the same transformation to the T1 map**
    #     subprocess.run([
    #         f"{FSLDIR}/bin/applywarp",
    #         f"--in={t1_to_mprage_brain_masked}", # t1_brain
    #         f"--ref={MNI_TEMPLATE}",
    #         f"--warp={fnirt_coeff}",
    #         f"--premat={affine_t1_to_mprage}",
    #         f"--out={t1_mni_output}",
    #         "--interp=spline"
    #     ], check=True)
    #     print(f"✅ {subject} T1 map successfully registered to MNI 1mm space.")


    # # paths for your linear-T1→MNI outputs
    # combined_affine = os.path.join(sub_dir, f"{subject}_T1_to_MNI_linear.mat")
    # t1_to_mni_linear = os.path.join(sub_dir, f"{subject}_T1_to_MNI_linear_1mm.nii.gz")

    # ## Careful, this bit is applying both transforms to the raw T1 which is technically fine
    # ## but if we already have the t1 in mprage space, then dont need to use it right?
    # #if not os.path.exists(t1_to_mni_linear):
    # print("combining T1→MPRAGE and MPRAGE→MNI affines…")
    # # 1) build the single combined affine
    # subprocess.run([
    #     f"{FSLDIR}/bin/convert_xfm",
    #     "-omat", combined_affine,
    #     "-concat", affine_mprage_to_mni,  # second
    #                 affine_t1_to_mprage  # first
    # ], check=True)

    # print("applying combined affine to T1…")
    # # 2) apply it to your brain-extracted T1
    # subprocess.run([
    #     f"{FSLDIR}/bin/flirt",
    #     "-in", t1_to_mprage_brain_masked, # t1_brain
    #     "-ref", MNI_TEMPLATE,
    #     "-applyxfm",
    #     "-init", combined_affine,
    #     "-out", t1_to_mni_linear,
    #     "-interp", "spline"
    # ], check=True)

    # print(f"✅ {subject} FLIRT: T1 map linearly registered to MNI 1mm space.")


    # if not os.path.exists(t1_to_mni_linear):
    #     print("Applying MPRAGE→MNI transform to T1 already in MPRAGE space...")
        
    #     subprocess.run([
    #         f"{FSLDIR}/bin/flirt",
    #         "-in", t1_to_mprage,  # Already resampled to MPRAGE space
    #         "-ref", MNI_TEMPLATE,
    #         "-applyxfm",
    #         "-init", affine_mprage_to_mni,
    #         "-out", t1_to_mni_linear,
    #         "-interp", "spline"
    #     ], check=True)

    #     print(f"✅ {subject} T1 mapped to MNI using existing T1→MPRAGE resample and MPRAGE→MNI transform.")



def main(data_dir, output_dir, subject):

    sub_dir = os.path.join(output_dir, subject)

    if not os.path.exists(sub_dir):
        print(f"❌ Output directory missing for {subject}")

    register_t1_to_mni_1mm(sub_dir, subject, data_dir)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Register T1 to MNI 1mm")
    parser.add_argument("-d", "--data_dir", required=True, help="Base data directory")
    parser.add_argument("-o", "--output_dir", required=True, help="Output directory")
    parser.add_argument("-s", "--subject", required=True, help="Subject ID")

    args = parser.parse_args()
    main(args.data_dir, args.output_dir, args.subject)
