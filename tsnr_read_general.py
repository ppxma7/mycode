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
# Root path for QA outputs
#root_path = "/Users/spmic/data/postDUST_HEAD_MBRES/qa_output_nordic_middle24/"
#root_path = "/Volumes/r15/DRS-7TfMRI/DUST_upgrade/postDUST/postDUST_QUAD_MBRES/qa_output_nordic_middle24/"
#root_path = "/Users/spmic/data/postDUST_HEAD_MBHIRES_1p25/qa_outputs/"
#root_path = "/Volumes/r15/DRS-7TfMRI/DUST_upgrade/postDUST/postDUST_MBSENSE_QUAD_200225/qa_outputs_middle24/"
root_path = "/Users/spmic/data/qa_outputs_1p5/"

folder_pattern = "qa_output*"

mode = 'doroi'  # Example mode


# Check mode and set ROI
if mode.lower() == 'doroi':
    ROI = 1
    tSNRmax = 400
elif mode.lower() == 'dogen':
    ROI = 0
    tSNRmax = 400
else:
    ROI = None  # Handle unexpected values if needed

# Dynamically find subfolders matching the pattern
subfolders = [
    folder for folder in os.listdir(root_path) 
    if os.path.isdir(os.path.join(root_path, folder)) and fnmatch.fnmatch(folder, folder_pattern)
]



# Function to extract the numeric suffix and type (raw or nordic)
def extract_sort_key(folder_name):
    # Extract numeric suffix
    match = re.search(r"_(\d+)_(nordic_)?clv$", folder_name)
    if match:
        numeric_part = int(match.group(1))
        type_part = 1 if match.group(2) == "nordic_" else 0  # Raw ('clv') comes first, then Nordic
        return numeric_part, type_part
    return float('inf'), float('inf')  # Fallback for unmatched folders

# Function to extract the numeric suffix from folder names
def extract_numeric_suffix(folder_name):
    match = re.search(r"_(\d+)_clipped$", folder_name)
    return int(match.group(1)) if match else float('inf')  # Use inf for folders without a match

def extract_numeric_suffix_str(folder_name):
    match = re.search(r"_(e\d+|ws)_clipped$", folder_name)  # Match e1, e2, or ws
    return match.group(1) if match else "zz"  # Sort 'ws' properly, and default to "zz" for unmatched cases

def extract_numeric_suffix_nordic(folder_name):
    match = re.search(r"_(\d+)_nordic_clipped$", folder_name)
    return int(match.group(1)) if match else float('inf')  # Use inf for folders without a match

# Sort the subfolders using the combined key
if "nordic" in root_path:
    subfolders.sort(key=extract_numeric_suffix_nordic)
else:
    subfolders.sort(key=extract_numeric_suffix)

# Print sorted subfolders to check the order
print("Sorted Subfolders:")
for folder in subfolders:
    print(folder)


#sys.exit()

