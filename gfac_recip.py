import os
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt

# Get all gfactor files in the current directory
gfactor_files = [f for f in os.listdir('.') if f.startswith('gfactor') and f.endswith('.nii')]

for gfactor_file in gfactor_files:
    print(f"Processing {gfactor_file}...")

    # Load NIfTI file
    img = nib.load(gfactor_file)
    data = img.get_fdata()

    # Compute 1/g, handling division by zero
    one_over_g = np.divide(1.0, data, where=data != 0, out=np.zeros_like(data))

    # Save new NIfTI file
    new_filename = gfactor_file.replace('.nii', '_one_over.nii')
    nib.save(nib.Nifti1Image(one_over_g, img.affine, img.header), new_filename)
    print(f"Saved {new_filename}")

    # Plot and save a PNG of the middle slice
    mid_slice = one_over_g.shape[2] // 2  # Choose a middle axial slice
    plt.imshow(one_over_g[:, :, mid_slice], cmap='inferno', origin='lower')
    plt.colorbar(label='1/g-factor')
    plt.title(f"1/g-factor: {gfactor_file}")

    png_filename = gfactor_file.replace('.nii', '_one_over.png')
    plt.savefig(png_filename, dpi=300)
    plt.close()
    print(f"Saved {png_filename}")
