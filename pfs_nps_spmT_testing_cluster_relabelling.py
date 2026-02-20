import nibabel as nib
import numpy as np
import subprocess
import os
import sys

def run(cmd, check=True):
    print("🔧 Running:", " ".join(cmd))
    subprocess.run(cmd, check=check)

def strip_ext(fname):
    if fname.endswith(".nii.gz"):
        return fname[:-7]  # strip 7 chars for '.nii.gz'
    else:
        return os.path.splitext(fname)[0]

FSLDIR = "/usr/local/fsl"
CLUSTDIR = "/usr/local/fsl/share/fsl/bin/"

rootFold = "/Volumes/kratos/npspfstesting/cluststuff/"

preFile = os.path.join(rootFold, "nps_pos_bin_bridge_breaking.nii.gz")
cluster_index = os.path.join(rootFold, "nps_clust.nii.gz")
relabel_file = os.path.join(rootFold, "nps_clust_relabelled.nii.gz")
atlas_2mm = os.path.join(rootFold, "nps_clust_relabelled_2mm.nii.gz")
tmask_file = os.path.join(rootFold, "spmT_1p96_bin.nii.gz")

if not os.path.exists(cluster_index):
    run([
        f"{FSLDIR}/bin/fsl-cluster",
        "--in=" + preFile,
        "--thresh=0.1",
        "--oindex=" + cluster_index,
        "--peakdist=1"
    ])
else:
    print("skipping clustering")

img = nib.load(cluster_index)
data = img.get_fdata().astype(np.int32)

new = np.zeros(data.shape, dtype=np.int16)

# your mappings
new[np.isin(data, [76, 77])] = 1
new[np.isin(data, [68, 69, 70, 73, 74, 75])] = 2
new[data == 78] = 3

# IMPORTANT: create fresh header

if not os.path.exists(relabel_file):
    new_img = nib.Nifti1Image(new, img.affine)
    new_img.set_data_dtype(np.int16)
    nib.save(new_img, relabel_file)
    print("\n✅ Relabelled atlas saved:", relabel_file)
else:
    print("skipping saving relabelled")

if not os.path.exists(atlas_2mm):
    run([
        f"{FSLDIR}/bin/flirt",
        "-in", relabel_file,
        "-ref", tmask_file,
        "-applyxfm",
        "-usesqform",
        "-interp", "nearestneighbour",
        "-out", atlas_2mm
    ])
else:
    print("skipping saving atlas")


# now do calculations
atlas_img = nib.load(atlas_2mm)
atlas = atlas_img.get_fdata().astype(np.int16)

tmask_img = nib.load(tmask_file)
tmask = tmask_img.get_fdata()

# ---- SAFETY CHECK ----
if atlas.shape != tmask.shape:
    sys.exit("❌ ERROR: Images are not on same grid. Registration failed.")

tmask = (tmask > 0).astype(np.uint8)

total_sig = int(np.sum(tmask))
print(f"\nTotal suprathreshold voxels: {total_sig}")

labels = [1, 2, 3]

print("\nOverlap results:")
print("----------------------------")

for lab in labels:
    overlap = int(np.sum((atlas == lab) & (tmask == 1)))
    percent = (overlap / total_sig * 100) if total_sig > 0 else 0
    print(f"Label {lab}: {overlap} voxels ({percent:.2f}%)")

print("\n✅ Finished successfully")

# # sanity check
# print("Sum of overlaps:",
#       sum(np.sum((atlas==l) & (tmask==1)) for l in labels))
# print("Total sig:", total_sig)

out_txt = os.path.join(rootFold, "atlas_overlap_results.txt")

with open(out_txt, "w") as f:

    f.write(f"Total suprathreshold voxels: {total_sig}\n")
    f.write("Label\tOverlapVoxels\tPercentOfTmap\n")

    for lab in labels:
        overlap = int(np.sum((atlas == lab) & (tmask == 1)))
        percent = (overlap / total_sig * 100) if total_sig > 0 else 0

        line = f"{lab}\t{overlap}\t{percent:.4f}\n"

        print(f"Label {lab}: {overlap} voxels ({percent:.2f}%)")
        f.write(line)

print(f"\nSaved results to: {out_txt}")


