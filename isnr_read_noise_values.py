import os
import fnmatch
import re
import matplotlib.pyplot as plt


#root_path = "/Volumes/DRS-7TfMRI/DUST_upgrade/preDUST/preDUST_HEAD_MBSENSE/qa_output_middle24_noisevals/"
#root_path = "/Volumes/DRS-7TfMRI/DUST_upgrade/postDUST/postDUST_MBSENSE_HEAD_200225/qa_output_middle24_realnoisevals/"
root_path = "/Users/spmic/data/postDUST_HEAD_noise_250225/qa_outputs_middle24/"


folder_pattern = "qa_output*"

subfolders = [
    folder for folder in os.listdir(root_path) 
    if os.path.isdir(os.path.join(root_path, folder)) and fnmatch.fnmatch(folder, folder_pattern)
]

# Sort the subfolders using the numeric suffix from folder names
# Function to extract the numeric suffix from folder names
def extract_numeric_suffix(folder_name):
    match = re.search(r"_(\d+)_clipped$", folder_name)
    return int(match.group(1)) if match else float('inf')  # Use inf for folders without a match


# Sort the subfolders using the combined key
subfolders.sort(key=extract_numeric_suffix)

# Initialize a list to store the noise values
noise_values = []
folder_labels = []

# Function to extract the Noise value from the script_outputs.txt file

def extract_noise_value(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        # Look for the line containing "Noise value used for iSNR"
        match = re.search(r"Noise value used for iSNR:\s*([\d\.]+)", content, re.DOTALL)
        if match:
            return float(match.group(1))
        else:
            # Print for debugging if the match fails
            print(f"No match found in {file_path}")
    return None

# Iterate over each folder to extract the noise values
for folder in subfolders:
    print(f"Processing folder: {folder}")
    
    script_output_path = os.path.join(root_path, folder, "script_outputs.txt")
    
    if os.path.exists(script_output_path):
        noise_value = extract_noise_value(script_output_path)
        print(f"Noise value: {noise_value}")
        if noise_value is not None:
            noise_values.append(noise_value)
            folder_labels.append(folder)
        else:
            print(f"Warning: No noise value found in {script_output_path}")
    else:
        print(f"Warning: {script_output_path} does not exist")

# # Print extracted noise values for each folder
# for label, noise in zip(folder_labels, noise_values):
#     print(f"Folder: {label}, Noise value: {noise:.2f}")



# Define the pattern for the labels
# mb_factors = ['MB1', 'MB2', 'MB3', 'MB4']
# sense_factors = ['1', '1.5', '2', '2.5', '3']

# # Create folder labels in the desired order
# folder_labels = [f"{mb} Sense {sense}" for mb in mb_factors for sense in sense_factors]

# Define fixed series
fixed_series = [
    ('MB1', 'Sense 1', '40ch'),
    ('MB1', 'Sense 2', '40ch'),
    ('MB2', 'Sense 1', '40ch'),
    ('MB2', 'Sense 2', '40ch'),
    ('MB2', 'Sense 2', '32ch'),
    ('MB2', 'Sense 1', '32ch'),
    ('MB3', 'Sense 3', '32ch'),
    ('MB3', 'Sense 3', '40ch')
]

# Create folder labels
folder_labels = [f"{mb} {sense} {ch}" for mb, sense, ch in fixed_series]

# Print result
for label in folder_labels:
    print(label)

# Plot the data with the new labels
plt.figure(figsize=(10, 6))
plt.plot(folder_labels, noise_values, marker='o')
plt.xlabel('Folder')
plt.ylabel('Noise value')
plt.title('Noise value used for iSNR across Folders')
plt.xticks(rotation=45, ha='right')
plt.ylim([0, 1200])  # Adjust as needed

plt.tight_layout()
# Save the plot
output_plot_path = root_path + "isnr_noise.png"
plt.savefig(output_plot_path, dpi=300)
print(f"chart saved as {output_plot_path}")

