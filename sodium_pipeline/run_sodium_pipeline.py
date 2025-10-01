import os
import subprocess
import argparse
import sys
import shutil
import glob
import nibabel as nib
import numpy as np
import pandas as pd
import xml.etree.ElementTree as ET


# ---------- USER CONFIG ----------
FSLDIR = "/usr/local/fsl"
MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz"
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


# Outputs
# First lets skull strip the main MPRAGE
mprage_optibrain = os.path.join(ARG1, f"{subject}_MPRAGE_optibrain.nii.gz")
mprage_optibrain_mask = os.path.join(ARG1, f"{subject}_MPRAGE_optibrain_mask.nii.gz")

# Now lets skull strip the MPRAGE in SODIUM space
sodium_mprage_file_optibrain = os.path.join(ARG2, f"{subject}_SODIUMMPRAGE_optibrain.nii.gz")
sodium_mprage_file_optibrain_mask = os.path.join(ARG2, f"{subject}_SODIUMMPRAGE_optibrain_mask.nii.gz")

# Now lets move the SODIUM MPRAGE to the main MPRAGE
sodium_mprage_file2mprage = os.path.join(ARG2, f"{subject}_SODIUMMPRAGE_2MPRAGE.nii.gz")
sodium_mprage_file2mprage_mat = os.path.join(ARG2, f"{subject}_SODIUMMPRAGE_2MPRAGE.mat")

# We need to move the sodium file to the sodium MPRAGE just to fix all the matrices
sodium_2_sodiumMPRAGE = os.path.join(ARG3, f"{subject}_sodium_in_sodium_mprage_space.nii.gz")
sodium_2_sodiumMPRAGE_mat = os.path.join(ARG3, f"{subject}_sodium_in_sodium_mprage_space.mat")

# Now lets move the sodium to the main MPRAGE, using the transform from the SODIUM MPRAGE
sodium_in_mprage_space = os.path.join(ARG3, f"{subject}_sodium_in_mprage_space.nii.gz")

# Okay, now we can start to move to MNI space 
sodium_mprage_file_mni = os.path.join(ARG2, f"{subject}_SODIUMMPRAGE_MNI.nii.gz")
sodium_mprage_file_mni_fnirt = os.path.join(ARG2, f"{subject}_SODIUMMPRAGE_MNI_FNIRT.nii.gz")
affine_mprage_to_mni = os.path.join(ARG1, f"{subject}_mprage2mni.mat")
mprage_to_mni = os.path.join(ARG1, f"{subject}_mprage2mni_linear.nii.gz")
mprage_to_mni_nonlin = os.path.join(ARG1, f"{subject}_mprage2mni_nonlin.nii.gz")
fnirt_coeff = os.path.join(ARG1, f"{subject}_mprage2mni_warpcoef.nii.gz")

sodium_file_mni = os.path.join(ARG3, f"{subject}_sodium_MNI.nii.gz")
sodium_file_mni_FNIRT = os.path.join(ARG3, f"{subject}_sodium_MNI_FNIRT.nii.gz")

atlas_in_sodium = os.path.join(ARG3, f"{subject}_HarvardOxford_in_sodium.nii.gz")
#subcortatlas_in_sodium = os.path.join(ARG3, f"{subject}_HarvardOxfordsubcort_in_sodium.nii.gz")
atlas_in_sodium_FNIRT = os.path.join(ARG3, f"{subject}_HarvardOxford_in_sodium_FNIRT.nii.gz")
#subcortatlas_in_sodium_FNIRT = os.path.join(ARG3, f"{subject}_HarvardOxfordsubcort_in_sodium_FNIRT.nii.gz")


out_csv = os.path.join(ARG3, f"{subject}_ROIstats.csv")

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


def runOptibetOnSodiumMPRAGE():
    if not os.path.exists(sodium_mprage_file_optibrain):

        run(["sh", OPTIBET_PATH, "-i", sodium_mprage_file])

        base = os.path.splitext(sodium_mprage_file)[0]  # remove .nii or .nii.gz
        optibet_brain = f"{base}_optiBET_brain.nii.gz"
        optibet_mask = f"{base}_optiBET_brain_mask.nii.gz"

        # Rename/move to desired output names
        shutil.move(optibet_brain, sodium_mprage_file_optibrain)
        shutil.move(optibet_mask, sodium_mprage_file_optibrain_mask)
        print(f"✅ optiBET brain created: {sodium_mprage_file_optibrain}")

    else:
        print("⏭️ optiBET brain already exists, skipping.")


