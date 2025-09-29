import os
import subprocess
import argparse
import sys
import shutil
import glob


# ---------- USER CONFIG ----------
FSLDIR = "/usr/local/fsl"
MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz"
MNI_BRAIN_MASK = f"{FSLDIR}/data/standard/MNI152_T1_1mm_brain_mask.nii.gz"
MY_CONFIG_DIR = "/Users/ppzma/data"  # contains bb_fnirt.cnf
OPTIBET_PATH = "/Users/ppzma/Documents/MATLAB/optibet.sh"

# ---------- ARGPARSE ----------
parser = argparse.ArgumentParser(description="Run sodium MRI pipeline")
parser.add_argument("ARG1", help="Path to MPRAGE directory")
parser.add_argument("ARG2", help="Path to MPRAGE_sodium directory")
parser.add_argument("ARG3", help="Path to sodium directory")
args = parser.parse_args()

ARG1 = args.ARG1
ARG2 = args.ARG2
ARG3 = args.ARG3

subject = os.path.basename(os.path.dirname(ARG1))

# --- Auto-detect input files ---
# 1. Main MPRAGE (should start with WIP_MPRAGE_ or similar)
mprage_matches = glob.glob(os.path.join(ARG1, "*MPRAGE_CS3p5*.nii*"))
if len(mprage_matches) == 0:
    raise FileNotFoundError(f"No MPRAGE file found in {ARG1}")
elif len(mprage_matches) > 1:
    print(f"⚠️ Multiple MPRAGE files found, using first: {mprage_matches[0]}")
mprage_file = mprage_matches[0]

# 2. Sodium MPRAGE (must contain subject ID + MPRAGE + 301)
sodium_mprage_matches = glob.glob(os.path.join(ARG2, f"{subject}_WIP_MPRAGE_*_301.nii*"))
if len(sodium_mprage_matches) == 0:
    raise FileNotFoundError(f"No sodium MPRAGE found in {ARG2}")
elif len(sodium_mprage_matches) > 1:
    print(f"⚠️ Multiple sodium MPRAGE files found, using first: {sodium_mprage_matches[0]}")
sodium_mprage_file = sodium_mprage_matches[0]

# 3. Sodium image (must contain subject ID + 23Na)
sodium_matches = glob.glob(os.path.join(ARG3, f"{subject}_WIP_23Na_*_401.nii*"))
if len(sodium_matches) == 0:
    raise FileNotFoundError(f"No sodium image found in {ARG3}")
elif len(sodium_matches) > 1:
    print(f"⚠️ Multiple sodium image files found, using first: {sodium_matches[0]}")
sodium_file = sodium_matches[0]


# Locate input files (customize patterns as needed)
#mprage_file = os.path.join(ARG1, "WIP_MPRAGE_CS3p5_601.nii")
#sodium_mprage_file = os.path.join(ARG2, os.path.basename(ARG2) + "_WIP_MPRAGE_20240718075554_301.nii")
#sodium_file = os.path.join(ARG3, os.path.basename(ARG3) + "_WIP_23Na_TFE-UTE_20240718075554_401.nii")

print(mprage_file)
print(sodium_mprage_file)
print(sodium_file)

#sys.exit(0)



# Outputs
mprage_optibrain = os.path.join(ARG1, f"{subject}_MPRAGE_optibrain.nii.gz")
mprage_optibrain_mask = os.path.join(ARG1, f"{subject}_MPRAGE_optibrain_mask.nii.gz")


affine_mprage_to_mni = os.path.join(ARG1, "mprage2mni.mat")
mprage_to_mni = os.path.join(ARG1, "mprage2mni_linear.nii.gz")
mprage_to_mni_nonlin = os.path.join(ARG1, "mprage2mni_nonlin.nii.gz")
fnirt_coeff = os.path.join(ARG1, "mprage2mni_warpcoef.nii.gz")

def run(cmd, check=True):
    print("🔧 Running:", " ".join(cmd))
    subprocess.run(cmd, check=check)

