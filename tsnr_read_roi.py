import os
import numpy as np
import fnmatch
import nibabel as nib
import matplotlib.pyplot as plt
from scipy.stats import norm
import seaborn as sns
import re
import sys
from matplotlib.patches import Rectangle
from matplotlib import colormaps


# This is python3 code that serves to plot tSNR barcharts, based on the output of qa_run_fmrs2.ipynb 
# (here: /Users/spmic/Documents/MATLAB/qa/fMRI_report_python/tutorials/)

# Confidence interval critical value for 95% (z = 1.96 for a normal distribution)
z = norm.ppf(0.975)  # 95% confidence

# Prepare data for swarm plot
swarm_data = []
swarm_positions = []
grouped_x_positions = []  # Track grouped positions for each multiband factor


# Define the root path and subfolder names
#root_path = "/Users/spmic/data/preDUST_FUNSTAR_MBSENSE_090125/"
root_path = "/Users/spmic/data/preDUST_HEAD_MBSENSE/qa_outputs/raw/"

#subfolders = []
# Define the pattern for subfolder names
folder_pattern = "qa_output_preDUST*"

# Dynamically find subfolders matching the pattern
subfolders = [
    folder for folder in os.listdir(root_path) 
    if os.path.isdir(os.path.join(root_path, folder)) and fnmatch.fnmatch(folder, folder_pattern)
]

# Function to extract the numeric suffix from folder names
def extract_numeric_suffix(folder_name):
    match = re.search(r"_(\d+)_clv_clipped$", folder_name)
    return int(match.group(1)) if match else float('inf')  # Use inf for folders without a match

# Sort the folders by the numeric suffix
subfolders.sort(key=extract_numeric_suffix)

# Initialize lists to store mean and STD for each folder
means = []
stds = []
folder_labels = []

print(f"Found {len(subfolders)} subfolders matching the pattern:")