def runMPRAGE2MPRAGE():
    if not os.path.exists(sodium_mprage_file2mprage):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", sodium_mprage_file_optibrain,
            "-ref", mprage_optibrain,
            "-omat", sodium_mprage_file2mprage_mat,
            "-out", sodium_mprage_file2mprage,
            "-dof", "6"
        ])
        print(f"✅ Registered sodium MPRAGE to main MPRAGE: {sodium_mprage_file2mprage}")
    else:
        print("⏭️ Sodium MPRAGE already registered, skipping.")

def runSodium2SodiumMPRAGE():
    if not os.path.exists(sodium_2_sodiumMPRAGE):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", sodium_file,
            "-ref", sodium_mprage_file_optibrain,
            "-omat", sodium_2_sodiumMPRAGE_mat,
            "-out", sodium_2_sodiumMPRAGE,
            "-bins","256",
            "-dof", "6",
            "-schedule","/usr/local/fsl/etc/flirtsch/sch3Dtrans_3dof",
            "-cost", "normmi",
            "-searchrx", "0", "0",
            "-searchry", "0", "0",
            "-searchrz", "0", "0",
            "-interp", "trilinear"
        ])
        print(f"✅ Sodium registered to sodium-MPRAGE: {sodium_2_sodiumMPRAGE}")
    else:
        print("⏭️ Sodium already registered to sodium-MPRAGE.")


def runSodium2Mprage():
    if not os.path.exists(sodium_in_mprage_space):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", sodium_2_sodiumMPRAGE,
            "-ref", mprage_optibrain,
            "-applyxfm",
            "-init", sodium_mprage_file2mprage_mat,
            "-out", sodium_in_mprage_space
        ])
        print(f"✅ Sodium image transformed into MPRAGE space: {sodium_in_mprage_space}")
    else:
        print("⏭️ Sodium image already transformed, skipping.")

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
            "-searchrx", "-90", "90",
            "-searchry", "-90", "90",
            "-searchrz", "-90", "90",
            "-interp", "trilinear"
        ])
    else:
        print("⏭️ FLIRT MPRAGE→MNI exists, skipping.")

    if not os.path.exists(mprage_to_mni_nonlin):
        print("Running FNIRT MPRAGE → MNI")
        run([
            f"{FSLDIR}/bin/fnirt",
            f"--in={mprage_optibrain}",
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


# Just ignore this bit for now, because of FNIRT
def runSodiumMPRAGEtoMNI():
    #out_file = sodium_mprage_file.replace(".nii", "_in_mni.nii.gz")
    if not os.path.exists(sodium_mprage_file_mni_fnirt):
        run([
            f"{FSLDIR}/bin/applywarp",
            "--ref="+MNI_TEMPLATE,
            "--in="+sodium_mprage_file2mprage,
            "--warp="+fnirt_coeff,
            "--out="+sodium_mprage_file_mni_fnirt
        ])
        print(f"✅ Sodium MPRAGE moved to MNI space: {sodium_mprage_file_mni_fnirt}")
    else:
        print("⏭️ Sodium MPRAGE already in MNI space.")

def runSodiumMPRAGEtoMNI_linear():
    if not os.path.exists(sodium_mprage_file_mni):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", sodium_mprage_file2mprage,
            "-ref", MNI_TEMPLATE,
            "-applyxfm",
            "-init", affine_mprage_to_mni,
            "-out", sodium_mprage_file_mni
        ])
        print(f"✅ Sodium MPRAGE moved to MNI space (linear only): {sodium_mprage_file_mni}")
    else:
        print("⏭️ Sodium MPRAGE already in MNI space.")

