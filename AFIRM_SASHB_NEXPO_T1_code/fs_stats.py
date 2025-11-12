import os
import pandas as pd
import matplotlib.pyplot as plt
import sys
# Define root directory where all subject FreeSurfer stats files are stored
group_name = "NEXPO"
#root_dir = os.path.join("/Users/spmic/data/",group_name,"outputs")

# Where the output will be saved
#out_dir = os.path.join("/Volumes/nemosine/SAN/",group_name, "afirm_new_outs")
out_dir = os.path.join("/Volumes/DRS-GBPerm/other/outputs/")



# Where the freesurfer folders are
root_dir = out_dir

#subjects = ["16469-002A", "16500-002B", "16501-002b", "16521-001b3", "16523_002b", "16602-002B", "16707-002A", "16708-03A"]  # Add more subjects here
#subjects = ["16905_004", "16905_005", "17880001", "17880002"]

subjects = [
"15999_003", "16121_002", "16122_002", "16154_002", "16404_004",
"16466_002", "16467_002", "16621_002", "16787_002", "16788_002",
"16793_006", "16871_002", "16910_002", "16911", "16985_002",
"16986_002", "16987_002", "17038_002", "17040_002", "17041_002",
"17073_002", "17074_002", "17076_002", "17080_002", "17083_002",
"17084_002", "17086_002", "17102_002", "17103_002", "17105_002",
"17108_002", "17111_002", "17127_002", "17128_002", "17129_002",
"17173_002", "17178_002", "17221_002", "17324_002", "17341_002",
"17577_002", "17580_002", "17581_002", "17589_002", "17594_002",
"17596_002", "17606_002", "17607_002", "17610_002", "17617_002",
"09376_062", "09849", "10469", "12162_005", "12219_006",
"12294", "12305_004", "12428_005", "12838_004", "12869_016",
"12929_004", "13006_004", "13673_015", "13676", "14007_003",
"16133_002", "16176_002", "16278_002", "16280_002", "16281_002",
"16283_002", "16321_002", "16322_002", "16388_002", "16419_002",
"16437_002", "16439_002", "16463_002", "16512_002", "16514_002",
"16528_002", "16544", "16568_002", "16618_002", "16623_002",
"16627_002", "16662_002", "16664_002", "16693_002", "16702_002",
"16725_002", "16728_005", "16775_002", "16866_002", "16878_002",
"17171_002", "17180_002", "17239_002", "17342_002", "17364_002",
"03143_174", "05017_014", "06398_005", "10760_130", "12181_004",
"12185_004", "12411_004", "12422_004", "12578_004", "12608_004",
"12967_004", "12969_004", "15721_009", "16043_002", "16044_002",
"16046_002", "16102_002", "16103_002", "16174_002", "16277_002",
"16279", "16282_002", "16296_002", "16297_002", "16298_002",
"16299_002", "16301_002", "16303_002", "16389_002", "16390_002",
"16418_002", "16438_002", "16462_002", "16464_002", "16465_002",
"16494_002", "16511_002", "16513_002", "16517", "16542_002",
"16570_002", "16615_002", "16661_002", "16663_002", "16701_002",
"16791_002", "16874_002", "17072_002", "17075_002", "17394_002",
"12487_003", "14342_003", "15951_002", "15955_002", "16014_002",
"16058_002", "16101_002", "16175_002", "16231_003", "16302_002",
"16377_002", "16430_002", "16543_002", "16569_002", "16613_002",
"16699_002", "16726_002", "16789_002", "16824_002", "17007_002",
"17104_002", "17176_002", "17207_002", "17208_002", "17210_002",
"17243_002", "17275_002", "17292_002", "17293_002", "17305_002",
"17348_002", "17395_002", "17449_002", "17453_002", "17456_002",
"17491_002", "17492_002", "17532_002", "17698_002", "17704_002",
"17706_002", "17723_002", "17765_002", "17769_002", "17930_002",
"18031_002", "18038_002", "18076_002", "18089_002", "18094_002"
]


# subjects = ["1688-002C", "15234-003B", "16469-002A", "16498-002A",
# "16500-002B", "16501-002b", "16521-001b", "16523_002b",
# "16602-002B", "16707-002A", "16708-03A", "16797-002C",
# "16798-002A", "16821-002A", "16835-002A", "16885-002A",
# "16994-002A", "16999-002B", "17057-002C", "17058-002A", "17059-002a", "17311-002b"]

#subjects = ["1688-002C"]


print(f"Number of subjects: {len(subjects)}")


# Run this twice, change hemisphere to "r" for right hemisphere
# hemisphere = "r"
# hemisphere = "l"  # Left hemisphere
hemisphere = "r"

