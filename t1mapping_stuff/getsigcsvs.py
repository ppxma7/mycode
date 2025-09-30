import os
import pandas as pd
import glob

# Define root directory
folder_path = "/Users/spmic/data/san/plotdir/cth_xlsx/"


# Get a list of all Excel files in the folder
xlsx_files = glob.glob(os.path.join(folder_path, "*.xlsx"))

# Initialize an empty list to store DataFrames
significant_dfs = []

# Loop through each Excel file
for file in xlsx_files:
    file_name = os.path.basename(file)
    print(f"Processing file: {file_name}")

    try:
        # Read the first sheet of the Excel file
        df = pd.read_excel(file)

        # Ensure the "P-value" column exists
        if "P-value" not in df.columns:
            print(f"Skipping {file_name}: No 'P-value' column found.")
            continue

        # Filter for significant differences (P-value < 0.05)
        significant_df = df[df["P-value"] < 0.01].copy()

        if not significant_df.empty:
            # Add a column for the source file
            significant_df["Source File"] = file_name
            significant_dfs.append(significant_df)
            print(f"Added {len(significant_df)} rows from {file_name}")

    except Exception as e:
        print(f"Error processing {file_name}: {e}")

# Concatenate all significant results into one DataFrame
if significant_dfs:
    final_df = pd.concat(significant_dfs, ignore_index=True)
    
    # Save to a new CSV file
    output_path = os.path.join(folder_path,"significant_differences.csv")
    final_df.to_csv(output_path, index=False)

    print(f"Significant differences saved to {output_path}")
else:
    print("No significant differences found in any files.")