# use the linear transformation for now
def runSodiumtoMNI():
    if not os.path.exists(sodium_file_mni):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", sodium_in_mprage_space,
            "-ref", MNI_TEMPLATE,
            "-applyxfm",
            "-init", affine_mprage_to_mni,
            "-out", sodium_file_mni
        ])
        print(f"✅ Sodium moved to MNI space (linear only): {sodium_file_mni}")
    else:
        print("⏭️ Sodium already in MNI space.")


def runSodiumtoMNI_FNIRT():
    #out_file = sodium_file_mni.replace(".nii.gz", "_FNIRT.nii.gz")
    if not os.path.exists(sodium_file_mni_FNIRT):
        run([
            f"{FSLDIR}/bin/applywarp",
            "--ref=" + MNI_TEMPLATE,
            "--in=" + sodium_in_mprage_space,
            "--warp=" + fnirt_coeff,
            "--out=" + sodium_file_mni_FNIRT,
            "--interp=spline"
        ])
        print(f"✅ Sodium moved to MNI space (FNIRT): {sodium_file_mni_FNIRT}")
    else:
        print("⏭️ Sodium already in MNI (FNIRT) space.")
    #return sodium_file_mni_FNIRT




#####################################################################################################################
#####################################################################################################################

def moveAtlasToSodium():
    atlas = f"{FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr0-1mm.nii.gz"
    #subcortatlas = f"{FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr0-1mm.nii.gz"

    

    # Step 1: Invert MPRAGE→MNI (get MNI→MPRAGE)
    mni2mprage_mat = os.path.join(ARG1, f"{subject}_mni2mprage.mat")
    if not os.path.exists(mni2mprage_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mni2mprage_mat,
            "-inverse", affine_mprage_to_mni
        ])
        print(f"✅ Created MNI→MPRAGE matrix: {mni2mprage_mat}")
    else:
        print("⏭️ MNI→MPRAGE matrix already exists.")

    # Step 2: Invert SODIUMMPRAGE→MPRAGE (get MPRAGE→SODIUMMPRAGE)
    mprage2sodiummprage_mat = os.path.join(ARG2, f"{subject}_MPRAGE_2_SODIUMMPRAGE.mat")
    if not os.path.exists(mprage2sodiummprage_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mprage2sodiummprage_mat,
            "-inverse", sodium_mprage_file2mprage_mat
        ])
        print(f"✅ Created MPRAGE→SODIUMMPRAGE matrix: {mprage2sodiummprage_mat}")
    else:
        print("⏭️ MPRAGE→SODIUMMPRAGE matrix already exists.")

    # Step 3: Invert SODIUM→SODIUMMPRAGE (get SODIUMMPRAGE→SODIUM)
    sodiummprage2sodium_mat = os.path.join(ARG3, f"{subject}_sodiummprage2sodium.mat")
    if not os.path.exists(sodiummprage2sodium_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", sodiummprage2sodium_mat,
            "-inverse", sodium_2_sodiumMPRAGE_mat
        ])
        print(f"✅ Created SODIUMMPRAGE→SODIUM matrix: {sodiummprage2sodium_mat}")
    else:
        print("⏭️ SODIUMMPRAGE→SODIUM matrix already exists.")

    # Step 4: Concatenate MNI→MPRAGE + MPRAGE→SODIUMMPRAGE
    mni2sodiummprage_mat = os.path.join(ARG3, f"{subject}_mni2sodiummprage.mat")
    if not os.path.exists(mni2sodiummprage_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mni2sodiummprage_mat,
            "-concat", mprage2sodiummprage_mat,
            mni2mprage_mat
        ])
        print(f"✅ Created MNI→SODIUMMPRAGE matrix: {mni2sodiummprage_mat}")

    # Step 5: Concatenate with SODIUMMPRAGE→SODIUM to get final MNI→SODIUM
    mni2sodium_mat = os.path.join(ARG3, f"{subject}_mni2sodium.mat")
    if not os.path.exists(mni2sodium_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mni2sodium_mat,
            "-concat", sodiummprage2sodium_mat,
            mni2sodiummprage_mat
        ])
        print(f"✅ Created MNI→SODIUM matrix: {mni2sodium_mat}")

    # Step 6: Apply transform to atlas (nearest neighbour for labels)
    if not os.path.exists(atlas_in_sodium):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", atlas,
            "-ref", sodium_file,
            "-applyxfm",
            "-init", mni2sodium_mat,
            "-interp", "nearestneighbour",
            "-out", atlas_in_sodium
        ])
        print(f"✅ Atlas moved to sodium space: {atlas_in_sodium}")
    else:
        print("⏭️ Atlas already exists in sodium space.")





