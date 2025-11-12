import os
import subprocess
import glob
import argparse
import sys
import shutil

FSLDIR = "/usr/local/fsl/"
#FSLDIR = "/Users/spmic/fsl/"
MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz"  # 1mm version
MY_CONFIG_DIR = "/Users/ppzma/data/"  # Update if needed


parser = argparse.ArgumentParser(description="No CSF T1 to MNI")
parser.add_argument("MPRAGE_DIR", help="Path to overall MPRAGE dir")
parser.add_argument("T1_DIR", help="Path to overall T1 dir")
parser.add_argument("SUBJECT", help="Subject name")

args = parser.parse_args()

MPRAGE_DIR = args.MPRAGE_DIR
T1_DIR = args.T1_DIR
SUBJECT = args.SUBJECT

sub_mprage_dir = os.path.join(MPRAGE_DIR,SUBJECT)
sub_t1_dir = os.path.join(T1_DIR,SUBJECT)

mprage_brain = os.path.join(sub_mprage_dir, f"{SUBJECT}_MPRAGE_optibrain.nii.gz")
mprage2mni = os.path.join(sub_t1_dir, f"{SUBJECT}_MPRAGE_to_MNI.mat")

t1_nocsf = os.path.join(sub_t1_dir, f"{SUBJECT}_T1_to_MPRAGE_noCSF.nii.gz")
t1_nocsf_mni = os.path.join(sub_t1_dir, f"{SUBJECT}_T1_to_MPRAGE_noCSF_MNI.nii.gz")

def run(cmd, check=True):
    print("🔧 Running:", " ".join(cmd))
    subprocess.run(cmd, check=check)

def error(msg):
    print(f"❌ {msg}", file=sys.stderr)
    sys.exit(1)

if not os.path.exists(t1_nocsf_mni):
    if not os.path.exists(t1_nocsf):
        error("Need to run remove_csf_t1.sh first!")
    else:
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", t1_nocsf,
            "-ref", MNI_TEMPLATE,
            "-applyxfm",
            "-init", mprage2mni,
            "-out", t1_nocsf_mni,
            "-interp", "spline"
        ])



