import numpy as np
import matplotlib.pyplot as plt
import os
import nibabel as nib

def plot_slices_grid(img_data, slice_gap=10, vmax=None, cmap=None, save_path=None):
    """
    Plot multiple slices of a 3D image in a near-square grid.

    Parameters:
    - img_data: 3D numpy array (X, Y, Z)
    - slice_gap: int, spacing between slices to plot
    - vmax: max value for imshow color scaling
    - save_path: if given, save the figure to this path
    - cmap: matplotlib colormap name or object
    
    The slices chosen will be every `slice_gap` slices.
    """
    # Generate slice indices using the gap



    # shape_z = img_data.shape[2]
    # slices = list(range(0, shape_z, slice_gap))
    # n_slices = len(slices)
    
    # nrows = int(np.ceil(np.sqrt(n_slices)))
    # ncols = int(np.ceil(n_slices / nrows))
    
    # fig, axs = plt.subplots(nrows, ncols, figsize=(ncols*3, nrows*3))
    # axs = axs.flatten()
    
    # for i in range(nrows * ncols):
    #     ax = axs[i]
    #     if i < n_slices:
    #         slc = slices[i]
    #         ax.imshow(img_data[:, :, slc].T, origin='lower', cmap=cmap, vmax=vmax)
    #         ax.set_title(f"Slice {slc}", fontsize=8)
    #     ax.axis('off')


    z_dim = img_data.shape[2]
    start_slice = 30
    end_slice = z_dim - 30
    selected_slices = list(range(start_slice, end_slice, slice_gap))

    n_slices = len(selected_slices)
    n_cols = int(np.ceil(np.sqrt(n_slices)))
    n_rows = int(np.ceil(n_slices / n_cols))

    fig, axes = plt.subplots(n_rows, n_cols, figsize=(n_cols*3, n_rows*3))
    axes = axes.flatten()

    for i, sl in enumerate(selected_slices):
        ax = axes[i]
        slice_data = img_data[:, :, sl]
        ax.imshow(slice_data.T, origin='lower', cmap=cmap, vmax=vmax)
        ax.axis('off')
        ax.set_title(f"Slice {sl}")

    # Hide any unused axes
    for j in range(i+1, len(axes)):
        axes[j].axis('off')


    
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=300)
        print(f"✅ Saved slice grid figure to: {save_path}")
    plt.close(fig)


# Example usage:



img_dir = "/Volumes/r15/DRS-GBPerm/other/t1mapping_out/group_averages_python"

# Example: load all mean maps for groups 1 to 4
group_nums = [1, 2, 3, 4]
image_types = ["mean"]  # could be ['mean', 'std', 'median', 'iqr', 'cov']
cmap = "viridis"

# Build dictionary of group_name -> image data
imgs_data = {}

for group in group_nums:
    for img_type in image_types:
        filename = f"group{group}_{img_type}.nii.gz"
        filepath = os.path.join(img_dir, filename)
        if os.path.exists(filepath):
            nii = nib.load(filepath)
            imgs_data[f"group{group}_{img_type}"] = nii.get_fdata()
        else:
            print(f"❌ File not found: {filepath}")


out_dir = "/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_plots"

for group_name, img_data in imgs_data.items():
    save_file = os.path.join(out_dir, f"{group_name}_slices.png")
    # Optional: set vmax so all plots have same color scale, e.g. 4000
    plot_slices_grid(img_data, slice_gap=5, vmax=3500, cmap=cmap, save_path=save_file)