def moveAtlasToSodium_FNIRT():

    atlas = f"{FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr0-1mm.nii.gz"
    #subcortatlas = f"{FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr0-1mm.nii.gz"

    # Step 1: Invert MPRAGE→MNI warp to get MNI→MPRAGE
    mni2mprage_warp = os.path.join(ARG1, f"{subject}_mni2mprage_warp.nii.gz")
    if not os.path.exists(mni2mprage_warp):
        run([
            f"{FSLDIR}/bin/invwarp",
            "-w", fnirt_coeff,
            "-o", mni2mprage_warp,
            "-r", mprage_optibrain
        ])
        print(f"✅ Created MNI→MPRAGE warp: {mni2mprage_warp}")

    # Step 2: Invert SODIUMMPRAGE→MPRAGE (get MPRAGE→SODIUMMPRAGE)
    mprage2sodiummprage_mat = os.path.join(ARG2, f"{subject}_MPRAGE_2_SODIUMMPRAGE.mat")
    if not os.path.exists(mprage2sodiummprage_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mprage2sodiummprage_mat,
            "-inverse", sodium_mprage_file2mprage_mat
        ])
        print(f"✅ Created MPRAGE→SODIUMMPRAGE matrix: {mprage2sodiummprage_mat}")
    else:
        print("⏭️ MPRAGE→SODIUMMPRAGE matrix already exists.")

    # Step 3: Invert SODIUM→SODIUMMPRAGE (get SODIUMMPRAGE→SODIUM)
    sodiummprage2sodium_mat = os.path.join(ARG3, f"{subject}_sodiummprage2sodium.mat")
    if not os.path.exists(sodiummprage2sodium_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", sodiummprage2sodium_mat,
            "-inverse", sodium_2_sodiumMPRAGE_mat
        ])
        print(f"✅ Created SODIUMMPRAGE→SODIUM matrix: {sodiummprage2sodium_mat}")
    else:
        print("⏭️ SODIUMMPRAGE→SODIUM matrix already exists.")

    # Step 4: Concatenate MNI→MPRAGE + MPRAGE→SODIUMMPRAGE
    mni2sodiummprage_mat = os.path.join(ARG3, f"{subject}_mni2sodiummprage.mat")
    if not os.path.exists(mni2sodiummprage_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mni2sodiummprage_mat,
            "-concat", mprage2sodiummprage_mat,
            mni2mprage_mat
        ])
        print(f"✅ Created MNI→SODIUMMPRAGE matrix: {mni2sodiummprage_mat}")

    # Step 5: Concatenate with SODIUMMPRAGE→SODIUM to get final MNI→SODIUM
    mni2sodium_mat = os.path.join(ARG3, f"{subject}_mni2sodium.mat")
    if not os.path.exists(mni2sodium_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mni2sodium_mat,
            "-concat", sodiummprage2sodium_mat,
            mni2sodiummprage_mat
        ])
        print(f"✅ Created MNI→SODIUM matrix: {mni2sodium_mat}")

    # Step 6: Apply warp + matrices to atlas
    if not os.path.exists(atlas_in_sodium_FNIRT):
        # First warp atlas into MPRAGE space (nonlinear)
        atlas_in_mprage = os.path.join(ARG1, f"{subject}_atlas_in_mprage.nii.gz")
        run([
            f"{FSLDIR}/bin/applywarp",
            "--ref=" + mprage_optibrain,
            "--in=" + atlas,
            "--warp=" + mni2mprage_warp,
            "--out=" + atlas_in_mprage,
            "--interp=nn"
        ])

        # Then use convert_xfm to concatenate mprage2sodiummprage.mat and sodiummprage2sodium.mat
        mni2sodium_mat = os.path.join(ARG3, f"{subject}_mni2sodium.mat")
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", mni2sodium_mat,
            "-concat", sodiummprage2sodium_mat,
            mprage2sodiummprage_mat
        ])

        # Finally apply the affine transform to go from MPRAGE space → sodium
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", atlas_in_mprage,
            "-ref", sodium_file,
            "-applyxfm",
            "-init", mni2sodium_mat,
            "-interp", "nearestneighbour",
            "-out", atlas_in_sodium_FNIRT
        ])


