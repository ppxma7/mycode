import os
import nibabel as nib
import numpy as np

def computeDice(map1_path, map2_path, output_dir=None):
    # Load maps
    img1 = nib.load(map1_path)
    img2 = nib.load(map2_path)

    data1 = img1.get_fdata()
    data2 = img2.get_fdata()

    # Binarize
    bin1 = (data1 > 0).astype(np.uint8)
    bin2 = (data2 > 0).astype(np.uint8)

    # Compute intersection
    intersection = bin1 * bin2
    intersection_sum = np.sum(intersection)
    size1 = np.sum(bin1)
    size2 = np.sum(bin2)

    dice = (2 * intersection_sum) / (size1 + size2) if (size1 + size2) > 0 else 0

    # Set output directory
    if output_dir is None:
        output_dir = os.path.dirname(map1_path)

    os.makedirs(output_dir, exist_ok=True)

    # Prepare output names
    base1 = os.path.splitext(os.path.basename(map1_path))[0]
    base2 = os.path.splitext(os.path.basename(map2_path))[0]
    outname = f"dice_{base1}_vs_{base2}"

    # Save Dice score
    txt_path = os.path.join(output_dir, f"{outname}.txt")
    with open(txt_path, 'w') as f:
        f.write(f"{outname}: Dice = {dice:.4f}\n")

    # Save intersection mask
    intersection_img = nib.Nifti1Image(intersection, img1.affine, img1.header)
    mask_path = os.path.join(output_dir, f"{outname}_intersection.nii.gz")
    nib.save(intersection_img, mask_path)

    print(f"✅ Dice = {dice:.4f} saved to {txt_path}")
    print(f"🧠 Intersection mask saved to {mask_path}")


# Example usage when script is run directly
if __name__ == "__main__":
    path1 = "/Volumes/r15/DRS-GBPerm/other/t1_mprage_overlap/"
    path2 = "/Volumes/r15/DRS-GBPerm/other/t1mnispace/"
    map1 = os.path.join(path1,"lh.thickness.g1_vs_g4.both.cache.th30.mni.nii.gz")
    map2 = os.path.join(path2,"neg_tstats/masked_tstat3.nii.gz")
    outdir = "/Volumes/r15/DRS-GBPerm/other/t1_mprage_overlap"

    computeDice(map1, map2, output_dir=outdir)