def runOptibet():
    if not os.path.exists(mprage_optibrain):

        run(["sh", OPTIBET_PATH, "-i", mprage_file])

        base = os.path.splitext(mprage_file)[0]  # remove .nii or .nii.gz
        optibet_brain = f"{base}_optiBET_brain.nii.gz"
        optibet_mask = f"{base}_optiBET_brain_mask.nii.gz"

        # Rename/move to desired output names
        shutil.move(optibet_brain, mprage_optibrain)
        shutil.move(optibet_mask, mprage_optibrain_mask)
        print(f"✅ optiBET brain created: {mprage_optibrain}")

    else:
        print("⏭️ optiBET brain already exists, skipping.")




def runMPRAGE2MPRAGE():
    out_file = sodium_mprage_file.replace(".nii", "_to_mainmprage.nii.gz")
    if not os.path.exists(out_file):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", sodium_mprage_file,
            "-ref", mprage_optibrain,
            "-omat", os.path.join(ARG1, "sodiummprage2mprage.mat"),
            "-out", out_file,
            "-dof", "6"
        ])
        print(f"✅ Registered sodium MPRAGE to main MPRAGE: {out_file}")
    else:
        print("⏭️ Sodium MPRAGE already registered, skipping.")
    return out_file

def runSodium2Mprage():
    out_file = os.path.join(ARG3, "sodium_in_mprage_space.nii.gz")
    if not os.path.exists(out_file):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", sodium_file,
            "-ref", mprage_optibrain,
            "-applyxfm",
            "-init", os.path.join(ARG1, "sodiummprage2mprage.mat"),
            "-out", out_file
        ])
        print(f"✅ Sodium image transformed into MPRAGE space: {out_file}")
    else:
        print("⏭️ Sodium image already transformed, skipping.")
    return out_file

def runMPRAGE2MNI():
    if not os.path.exists(mprage_to_mni):
        print("Running FLIRT MPRAGE → MNI")
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", mprage_optibrain,
            "-ref", MNI_TEMPLATE,
            "-omat", affine_mprage_to_mni,
            "-out", mprage_to_mni,
            "-bins", "256",
            "-dof", "12",
            "-cost", "corratio",
            "-interp", "trilinear"
        ])
    else:
        print("⏭️ FLIRT MPRAGE→MNI exists, skipping.")

    if not os.path.exists(mprage_to_mni_nonlin):
        print("Running FNIRT MPRAGE → MNI")
        run([
            f"{FSLDIR}/bin/fnirt",
            f"--in={mprage_file}",
            f"--ref={MNI_TEMPLATE}",
            f"--aff={affine_mprage_to_mni}",
            f"--config={MY_CONFIG_DIR}/config/bb_fnirt.cnf",
            f"--cout={fnirt_coeff}",
            f"--iout={mprage_to_mni_nonlin}",
            f"--refmask={MNI_BRAIN_MASK}",
            "--interp=spline"
        ])
    else:
        print("⏭️ FNIRT warp exists, skipping.")

def runSodiumMPRAGEtoMNI():
    out_file = sodium_mprage_file.replace(".nii", "_in_mni.nii.gz")
    if not os.path.exists(out_file):
        run([
            f"{FSLDIR}/bin/applywarp",
            "--ref="+MNI_TEMPLATE,
            "--in="+sodium_mprage_file,
            "--warp="+fnirt_coeff,
            "--out="+out_file
        ])
        print(f"✅ Sodium MPRAGE moved to MNI space: {out_file}")
    else:
        print("⏭️ Sodium MPRAGE already in MNI space.")
    return out_file

def moveAtlasToSodium():
    atlas = f"{FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr50-1mm.nii.gz"
    out_file = os.path.join(ARG3, "HOatlas_in_sodium_space.nii.gz")
    if not os.path.exists(out_file):
        run([
            f"{FSLDIR}/bin/invwarp",
            "-w", fnirt_coeff,
            "-o", os.path.join(ARG1, "mni2mprage_warp"),
            "-r", mprage_optibrain
        ])
        run([
            f"{FSLDIR}/bin/applywarp",
            "--ref="+sodium_file,
            "--in="+atlas,
            "--warp="+os.path.join(ARG1, "mni2mprage_warp"),
            "--out="+out_file
        ])
        print(f"✅ Harvard-Oxford atlas moved to sodium space: {out_file}")
    else:
        print("⏭️ Atlas already in sodium space.")
    return out_file

if __name__ == "__main__":
    runOptibet()
    runMPRAGE2MPRAGE()
    runSodium2Mprage()
    runMPRAGE2MNI()
    runSodiumMPRAGEtoMNI()
    moveAtlasToSodium()