# Define the stats file relative path
#stats_filename = f"analysis/anatMRI/T1/processed/FreeSurfer/stats/{hemisphere}h.aparc.a2009s.stats"

stats_filename = f"stats/{hemisphere}h.aparc.a2009s.stats"

# Initialize empty list to store DataFrames
all_data = []

# Loop through subjects
for idx, subject in enumerate(subjects):
    stats_path = os.path.join(root_dir, subject, stats_filename)
    
    if not os.path.exists(stats_path):
        print(f"Warning: Stats file not found for {subject}")
        continue
    
    # Read the file, skipping header lines (starting with #)
    with open(stats_path, "r") as file:
        lines = file.readlines()
    
    # Find where the actual data starts (after the last header line)
    for i, line in enumerate(lines):
        if line.startswith("# ColHeaders"):
            headers = line.strip().split()[2:]  # Extract headers after "# ColHeaders"
            data_start_idx = i + 1  # Data starts on the next line
            break
    
    # Read the data into a DataFrame
    data = [line.strip().split() for line in lines[data_start_idx:]]
    df = pd.DataFrame(data, columns=headers)
    
    # Convert numerical columns to float
    numeric_cols = ["NumVert", "SurfArea", "GrayVol", "ThickAvg", "ThickStd", "MeanCurv", "GausCurv", "FoldInd", "CurvInd"]
    df[numeric_cols] = df[numeric_cols].astype(float)
    
    # Add subject column
    df["Subject"] = subject

    # Determine group based on index (50 per group)
    if idx < 50:
        group_name = "NEXPO1"
    elif idx < 100:
        group_name = "NEXPO2"
    elif idx < 150:
        group_name = "NEXPO3"
    else:
        group_name = "NEXPO4"

    # Add group column
    df["Group"] = group_name  # Assign "SASHB" to all rows
    
    # Append to the list
    all_data.append(df)

# Combine all subjects into one DataFrame
df_all = pd.concat(all_data, ignore_index=True)

# Save table to show to user
output_csv_path = os.path.join(out_dir, f"freesurfer_stats_{hemisphere}_{group_name}.csv")
df_all.to_csv(output_csv_path, index=False)
print(f"Data saved to {output_csv_path}")

sys.exit(0)

# Set consistent y-axis limits (adjust values based on your data range)
ymin_gmv, ymax_gmv = 0, 15000  # Example values for GMV
ymin_thick, ymax_thick = 0.0, 5.0  # Example values for Thickness

# Loop through subjects and save each subject's plot separately
for subject in subjects:
    sub_df = df_all[df_all["Subject"] == subject]
    
    # Define output path for each subject
    output_plot_path = os.path.join(root_dir, subject, f"{subject}_{hemisphere}_gmv.png")
    
    # Create figure
    plt.figure(figsize=(12, 6))
    plt.scatter(sub_df["StructName"], sub_df["GrayVol"], alpha=0.6)
    
    plt.xlabel("Brain Region")
    plt.ylabel("Gray Matter Volume (mm³)")
    plt.title(f"Gray Matter Volume - {subject}")
    plt.xticks(rotation=90)
    plt.ylim(ymin_gmv, ymax_gmv)  # Set consistent y-axis limits
    plt.grid(True, linestyle="--", alpha=0.5)
    
    # Save figure instead of showing
    plt.tight_layout()
    plt.savefig(output_plot_path, dpi=300)
    plt.close()  # Close the figure to free memory
    print(f"Scatter plot saved for {subject}: {output_plot_path}")

# Loop through subjects and save each subject's bar chart separately
for subject in subjects:
    sub_df = df_all[df_all["Subject"] == subject]
    
    # Define output path for each subject
    output_plot_path = os.path.join(root_dir, subject, f"{subject}_{hemisphere}_ct_thick.png")

    # Create bar chart figure
    plt.figure(figsize=(12, 6))
    plt.bar(sub_df["StructName"], sub_df["ThickAvg"], label=f"{subject} - Thickness", alpha=0.7)
    plt.errorbar(sub_df["StructName"], sub_df["ThickAvg"], yerr=sub_df["ThickStd"], fmt="o", color="red", alpha=0.6)
    
    plt.xlabel("Brain Region")
    plt.ylabel("Cortical Thickness (mm)")
    plt.title(f"Cortical Thickness Across Brain Regions - {subject}")
    plt.xticks(rotation=90)
    plt.ylim(ymin_thick, ymax_thick)  # Set consistent y-axis limits
    plt.legend()
    plt.grid(True, linestyle="--", alpha=0.5)
    
    # Save figure instead of showing
    plt.tight_layout()
    plt.savefig(output_plot_path, dpi=300)
    plt.close()  # Close the figure to free memory
    print(f"Bar chart saved for {subject}: {output_plot_path}")

