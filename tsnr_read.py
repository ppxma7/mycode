import os
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
from scipy.stats import norm
import seaborn as sns

# Confidence interval critical value for 95% (z = 1.96 for a normal distribution)
z = norm.ppf(0.975)  # 95% confidence

# Prepare data for swarm plot
swarm_data = []
swarm_positions = []
grouped_x_positions = []  # Track grouped positions for each multiband factor


# Define the root path and subfolder names
root_path = "/Users/spmic/data/preDUST_FUNSTAR_MBSENSE_090125/"
subfolders = [
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE1_24slc_2p5mm_20250109162844_7_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE1p5_30slc_2p5mm_20250109162844_8_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE2_30slc_2p5mm_20250109162844_9_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE2p5_30slc_2p5mm_20250109162844_10_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE3_30slc_2p5mm_20250109162844_11_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE1_36slc_2p5mm_20250109162844_12_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE1p5_36slc_2p5mm_20250109162844_13_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE2_36slc_2p5mm_20250109162844_14_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE2p5_36slc_2p5mm_20250109162844_15_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE3_36slc_2p5mm_20250109162844_16_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE1_36slc_2mm_20250109162844_17_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE1p5_36slc_2p5mm_20250109162844_18_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE2_36slc_2p5mm_20250109162844_19_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE2p5_36slc_2p5mm_20250109162844_20_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE3_36slc_2p5mm_20250109162844_21_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE1_36slc_2mm_20250109162844_22_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE1p5_36slc_2mm_20250109162844_23_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE2_36slc_2mm_20250109162844_24_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE2p5_36slc_2mm_20250109162844_25_clv",
    "qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE3_36slc_2mm_20250109162844_26_clv",
]

# Initialize lists to store mean and STD for each folder
means = []
stds = []
folder_labels = []

# Process each folder
for folder in subfolders:
    nii_path = os.path.join(root_path, folder, "classic_tsnr_tsnr_map.nii.gz")
    
    if os.path.exists(nii_path):
        try:
            # Load the NIfTI file
            nii = nib.load(nii_path)
            data = nii.get_fdata()

            # Flatten the data to 1D array
            flat_data = data.flatten()

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
            stds.append(iqr_error)
            folder_labels.append(folder)

            print(f"Processed {folder}: Mean = {mean_val}, STD = {std_val}, SEM = {sem_val}, CI = {ci_error}, IQR = {iqr_error}")
        except Exception as e:
            print(f"Error processing {nii_path}: {e}")
    else:
        print(f"File not found: {nii_path}")




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

    upper_error = stds_big[:, i, 0]  # Q3 - mean
    lower_error = stds_big[:, i, 1]  # mean - Q1

    ax.bar(
        x + (i - 2) * width,  # Adjust x position for each SENSE factor
        means_big[:, i],
        yerr=[lower_error, upper_error],  # Asymmetrical IQR error bars
        width=width,
        label=f'SENSE {sense_factors[i]}',
        color=colors[i],
        capsize=4
    )

    #yerr=stds_big[:, i],

# Add labels, title, and legend
ax.set_xlabel('Multiband factor')
ax.set_ylabel('Temporal Signal to Noise')
ax.set_title('tSNR by Multiband and SENSE Factors')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend(title='SENSE factor', loc='best')
ax.grid(axis='y', linestyle='--', alpha=0.6)

# Save the plot
#output_plot_path = "tSNR_bar_chart.png"
output_plot_path = root_path + "tSNR_bar_chart.png"

plt.tight_layout()
plt.savefig(output_plot_path, dpi=300)
print(f"Bar chart saved as {output_plot_path}")




# # Plot the results
# plt.figure(figsize=(12, 6))

# # Plot mean values
# plt.subplot(2, 1, 1)
# plt.plot(folder_labels, means, marker='o', label='Mean')
# plt.title('Mean of Filtered tSNR Map')
# plt.xticks(rotation=90, fontsize=8)
# plt.ylabel('Mean')
# plt.grid()

# # Plot STD values
# plt.subplot(2, 1, 2)
# plt.plot(folder_labels, stds, marker='o', label='STD', color='orange')
# plt.title('STD of Filtered tSNR Map')
# plt.xticks(rotation=90, fontsize=8)
# plt.ylabel('Standard Deviation')
# plt.xlabel('Folders')
# plt.grid()

# #plt.tight_layout()
# #plt.show()

# # Save the plot as a PNG
# output_plot_path = root_path + "tSNR_mean_std_plot.png"
# plt.tight_layout()
# plt.savefig(output_plot_path, dpi=300)
# print(f"Plot saved as {output_plot_path}")