# Initialize lists to store mean and STD for each folder
means = []
stds = []
folder_labels = []
#tSNRmax = 600
tSNRmin = -10
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
            #slice_index = 12  # The z-slice where the 2D ROI is located
            #roi_center = (35, 85)  # (x, y) center of the ROI
            #roi_center = (35, 70)  # (x, y) center of the ROI
            #roi_center = (45, 70)  # (x, y) center of the ROI
            #roi_center = (45, 60)  # (x, y) center of the ROI
            roi_center = (40, 82)
            roi_size = (20, 20)  # (width, height) of the ROI

            # Calculate ROI bounds in 2D
            x_start = max(roi_center[0] - roi_size[0] // 2, 0)
            x_end = min(roi_center[0] + roi_size[0] // 2, data_shape[0])
            y_start = max(roi_center[1] - roi_size[1] // 2, 0)
            y_end = min(roi_center[1] + roi_size[1] // 2, data_shape[1])

            # Extract the 2D ROI data
            #slice_index = round(data_shape[2] * 2 / 3)
            slice_index = 12
            print(f"Slice index: {slice_index}")

            slice_data = data[:, :, slice_index]
            roi_data = slice_data[x_start:x_end, y_start:y_end]

            # Print ROI shape
            print("2D ROI shape:", roi_data.shape)

            # UNCOMMENT FOR ROI
            # Flatten the data to 1D array
            if ROI == 1:
                flat_data = roi_data.flatten()
            else: 
                flat_data = data.flatten()

            # UNCOMMENT FOR ENTIRE IMAGE
            # Flatten the data to 1D array
            #flat_data = data.flatten()

            # Remove the bottom 1% of max
            max_val = np.max(flat_data)
            threshold = 0.01 * max_val
            filtered_data = flat_data[flat_data >= threshold]

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
            img = ax.imshow(slice_data.T, cmap='plasma', origin='lower', vmin=0, vmax=tSNRmax)  # Transpose for correct orientation
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


        except Exception as e:
            print(f"Error processing {nii_path}: {e}")
    else:
        print(f"File not found: {nii_path}")




# Define the data structure (adjust with actual computed means and stds)
# Correctly define means_big and stds_big (grouped by Raw and Nordic)
# means_big = np.array([
#     means[0:5],  # MB1
#     means[5:10],  # MB2
#     means[10:15],  # MB3
#     means[15:20],  # MB4
# ])

# stds_big = np.array([
#     stds[0:5],  # MB1
#     stds[5:10],  # MB2
#     stds[10:15],  # MB3
#     stds[15:20],  # MB4
# ])

means_big = np.array([
    means[0:3],  # MB2
    means[3:6],  # MB3
    means[6:9],  # MB4
])

stds_big = np.array([
    stds[0:3],  # MB2
    stds[3:6],  # MB3
    stds[6:9],  # MB4
])

sense_factors = ['2', '2.5', '3']  # SENSE factors
#sense_factors = ['2', '2.5', '3']  # SENSE factors

labels = ['2','3', '4']  # Multiband factors
x = np.array([0, 1, 2]) * (1 + 0.05 * len(sense_factors))
plotlen = 8

# if "60slc" in root_path:
#     means_big = np.array([
#     means[0:3],  # MB3
#     means[3:6],  # MB4
#     ])

#     stds_big = np.array([
#         stds[0:3],  # MB3
#         stds[3:6],  # MB4
#     ])
#     labels = ['3','4']  # Multiband factors
#     x = np.array([0, 1]) * (1 + 0.05 * len(sense_factors))  # Add space after each group
#     plotlen = 5

# else:
#     means_big = np.array([
#     means[0:3],  # MB2
#     means[3:6],  # MB3
#     means[6:9],  # MB4
#     means[9:12],  # MB5
#     ])

#     stds_big = np.array([
#         stds[0:3],  # MB2
#         stds[3:6],  # MB3
#         stds[6:9],  # MB4
#         stds[9:12],  # MB5
#     ])
#     labels = ['1','2','3', '4']  # Multiband factors
#     x = np.array([0, 1, 2, 3]) * (1 + 0.05 * len(sense_factors))
#     plotlen = 8


# means_big = np.array([
#     means[0:4],                      # MB2 (4 values)
#     np.append(np.nan, means[4:7]),   # MB3 (3 values + 1 NaN padding)
#     np.append(np.nan, means[7:10]),  # MB4 (3 values + 1 NaN padding)
# ])

# stds_big = np.array([
#     stds[0:4],                      # MB2 (4 values)
#     np.append(np.nan, stds[4:7]),   # MB3 (3 values + 1 NaN padding)
#     np.append(np.nan, stds[7:10]),  # MB4 (3 values + 1 NaN padding)
# ])


#labels = ['2','3','4']  # Multiband factors
#x = np.array([0, 1, 2]) * (1 + 0.05 * len(sense_factors))
#plotlen = 8

#sense_factors = ['e1', 'e2', 'ws']  # SENSE factors

#quick
# means_big = np.array([
#     means[0:3],  # MB3
# ])

# stds_big = np.array([
#     stds[0:3],  # MB3
# ])
# labels = ['3']  # Multiband factors
# x = np.array([0]) * (1 + 0.05 * len(sense_factors))
# plotlen = 4



# Bar settings
# Bar settings
# labels = ['1', '2', '3', '4']  # Multiband factors
# sense_factors = ['1', '1.5', '2', '2.5', '3']  # SENSE factors

#labels = ['2','3','4']  # Multiband factors


#labels = ['3', '4']  # Multiband factors
#sense_factors = ['2', '2.5', '3']  # SENSE factors


width = 0.2  # Width of each bar

# Adjusted x positions with gaps between groups
#x = np.array([0, 1, 2, 3]) * (1 + 0.05 * len(sense_factors))  # Add space after each group

#x = np.array([0, 1, 2]) * (1 + 0.05 * len(sense_factors))  # Add space after each group
#x = np.array([0, 1]) * (1 + 0.05 * len(sense_factors))  # Add space after each group

#x = np.arange(len(labels))  # The label locations

# Adjusted x positions for each scan
#x = np.arange(len(labels))  # Base positions for each scan
#x = np.arange(len(labels)) * 0.5  #

# Colors
#unique_color = '#2ca02c'  # Unique color for SENSE 1.8
colors = ['#FFEDA0', '#FD8D3C', '#E31A1C', '#BD0026', '#800026']

#Colors for groups
#colors = ['#1f77b4', '#ff7f0e']  # Raw (blue) and Nordic (orange)

#Create the bar chart
fig, ax = plt.subplots(figsize=(plotlen, 6))
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

# # Use this if you have uneven 2D Numpy arrays
# fig, ax = plt.subplots(figsize=(plotlen, 6))
# for row in range(means_big.shape[0]):     # Loop over MB factors (rows)
#     for col in range(means_big.shape[1]):   # Loop over SENSE factors (columns)
        
#         # Skip if the specific MB/SENSE value is NaN
#         if np.isnan(means_big[row, col]):
#             continue
        
#         # For the SENSE 1.8 column (col==0)
#         # Use unique_color only for MB2 (row==0), otherwise use the standard color (first in list)
#         if col == 0:
#             bar_color = unique_color if row == 0 else colors[0]
#         else:
#             # For SENSE 2, 2.5, 3, use the standard colors
#             bar_color = colors[col - 1]
        
#         # Calculate x position: assuming 'x' is defined for each MB factor (row)
#         x_pos = x[row] + (col - 2) * width
        
#         ax.bar(
#             x_pos,
#             means_big[row, col],
#             yerr=stds_big[row, col],
#             width=width,
#             label=f'MB{row+2} SENSE {sense_factors[col]}',
#             color=bar_color,
#             capsize=4
#         )


# Add labels, title, and legend
ax.set_xlabel('Multiband factor')
ax.set_ylabel('Temporal Signal to Noise')
ax.set_title('tSNR by Multiband and SENSE Factors')
#ax.set_title('tSNR DE')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend(title='SENSE', loc='best')
ax.grid(axis='y', linestyle='--', alpha=0.6)
ax.set_ylim(tSNRmin, tSNRmax) 

# Save the plot
if ROI == 1:
    output_plot_path = root_path + "tSNR_bar_chart_roi.png"
else:
    output_plot_path = root_path + "tSNR_bar_chart_gen.png"

print(output_plot_path)

#output_plot_path = root_path + "tSNR_bar_chart_ROI.png"

plt.tight_layout()
plt.savefig(output_plot_path, dpi=300)
print(f"Bar chart saved as {output_plot_path}")

