import os
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt

# Get all gfactor files in the current directory (assuming .nii extension)
gfactor_files = [f for f in os.listdir('.') if f.startswith('gfactor') and f.endswith('.nii')]

for gfactor_file in gfactor_files:
    print(f"Processing {gfactor_file}...")

    # Load g-factor NIfTI file
    img_g = nib.load(gfactor_file)
    data_g = img_g.get_fdata()

    # Compute 1/g, avoiding division by zero
    one_over_g = np.divide(1.0, data_g, where=data_g != 0, out=np.zeros_like(data_g))

    # Save the 1/g-factor NIfTI file
    one_over_filename = gfactor_file.replace('.nii', '_one_over.nii')
    nib.save(nib.Nifti1Image(one_over_g, img_g.affine, img_g.header), one_over_filename)
    print(f"Saved {one_over_filename}")

    # Pattern match: Remove the "gfactor_" prefix to find the corresponding magnitude image.
    mag_filename = gfactor_file.replace("gfactor_", "")
    if not os.path.exists(mag_filename):
        print(f"Corresponding magnitude file {mag_filename} not found. Skipping {gfactor_file}.")
        continue

    # Load magnitude image
    img_mag = nib.load(mag_filename)
    data_mag_raw = img_mag.get_fdata()
    data_mag = data_mag_raw.mean(axis=3)

    # Compute mean values (ignoring zeros to avoid skew)
    mean_g = np.mean(data_g[data_g > 0])
    mean_one_over_g = np.mean(one_over_g[one_over_g > 0])
    # mean_mag = np.mean(data_mag[data_mag > 0])

    # Select middle slice (axial) from each volume
    mid_slice_g = data_g.shape[2] // 2
    mid_slice_mag = data_mag.shape[2] // 2  # Assuming same orientation

    # Create a 1x3 subplot figure
    fig, axes = plt.subplots(1, 3, figsize=(18, 6))

    # Original g-factor map
    ax = axes[0]
    im0 = ax.imshow(data_g[:, :, mid_slice_g], cmap='grey', origin='lower', vmin=0, vmax=40)
    fig.colorbar(im0, ax=ax, fraction=0.046, pad=0.04)
    ax.set_title(f"Original g-factor\nMean: {mean_g:.3f}")

    # 1/g-factor map
    ax = axes[1]
    im1 = ax.imshow(one_over_g[:, :, mid_slice_g], cmap='inferno', origin='lower', vmin=0, vmax=0.5)
    fig.colorbar(im1, ax=ax, fraction=0.046, pad=0.04)
    ax.set_title(f"1/g-factor\nMean: {mean_one_over_g:.3f}")

    # Magnitude image
    ax = axes[2]
    im2 = ax.imshow(data_mag[:, :, mid_slice_mag], cmap='grey', origin='lower', vmin=0, vmax=100000)
    fig.colorbar(im2, ax=ax, fraction=0.046, pad=0.04)
    #ax.set_title(f"Magnitude Image\nMean: {mean_mag:.3f}")

    # Save the combined figure
    png_filename = gfactor_file.replace('.nii', '_comparison.png')
    plt.tight_layout()
    plt.savefig(png_filename, dpi=300)
    plt.close()
    print(f"Saved {png_filename}")
