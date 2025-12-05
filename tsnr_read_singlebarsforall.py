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
import json


# This is python3 code that serves to plot tSNR barcharts, based on the output of qa_run_nopphase
PLOT_ONLY = "--plot-only" in sys.argv
# OPTION TO DO THIS if json is saved: python plot_tsnr.py --plot-only

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
#root_path = "/Users/spmic/data/qa_outputs_1p5/"
root_path = "/Volumes/DRS-7TfMRI/MB_artefact_021225/qa_outputs/"
#root_path = "/Users/spmic/data/qa_outputs_postGR_061125/"

folder_pattern = "qa_output*"

mode = 'doroi'  # Example mode


# Check mode and set ROI
if mode.lower() == 'doroi':
    ROI = 1
    tSNRmax = 170
elif mode.lower() == 'dogen':
    ROI = 0
    tSNRmax = 100
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


def extract_sort_key_new(folder_name):
    """
    Extract a numeric sort key from names like:
      XXXX_MB2_SENSE2p5_XXX_15_nordic
    Sorts by MB value first, then SENSE value.
    """
    # Extract MB value (e.g. MB2, MB2.5)
    mb_match = re.search(r"MB(\d+(?:\.\d+)?)", folder_name, re.IGNORECASE)
    mb_val = float(mb_match.group(1)) if mb_match else float('inf')

    # Extract SENSE value (e.g. SENSE2p5 → 2.5)
    sense_match = re.search(r"SENSE(\d+(?:p\d+)?)", folder_name, re.IGNORECASE)
    if sense_match:
        sense_val = float(sense_match.group(1).replace('p', '.'))
    else:
        sense_val = float('inf')

    return (mb_val, sense_val)




# Sort the subfolders using the combined key
# if "nordic" in root_path:
#     subfolders.sort(key=extract_numeric_suffix_nordic)
# else:
#     subfolders.sort(key=extract_numeric_suffix)
subfolders.sort(key=extract_sort_key_new)

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


if PLOT_ONLY:
    summary_path = os.path.join(root_path, "tsnr_roi_summary.json")
    with open(summary_path, "r") as f:
        summary = json.load(f)

    folder_labels = summary["folders"]
    means = summary["means"]
    stds = summary["stds"]

    print("Loaded cached tSNR values – skipping image generation")

else:

    for folder in subfolders:
        print(folder)
        nii_path = os.path.join(root_path, folder, "tsnr_tsnr_map.nii.gz")
        
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
                roi_center = (40, 50)
                roi_size = (20, 20)  # (width, height) of the ROI

                # Calculate ROI bounds in 2D
                x_start = max(roi_center[0] - roi_size[0] // 2, 0)
                x_end = min(roi_center[0] + roi_size[0] // 2, data_shape[0])
                y_start = max(roi_center[1] - roi_size[1] // 2, 0)
                y_end = min(roi_center[1] + roi_size[1] // 2, data_shape[1])

                # Extract the 2D ROI data
                #slice_index = round(data_shape[2] * 2 / 3)
                slice_index = 24
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

    summary = {
        "folders": folder_labels,
        "means": means,
        "stds": stds,
    }

    summary_path = os.path.join(root_path, "tsnr_roi_summary.json")
    with open(summary_path, "w") as f:
        json.dump(summary, f, indent=2)

    print(f"Saved tSNR summary to {summary_path}")

# end of for loop

# Define the data structure (adjust with actual computed means and stds)
# =========================
# SIMPLE PER-FOLDER BAR PLOT
# =========================

plot_labels = [
    "MB2_SENSE2",
    "MB2_SENSE2p5",
    "MB2_SENSE3",
    "MB3_SENSE2",
    "MB3_SENSE2_run2",
    "MB3_SENSE2_shift",
    "MB3_SENSE2_shift_run2",
    "MB3_SENSE2p5",
    "MB3_SENSE3",
    "MB4_SENSE2",
    "MB4_SENSE2p5",
    "MB4_SENSE3",
]
# Convert to numpy arrays
means_arr = np.array(means)
stds_arr = np.array(stds)

x = np.arange(len(means_arr))

fig, ax = plt.subplots(figsize=(max(10, len(means_arr) * 0.6), 6))

ax.bar(
    x,
    means_arr,
    yerr=stds_arr,
    capsize=4,
    color='#4C72B0',
    edgecolor='black'
)

# Labels and titles
ax.set_xlabel('Scan / Folder')
ax.set_ylabel('Temporal Signal to Noise')
ax.set_title('ROI tSNR per Acquisition (Exploratory)')

ax.set_ylim(0, 100)
ax.grid(axis='y', linestyle='--', alpha=0.6)

# Optional: readable x-labels (trim long folder names)
short_labels = [
    re.sub(r"qa_output_", "", f) for f in folder_labels
]

ax.set_xticks(x)
ax.set_xticklabels(plot_labels, rotation=45, ha='right', fontsize=9)

plt.tight_layout()

# Save
if ROI == 1:
    output_plot_path = os.path.join(root_path, "tSNR_bar_chart_roi_per_folder.png")
else:
    output_plot_path = os.path.join(root_path, "tSNR_bar_chart_gen_per_folder.png")

plt.savefig(output_plot_path, dpi=300)
plt.close()

print(f"Per-folder bar chart saved as {output_plot_path}")
