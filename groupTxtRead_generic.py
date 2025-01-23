import pandas as pd
import os

# Define the root folder path and specify subfolders to search
#root_folder_path = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Pain Relief Grant - General/PFP_results/spmexcelfiles_3t/'
#root_folder_path = '/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - Touchmap - Touchmap/results/restingstate/'
root_folder_path = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_210125/shortened_trials_Tap/'
#root_folder_path = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/Claire_fmrs/090125_fmrs_AB/'
#subfolders_to_search = ['scan1_vs_scan2', 'kiwi_vs_mtx','red_vs_green','red_vs_mtx']  # List the specific subfolders you want to search
#subfolders_to_search = ['cttouch']  # List the specific subfolders you want to search
#subfolders_to_search = ['lowpush','1barpush','lowtap','1bartap']
subfolders_to_search = ['lowtap','1bartap']

# Create an empty DataFrame to store all data
all_data = pd.DataFrame()

# Flag to track the first file (for keeping the header)
is_first_file = True

# Iterate through the specified subfolders
for subfolder in subfolders_to_search:
    full_subfolder_path = os.path.join(root_folder_path, subfolder)
    
    # Walk through only the selected subfolder and its subdirectories
    for dirpath, _, filenames in os.walk(full_subfolder_path):
        for filename in filenames:
            # # Skip the 'labelsatlas.txt' file
            # if filename == 'labelsatlas.txt':
            #     continue
            print(f"Found file: {filename}")
            print(f"Looking into subfolder: {full_subfolder_path}")

            if filename.endswith('.csv'):
                file_path = os.path.join(dirpath, filename)

                file_path = os.path.join(dirpath, filename)
                print(f"Reading file: {file_path}")
                data = pd.read_csv(file_path)
                #print(f"Data shape: {data.shape}")
                
                # If it's the first file, read with header; otherwise, skip the header
                # this is for when you have spaces in your headers
                # if is_first_file:
                #     data = pd.read_csv(file_path, delim_whitespace=False, sep=r'\s{2,}', engine='python')  # Adjust delimiter if necessary
                #     is_first_file = False  # Set flag to False after the first file
                # else:
                #     data = pd.read_csv(file_path, delim_whitespace=False, sep=r'\s{2,}', engine='python', header=0)  # Skip the header row

                # Read the CSV file into a DataFrame with header
                data = pd.read_csv(file_path)

                # Add a new column for the subfolder name
                data['Subfolder'] = subfolder

                # Add a new column for the text file name
                data['Label'] = filename.split('.')[0]
                
                # Append the data to the all_data DataFrame
                all_data = pd.concat([all_data, data], ignore_index=True)

# Reorder the columns so that 'Subfolder' is the first column
cols = all_data.columns.tolist()
cols = cols[-2:] + cols[:-2]  # Move the 'Subfolder' column to the front
all_data = all_data[cols]

# Save the combined DataFrame to an Excel file

output_file = os.path.join(root_folder_path, 'combined.xlsx')
#output_file = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - Touchmap - Touchmap/results/restingstate/rs_combined.xlsx'

#output_file = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Pain Relief Grant - General/PFP_results/spmexcelfiles_3t/cttouch_combined.xlsx'
all_data.to_excel(output_file, index=False)

# Display the first few rows of the combined DataFrame
print(all_data.head())



#Load the combined Excel file
# combined_file_path = os.path.join(root_folder_path, 'combined.xlsx')
# all_data = pd.read_excel(combined_file_path)

# # Clean up the 'Cluster (x,y,z)' column to remove leading/trailing spaces
# all_data['Cluster (x,y,z)'] = all_data['Cluster (x,y,z)'].str.strip()

# # Use a more flexible regex to extract coordinates
# # This regex accounts for optional spaces and captures all numeric formats
# all_data[['X', 'Y', 'Z']] = all_data['Cluster (x,y,z)'].str.extract(r'([-+]?\d+)\s+([-+]?\d+)\s+([-+]?\d+)')

# # Convert the new columns to numeric, handling errors if any
# all_data['X'] = pd.to_numeric(all_data['X'], errors='coerce')
# all_data['Y'] = pd.to_numeric(all_data['Y'], errors='coerce')
# all_data['Z'] = pd.to_numeric(all_data['Z'], errors='coerce')

# # Save the updated DataFrame back to Excel
# #output_file = 'rs_combined_output.xlsx'
# output_file = os.path.join(root_folder_path, 'combined_output.xlsx')
# all_data.to_excel(output_file, index=False)