# Process each folder
for folder in subfolders:
    print(folder)
    nii_path = os.path.join(root_path, folder, "classic_tsnr_tsnr_map.nii.gz")
    
    if os.path.exists(nii_path):
        try:
            # Load the NIfTI file
            nii = nib.load(nii_path)
            data = nii.get_fdata()

            data_shape = data.shape

            # Print the shape
            print("Data shape:", data_shape)


            # Define the 2D ROI
            # Example: Center at (48, 48) on slice 12 with size 20x20 (in-plane ROI dimensions)
            slice_index = 12  # The z-slice where the 2D ROI is located
            roi_center = (48, 48)  # (x, y) center of the ROI
            roi_size = (20, 20)  # (width, height) of the ROI

            # Calculate ROI bounds in 2D
            x_start = max(roi_center[0] - roi_size[0] // 2, 0)
            x_end = min(roi_center[0] + roi_size[0] // 2, data_shape[0])
            y_start = max(roi_center[1] - roi_size[1] // 2, 0)
            y_end = min(roi_center[1] + roi_size[1] // 2, data_shape[1])

            # Extract the 2D ROI data
            slice_data = data[:, :, slice_index]
            roi_data = slice_data[x_start:x_end, y_start:y_end]

            # Print ROI shape
            print("2D ROI shape:", roi_data.shape)



            # Flatten the data to 1D array
            flat_data = roi_data.flatten()

            # Remove the bottom 1% of max
            max_val = np.max(flat_data)
            #threshold = 0.01 * max_val
            #filtered_data = flat_data[flat_data >= threshold]
            filtered_data = flat_data # dont threshold ROI data

            # Calculate mean and standard deviation

            # length filtered data
            n_voxels = len(filtered_data)
            # standard error
            sem_val = np.std(filtered_data) / np.sqrt(n_voxels) # unused for now

            # CI
            ci_error = z * sem_val  # Calculate 95% CI error

            # Calculate the IQR
            q25 = np.percentile(filtered_data, 25)  # 25th percentile (Q1)
            q75 = np.percentile(filtered_data, 75)  # 75th percentile (Q3)
            iqr = q75 - q25  # Interquartile range

            # Store IQR as an error value for visualization
            iqr_error = [q75 - np.mean(filtered_data), np.mean(filtered_data) - q25]  # Asymmetrical
            #stds.append(iqr_error)  # Save IQR for plotting


            mean_val = np.mean(filtered_data)
            std_val = np.std(filtered_data) # unused for now

            # Store results
            means.append(mean_val)
            stds.append(std_val)
            folder_labels.append(folder)

            print(f"Processed {folder}: Mean = {mean_val}, STD = {std_val}, SEM = {sem_val}, CI = {ci_error}, IQR = {iqr_error}")



            # Visualize the slice with the ROI as a rectangle
            fig, ax = plt.subplots(figsize=(8, 8))
            img = ax.imshow(slice_data.T, cmap='plasma', origin='lower', vmin=0, vmax=125)  # Transpose for correct orientation
            ax.add_patch(Rectangle(
                (x_start, y_start),  # Rectangle bottom-left corner
                roi_size[0],         # Width of the rectangle
                roi_size[1],         # Height of the rectangle
                edgecolor='red',
                facecolor='none',
                linewidth=2
            ))
            ax.set_title(f"Slice {slice_index} with 2D ROI")
            ax.set_xlabel("X-axis (voxels)")
            ax.set_ylabel("Y-axis (voxels)")


            # Add tSNR value as text on the figure
            ax.text(
                5, 5,  # Coordinates for text placement (in axes units or pixel coordinates)
                f"ROI tSNR: {mean_val:.2f}",
                color='white',
                fontsize=12,
                backgroundcolor='black'
            )
            cbar = fig.colorbar(img, ax=ax, orientation="vertical", shrink=0.8)
            cbar.set_label("tSNR")

            # Save the figure to a file
            output_path = os.path.join(root_path, folder, "slice_with_tsnr.png")
            #output_path = "/path/to/save/figure_with_tsnr.png"
            plt.savefig(output_path, dpi=300, bbox_inches='tight')
            print(f"Figure saved at {output_path}")
            # Suppress plot display
            plt.close(fig)
            #plt.show()



           
            #sys.exit()

        except Exception as e:
            print(f"Error processing {nii_path}: {e}")
    else:
        print(f"File not found: {nii_path}")


#sys.exit()


# Define the data structure (adjust with actual computed means and stds)
means_big = np.array([
    means[0:5],  # MB1
    means[5:10],  # MB2
    means[10:15],  # MB3
    means[15:20],  # MB4
])

stds_big = np.array([
    stds[0:5],  # MB1
    stds[5:10],  # MB2
    stds[10:15],  # MB3
    stds[15:20],  # MB4
])

# Bar settings
labels = ['1', '2', '3', '4']  # Multiband factors
sense_factors = ['1', '1.5', '2', '2.5', '3']  # SENSE factors

width = 0.2  # Width of each bar


# Adjusted x positions with gaps between groups
x = np.array([0, 1, 2, 3]) * (1 + 0.05 * len(sense_factors))  # Add space after each group

#x = np.arange(len(labels))  # The label locations

# Colors
colors = ['#FFEDA0', '#FD8D3C', '#E31A1C', '#BD0026', '#800026']

# Create the bar chart
fig, ax = plt.subplots(figsize=(10, 6))
for i in range(means_big.shape[1]):  # Loop over SENSE factors

    #upper_error = stds_big[:, i, 0]  # Q3 - mean
    #lower_error = stds_big[:, i, 1]  # mean - Q1

    ax.bar(
        x + (i - 2) * width,  # Adjust x position for each SENSE factor
        means_big[:, i],
        yerr=stds_big[:, i],  # Asymmetrical IQR error bars
        width=width,
        label=f'SENSE {sense_factors[i]}',
        color=colors[i],
        capsize=4
    )

    #yerr=stds_big[:, i],

#yerr=[lower_error, upper_error],

# Add labels, title, and legend
ax.set_xlabel('Multiband factor')
ax.set_ylabel('Temporal Signal to Noise')
ax.set_title('tSNR by Multiband and SENSE Factors')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend(title='SENSE factor', loc='best')
ax.grid(axis='y', linestyle='--', alpha=0.6)
ax.set_ylim(0, 125) 

# Save the plot
#output_plot_path = "tSNR_bar_chart.png"
output_plot_path = root_path + "tSNR_bar_chart_ROI.png"

plt.tight_layout()
plt.savefig(output_plot_path, dpi=300)
print(f"Bar chart saved as {output_plot_path}")






