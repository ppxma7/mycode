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
#MY_CONFIG_DIR = "/Users/ppzma/data"  # contains bb_fnirt.cnf
atlas = f"{FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr0-1mm.nii.gz"
OPTIBET_PATH = "/Users/ppzma/Documents/MATLAB/optibet.sh"

parser = argparse.ArgumentParser(description="Run sodium MRI pipeline")

parser.add_argument("ARG1", help="Path to outputs")
parser.add_argument("ARG2", help="Path to clinical T1")


args = parser.parse_args()
ARG1 = args.ARG1
ARG2 = args.ARG2

subject = os.path.basename(os.path.dirname(os.path.dirname(os.path.dirname(ARG1))))
print(subject)


######### USEFUL FUNCTIONS

def strip_ext(fname):
    if fname.endswith(".nii.gz"):
        return fname[:-7]  # strip 7 chars for '.nii.gz'
    else:
        return os.path.splitext(fname)[0]


def run(cmd, check=True, cwd=None):
    print("🔧 Running:", " ".join(cmd))
    subprocess.run(cmd, check=check, cwd=cwd)

def load_atlas_labels(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    labels = {}
    for label in root.findall(".//label"):
        idx = int(label.get("index"))
        name = label.text
        labels[idx] = name
    return labels

######### this one for atlas lookup
def roi_table_catchexceptions(sodium_file, atlas_file, out_csv, max_roi=47):
    try:
        sodium_img = nib.load(sodium_file)
        atlas_img = nib.load(atlas_file)

        sodium_data = sodium_img.get_fdata()
        atlas_data = atlas_img.get_fdata().astype(int)

        # --- Handle shape mismatch automatically ---
        if sodium_data.shape != atlas_data.shape:
            print(f"⚠️ Shape mismatch: {os.path.basename(sodium_file)} "
                  f"{sodium_data.shape} vs atlas {atlas_data.shape} — resampling sodium to atlas space...")

            resampled_sodium = f"{strip_ext(sodium_file)}_resampled_to_atlas.nii.gz"
            subprocess.run([
                f"{FSLDIR}/bin/flirt",
                "-in", sodium_file,
                "-ref", atlas_file,
                "-out", resampled_sodium,
                "-applyxfm",
                "-usesqform"
            ], check=True)

            sodium_file = resampled_sodium
            sodium_img = nib.load(sodium_file)
            sodium_data = sodium_img.get_fdata()
            print(f"✅ Resampled sodium saved as {os.path.basename(resampled_sodium)}")

        # --- ROI extraction as before ---
        roi_labels = np.unique(atlas_data)
        roi_labels = roi_labels[(roi_labels >= 0) & (roi_labels <= max_roi)]

        xml_file = os.path.join(FSLDIR, "data/atlases/HarvardOxford-Cortical.xml")
        label_dict = load_atlas_labels(xml_file)

        results = []
        for roi in roi_labels:
            mask = atlas_data == roi
            values = sodium_data[mask]
            if values.size > 0:
                mean_val = np.mean(values)
                std_val = np.std(values)
                median_val = np.median(values)
                roi_name = label_dict.get(roi, f"ROI_{roi}")
                results.append([roi, roi_name, mean_val, std_val, median_val])

        if not results:
            print(f"⚠️ No valid ROI data found for {os.path.basename(sodium_file)} — skipping.")
            return

        df = pd.DataFrame(results, columns=["ROI", "Name", "Mean", "StdDev", "Median"])
        df.to_csv(out_csv, index=False)
        print(f"✅ ROI stats saved to {out_csv}")

    except Exception as e:
        print(f"❌ Error processing {os.path.basename(sodium_file)}: {e}")
        return


######### 

parent_dir = os.path.dirname(os.path.dirname(ARG1))
outputs_clinical = os.path.join(parent_dir, "outputs_clinical")
os.makedirs(outputs_clinical, exist_ok=True)

# Find MPRAGE
mprage_matches = glob.glob(os.path.join(ARG1, "*MPRAGE_optibrain.nii*"))
if len(mprage_matches) == 0:
    raise FileNotFoundError(f"No MPRAGE file found in {ARG1}")
elif len(mprage_matches) > 1:
    print(f"⚠️ Multiple MPRAGE files found, using first: {mprage_matches[0]}")
mprage_file = mprage_matches[0]

# Find Sodium files that are already aligned to MPRAGE
sodium_matches = glob.glob(os.path.join(ARG1, "*_alignedtoRef_toMPRAGE.nii.gz"))
if len(sodium_matches) == 0:
    raise FileNotFoundError(f"No sodium align12doftoMPRAGE files found in {ARG1}")
else:
	sodium_files = sorted(sodium_matches)
	print("Found sodium files:", sodium_matches)
	print(f"Found {len(sodium_matches)} sodium files")

# Find clinical T1
mprage_matches_clin = glob.glob(os.path.join(ARG2, "*clinical*.nii*"))
if len(mprage_matches_clin) == 0:
    raise FileNotFoundError(f"No clinical T1w file found in {ARG2}")
elif len(mprage_matches_clin) > 1:
    print(f"⚠️ Multiple MPRAGE files found, using first: {mprage_matches_clin[0]}")
mprage_file_clinical = mprage_matches_clin[0]



######################### move files to new folder created ##########################
dest = os.path.join(outputs_clinical, os.path.basename(mprage_file))
if not os.path.exists(dest):
    shutil.copy(mprage_file, dest)
    print(f"📦 Copied {os.path.basename(mprage_file)} → {outputs_clinical}/")
else:
    print(f"⏭️ Already exists in outputs_clinical: {dest}")

dest = os.path.join(outputs_clinical, os.path.basename(mprage_file_clinical))
if not os.path.exists(dest):
    shutil.copy(mprage_file_clinical, dest)
    print(f"📦 Copied {os.path.basename(mprage_file_clinical)} → {outputs_clinical}/")
else:
    print(f"⏭️ Already exists in outputs_clinical: {dest}")

for f in sodium_files:
    if not os.path.exists(f):
        print(f"⚠️ Missing source file: {f}")
        continue

    dest = os.path.join(outputs_clinical, os.path.basename(f))

    if os.path.exists(dest):
        print(f"⏭️ Already exists in outputs_clinical: {dest}")
        continue

    shutil.copy(f, dest)
    print(f"📦 Copied {os.path.basename(f)} → {outputs_clinical}/")


######################### Bet the clinical T1 ##########################

clin_base = strip_ext(os.path.basename(mprage_file_clinical))
mprage_clinical_optibrain = os.path.join(outputs_clinical, f"{clin_base}_optibrain.nii.gz")

if not os.path.exists(mprage_clinical_optibrain):

    run(["sh", OPTIBET_PATH, "-i", os.path.basename(mprage_file_clinical)], cwd=outputs_clinical, check=True)

    optibet_brain = os.path.join(outputs_clinical, f"{clin_base}_optiBET_brain.nii.gz")

    # Rename/move to desired output names
    shutil.move(optibet_brain, mprage_clinical_optibrain)
    print(f"✅ optiBET brain created: {mprage_clinical_optibrain}")

else:
    print(f"⏭️ optiBET brain {mprage_clinical_optibrain} already exists, skipping.")


#sys.exit(0)

######################### Begin FLIRT ##########################
# move the MPRAGE file to the clinical MPRAGE file using flirt
# apply those transforms to the sodium files I"ve grabbed

mprage_base = strip_ext(os.path.basename(mprage_file))
#clin_base   = strip_ext(os.path.basename(mprage_file_clinical))

mprage2clin_mat = os.path.join(outputs_clinical, f"{mprage_base}_to_clinical.mat")
mprage2clin_img = os.path.join(outputs_clinical, f"{mprage_base}_in_clinical.nii.gz")

# First flirt the MPRAGE to the Clinical MPRAGE
if not os.path.exists(mprage2clin_img):
	run([
        "flirt",
        "-in", mprage_file,
        "-ref", mprage_clinical_optibrain, #mprage_file_clinical no skullstrip
        "-out", mprage2clin_img,
        "-omat", mprage2clin_mat,
        "-bins", "256",
        "-cost", "corratio",
        "-searchrx", "-90", "90",
        "-searchry", "-90", "90",
        "-searchrz", "-90", "90",
        "-dof", "6",
        "-interp", "trilinear"
    ])
else:
	print(f"⏭️ Already exists in outputs_clinical: {mprage2clin_img}")

# Apply the transform the sodium files
for sodium in sodium_files:

    sodium_base = strip_ext(os.path.basename(sodium))
    sodium_out = os.path.join(outputs_clinical, f"{sodium_base}_in_clinical.nii.gz")
    if not os.path.exists(sodium_out):
        run([
            "flirt",
            "-in", sodium,
            "-ref", mprage_clinical_optibrain,
            "-out", sodium_out,
            "-applyxfm",
            "-init", mprage2clin_mat
        ])
    else:
    	print(f"⏭️ Already exists in outputs_clinical: {sodium_out}")

######################### Atlas stuff ##########################

## Now we need to apply the atlas to these sodium files in clinical T1 space.

t1_to_mni_mat = os.path.join(outputs_clinical, "clinical2mni.mat")
t1_to_mni_img = os.path.join(outputs_clinical, "clinical_in_MNI.nii.gz")

# First move clinical T1 to MNI space
if not os.path.exists(t1_to_mni_img):
    print("Running FLIRT MPRAGE → MNI")
    run([
        f"{FSLDIR}/bin/flirt",
        "-in", mprage_clinical_optibrain,
        "-ref", MNI_TEMPLATE,
        "-omat", t1_to_mni_mat,
        "-out", t1_to_mni_img,
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

mni_to_t1_mat = os.path.join(outputs_clinical, "mni2clinical.mat")

# Invert transform
if not os.path.exists(mni_to_t1_mat):
	run([
		"convert_xfm",
		"-omat", mni_to_t1_mat,
		"-inverse", t1_to_mni_mat
		])

atlas = f"{FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr0-1mm.nii.gz"
atlas_in_clinical = os.path.join(outputs_clinical, "HarvardOxford_in_clinical.nii.gz")

# Apply inverted transform to atlas
if not os.path.exists(atlas_in_clinical):
	run([
		"flirt",
		"-in", atlas,
		"-ref", mprage_clinical_optibrain,
		"-out", atlas_in_clinical,
		"-applyxfm",
		"-init", mni_to_t1_mat,
		"-interp", "nearestneighbour"
		])

# Now use atlas in clinical T1 space to the sodium files in clinical T1 space
for sodium in sodium_files:

    sodium_base = strip_ext(os.path.basename(sodium))
    sodium_in_clin = os.path.join(outputs_clinical, f"{sodium_base}_in_clinical.nii.gz")

    out_csv = os.path.join(outputs_clinical, f"{sodium_base}_ROIstats.csv")

    if not os.path.exists(sodium_in_clin):
        print(f"⚠️ Missing transformed sodium: {sodium_in_clin}")
        continue

    roi_table_catchexceptions(sodium_in_clin, atlas_in_clinical, out_csv)














