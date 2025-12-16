import os
import subprocess
import argparse
import sys

FSLDIR = "/usr/local/fsl/"
MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz"

parser = argparse.ArgumentParser(description="Register GM/WM-masked T1 maps to MNI")
parser.add_argument("MPRAGE_DIR", help="Path to overall MPRAGE dir")
parser.add_argument("T1_DIR", help="Path to overall T1 dir")
parser.add_argument("SUBJECT", help="Subject name")

args = parser.parse_args()

MPRAGE_DIR = args.MPRAGE_DIR
T1_DIR = args.T1_DIR
SUBJECT = args.SUBJECT

sub_mprage_dir = os.path.join(MPRAGE_DIR, SUBJECT)
sub_t1_dir = os.path.join(T1_DIR, SUBJECT)

mprage2mni = os.path.join(sub_t1_dir, f"{SUBJECT}_MPRAGE_to_MNI.mat")

t1_gm = os.path.join(sub_t1_dir, f"{SUBJECT}_T1_to_MPRAGE_GM.nii.gz")
t1_wm = os.path.join(sub_t1_dir, f"{SUBJECT}_T1_to_MPRAGE_WM.nii.gz")

t1_gm_mni = os.path.join(sub_t1_dir, f"{SUBJECT}_T1_to_MPRAGE_GM_MNI.nii.gz")
t1_wm_mni = os.path.join(sub_t1_dir, f"{SUBJECT}_T1_to_MPRAGE_WM_MNI.nii.gz")

def run(cmd):
    print("🔧 Running:", " ".join(cmd))
    subprocess.run(cmd, check=True)

def error(msg):
    print(f"❌ {msg}", file=sys.stderr)
    sys.exit(1)

if not os.path.exists(mprage2mni):
    error("Missing MPRAGE_to_MNI.mat — run MPRAGE registration first")

# -------- GM --------
if not os.path.exists(t1_gm_mni):
    if not os.path.exists(t1_gm):
        error("GM T1 does not exist — run GM masking first")
    run([
        f"{FSLDIR}/bin/flirt",
        "-in", t1_gm,
        "-ref", MNI_TEMPLATE,
        "-applyxfm",
        "-init", mprage2mni,
        "-out", t1_gm_mni,
        "-interp", "spline"
    ])
else:
    print("ℹ️ GM T1 already in MNI space, skipping")

# -------- WM --------
if not os.path.exists(t1_wm_mni):
    if not os.path.exists(t1_wm):
        error("WM T1 does not exist — run WM masking first")
    run([
        f"{FSLDIR}/bin/flirt",
        "-in", t1_wm,
        "-ref", MNI_TEMPLATE,
        "-applyxfm",
        "-init", mprage2mni,
        "-out", t1_wm_mni,
        "-interp", "spline"
    ])
else:
    print("ℹ️ WM T1 already in MNI space, skipping")

print(f"✅ Finished GM/WM registration for {SUBJECT}")