def load_atlas_labels(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    labels = {}
    for label in root.findall(".//label"):
        idx = int(label.get("index"))
        name = label.text
        labels[idx] = name
    return labels


def roiTable():
    # Load sodium image and atlas
    sodium_img = nib.load(sodium_file)
    atlas_img = nib.load(atlas_in_sodium)  
    sodium_data = sodium_img.get_fdata()
    atlas_data = atlas_img.get_fdata().astype(int)

    # Get unique ROI labels (exclude 0 = background)
    roi_labels = np.unique(atlas_data)
    roi_labels = roi_labels[(roi_labels >= 0) & (roi_labels <= 47)]
    #print(roi_labels)
    #roi_labels = roi_labels[roi_labels > 0]

    xml_file = f"{FSLDIR}/data/atlases/HarvardOxford-Cortical.xml"
    label_dict = load_atlas_labels(xml_file)
    #print(label_dict)

    results = []
    for roi in roi_labels:
        mask = atlas_data == roi
        values = sodium_data[mask]

        if values.size > 0:
            mean_val = np.mean(values)
            std_val = np.std(values)
            median_val = np.median(values)

            roi_name = label_dict.get(roi, f"ROI_{roi}") # grab names from XML
            results.append([roi, roi_name, mean_val, std_val, median_val])

    # Put into a DataFrame
    df = pd.DataFrame(results, columns=["ROI", "Name", "Mean", "StdDev", "Median"])

    # Save CSV 
    #output_dir = os.path.join(os.path.dirname(ARG3), "outputs")
    #output_dir = ARG3
    #os.makedirs(output_dir, exist_ok=True)
    #out_csv = os.path.join(output_dir, f"{subject}_ROIstats.csv")
    df.to_csv(out_csv, index=False)

    print(f"✅ ROI stats saved to {out_csv}")




def moveOutputs():
    # Use ARG1's parent folder as subject root
    subject_root = os.path.dirname(ARG1)  # gives .../<subject>
    output_dir = os.path.join(subject_root, "outputs")
    os.makedirs(output_dir, exist_ok=True)
    print(f"📦 Collecting outputs in: {output_dir}")

    # files_to_copy = [
    #     os.path.join(ARG3, f"{subject}_HarvardOxford_in_sodium.nii.gz"),
    #     os.path.join(ARG3, f"{subject}_HarvardOxford_in_sodium_FNIRT.nii.gz"),
    #     sodium_file_mni,
    #     sodium_file_mni_FNIRT,
    # ]
    files_to_copy = [
        atlas_in_sodium,
        atlas_in_sodium_FNIRT,
        sodium_file_mni,
        sodium_file_mni_FNIRT,
        out_csv
    ]


    for f in files_to_copy:
        if os.path.exists(f):
            dest = os.path.join(output_dir, os.path.basename(f))
            shutil.copy(f, dest)
            print(f"✅ Copied {os.path.basename(f)} to outputs/")
        else:
            print(f"⚠️ Missing file, skipping: {f}")







#####################################################################################################################
#####################################################################################################################


if __name__ == "__main__":
    runOptibet()
    runOptibetOnSodiumMPRAGE()
    runMPRAGE2MPRAGE()
    runSodium2SodiumMPRAGE()
    runSodium2Mprage()
    runMPRAGE2MNI()

    runSodiumMPRAGEtoMNI_linear()
    runSodiumMPRAGEtoMNI()

    runSodiumtoMNI()
    runSodiumtoMNI_FNIRT()

    moveAtlasToSodium()
    moveAtlasToSodium_FNIRT()

    roiTable()

    moveOutputs()
