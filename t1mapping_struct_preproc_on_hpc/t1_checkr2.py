import os
import numpy as np
import pandas as pd
import nibabel as nib
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import mode  # Add this at the top of your script

# Define root and output directories
root_dir = "/Volumes/DRS-GBPerm/other/t1mapping_out"
out_dir = "/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_plots"
group_name = "NEXPO"
csv_path = os.path.join(out_dir, f"{group_name}_r2_qc_stats.csv")

# Subject list

subjects = [
    "03143_174", "05017_014", "06398_005", "09376_062", "09849", "10469", "10760_130", "12162_005",
    "12181_004", "12185_004", "12219_006", "12294", "12305_004", "12411_004", "12422_004", "12428_005",
    "12487_003", "12578_004", "12608_004", "12838_004", "12869_016", "12929_004", "12969_004", "13006_004",
    "13673_015", "13676", "14007_003", "14342_003", "15721_009", "15951_002", "15955_002", "15999_003",
    "16014_002", "16043_002", "16046_002", "16058_002", "16101_002", "16102_002", "16103_002", "16121_002",
    "16122_002", "16133_002", "16154_002", "16174_002", "16175_002", "16176_002", "16231_003", "16277_002",
    "16278_002", "16280_002", "16281_002", "16282_002", "16283_002", "16296_002", "16297_002", "16298_002",
    "16299_002", "16301_002", "16302_002", "16303_002", "16321_002", "16322_002", "16377_002", "16388_002",
    "16389_002", "16390_002", "16404_004", "16418_002", "16419_002", "16430_002", "16437_002", "16438_002",
    "16439_002", "16462_002", "16463_002", "16464_002", "16465_002", "16466_002", "16467_002", "16494_002",
    "16511_002", "16512_002", "16513_002", "16514_002", "16517", "16528_002", "16542_002", "16543_002",
    "16544", "16568_002", "16570_002", "16613_002", "16615_002", "16618_002", "16621_002", "16623_002",
    "16627_002", "16661_002", "16662_002", "16663_002", "16693_002", "16699_002", "16701_002", "16702_002",
    "16725_002", "16726_002", "16728_005", "16775_002", "16787_002", "16788_002", "16789_002", "16791_002",
    "16793_006", "16824_002", "16866_002", "16871_002", "16874_002", "16878_002", "16910_002", "16911",
    "16985_002", "16986_002", "16987_002", "17007_002", "17038_002", "17040_002", "17041_002", "17072_002",
    "17073_002", "17074_002", "17075_002", "17076_002", "17080_002", "17083_002", "17084_002", "17086_002",
    "17102_002", "17103_002", "17104_002", "17108_002", "17111_002", "17127_002", "17128_002", "17129_002",
    "17171_002", "17173_002", "17176_002", "17178_002", "17180_002", "17207_003", "17208_002", "17210_002",
    "17221_002", "17239_002", "17243_002", "17275_002", "17293_002", "17305_002", "17324_002", "17341_002",
    "17342_002", "17348_002", "17364_002", "17394_002", "17395_002", "17449_002", "17453_002", "17456_002",
    "17491_002", "17492_002", "17532_002", "17577_002", "17580_002", "17581_002", "17589_002", "17594_002",
    "17596_002", "17606_002", "17607_002", "17610_002", "17617_002", "17698_002", "17704_002", "17706_002",
    "17723_002", "17765_002", "17769_002", "17930_002", "18031_002", "18038_002", "18076_002", "18094_002"
]

#print(f"Number of subjects: {len(subjects)}")


# === Load or compute ===
if os.path.exists(csv_path):
    print(f"📄 Found existing CSV: {csv_path}")
    df = pd.read_csv(csv_path)


else:
# Prepare dataframe to hold stats
    stats_list = []

    print(f"Number of subjects: {len(subjects)}")

    for subject in subjects:
        print(f"⏳ Processing {subject}")
        r2_img_path = os.path.join(root_dir, subject, f"{subject}_R2.nii.gz")

        if not os.path.exists(r2_img_path):
            print(f"❌ File not found: {r2_img_path}")
            continue

        # Load R2 map
        r2_img = nib.load(r2_img_path)
        r2_data = r2_img.get_fdata()
        r2_data = r2_data[np.isfinite(r2_data)]  # Remove NaNs/Infs

        if r2_data.size == 0:
            print(f"⚠️ No valid R2 values in {subject}")
            continue

        # Compute statistics

        r2_nonzero = r2_data[r2_data > 0]

        mode_val = mode(r2_nonzero, keepdims=False).mode
        stats = {
            "subject": subject,
            "mean": np.mean(r2_nonzero),
            "median": np.median(r2_nonzero),
            "mode": mode_val,
            "std": np.std(r2_nonzero),
            "iqr": np.percentile(r2_nonzero, 75) - np.percentile(r2_nonzero, 25),
            "min": np.min(r2_nonzero),
            "max": np.max(r2_nonzero),
            "n_voxels": len(r2_nonzero)
        }
        stats_list.append(stats)

    # Save to CSV
    df = pd.DataFrame(stats_list)
    df.to_csv(csv_path, index=False)
    print(f"✅ Stats saved to: {csv_path}")

 # === Identify outliers ===
Q1_med = df["median"].quantile(0.25)
Q3_med = df["median"].quantile(0.75)
IQR_med = Q3_med - Q1_med
df["median_outlier"] = (df["median"] < (Q1_med - 1.5 * IQR_med)) | (df["median"] > (Q3_med + 1.5 * IQR_med))

df["mode_outlier"] = False
df_mode = df.dropna(subset=["mode"])
df.loc[df_mode.index, "mode_z"] = (df_mode["mode"] - df_mode["mode"].mean()) / df_mode["mode"].std()
df.loc[df_mode.index, "mode_outlier"] = df.loc[df_mode.index, "mode_z"].abs() > 2.5

csv_path2 = os.path.join(out_dir, f"{group_name}_r2_qc_stats_outliers.csv")

if os.path.exists(csv_path2):
    print(f"📄 Found existing CSV: {csv_path2}")
    df = pd.read_csv(csv_path2)
else:   
    print(f"📄 Saving outlier stats to: {csv_path2}")
    df.to_csv(csv_path2, index=False)

# Combine all outlier subjects
outlier_subjects = df[df["median_outlier"] | df["mode_outlier"]]["subject"].unique()

# Save to text file
outlier_txt_path = os.path.join(out_dir, f"{group_name}_r2_outlier_subjects.txt")
with open(outlier_txt_path, "w") as f:
    for subj in outlier_subjects:
        f.write(f"{subj}\n")

print(f"📄 Outlier subject list saved to:\n{outlier_txt_path}")

plt.figure(figsize=(12, 6))

# Add "mode" to the list of columns
columns_to_plot = ["mean", "median", "mode", "std", "iqr"]

sns.boxplot(data=df[columns_to_plot], palette="pastel")
sns.stripplot(data=df[columns_to_plot],
              jitter=True, color='black', size=4, alpha=0.6)

plt.title("R2 Distribution Statistics Across Subjects (with Mode)")
plt.ylabel("R2 Value")
plt.grid(True)
plt.tight_layout()

plot_path = os.path.join(out_dir, f"{group_name}_r2_qc_plot.png")
plt.savefig(plot_path)
print(f"📊 Boxplot saved to: {plot_path}")