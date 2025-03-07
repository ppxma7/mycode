import os
import json
import numpy as np
import matplotlib.pyplot as plt
import sys

# Directory containing JSON files
#json_dir = "/Users/spmic/data/preDUST_HEAD_MBSENSE/magnitude/raw_clv/fRAT_analysis_withnoisescan/forplotting_summarised"
#json_dir = "/Volumes/DRS-7TfMRI/preDUST/preDUST_HEAD_MBSENSE/magnitude/nordic_clv/fRAT_analysis/forplotting_summarised"
#json_dir = "/Users/spmic/data/postDUST_HEAD_MBRES/fRAT_raw/forplotting_summarised_tsnr"

root_path = "/Users/spmic/data/postDUST_HEAD_MBHIRES_1p25/fRAT_raw/"
json_dir = os.path.join(root_path, "forplotting_summarised_isnr")

thisylim = 120
# Parse JSON files and extract data
data = []
for filename in os.listdir(json_dir):
    if filename.endswith(".json"):
        filepath = os.path.join(json_dir, filename)
        with open(filepath, "r") as f:
            json_data = json.load(f)
        
        #print(json.dumps(json_data, indent=4))

        #print(json_data.keys())
        #print(json.dumps(json_data["Overall"], indent=4))

        overall_data = json_data.get("Overall", {})
        # Check if JSON data is a list or dict
        # if isinstance(json_data, dict):
        #     overall_data = json_data.get("Overall", {})
        # elif isinstance(json_data, list):
        #     # Find "Overall" in the list
        #     overall_data = None
        #     for item in json_data:
        #         if "Overall" in item:
        #             overall_data = item["Overall"]
        #             break
        #     if overall_data is None:
        #         print(f"No 'Overall' ROI found in {filename}")
        #         continue
        # else:
        #     print(f"Unexpected JSON structure in {filename}")
        #     continue

        # Extract Multiband and SENSE factors from filename
        parts = filename.split("_")
        mb_factor = parts[0].replace("MBmb", "")
        #sense_factor = parts[1].replace("SENSEsense", "")
        sense_factor = parts[1].replace("SENSEsense", "").replace(".json", "")  # Remove .json


        print(filename)
        #print(mb_factor)
        #print(sense_factor)
        
        # Extract relevant metrics
        mean = overall_data.get("Mean", np.nan)
        std_dev = overall_data.get("Std_dev", np.nan)
        conf_int = overall_data.get("Conf_Int_95", np.nan)
        
        data.append({
            "MB": int(mb_factor),
            "SENSE": float(sense_factor),
            "Mean": mean,
            "Std_dev": std_dev,
            "Conf_Int": conf_int,
        })

#sys.exit(0)

# Convert data to structured array for easier sorting and grouping
data = sorted(data, key=lambda x: (x["MB"], x["SENSE"]))

# Prepare data for plotting
mb_factors = sorted(set(d["MB"] for d in data))
sense_factors = sorted(set(d["SENSE"] for d in data))
means = np.zeros((len(mb_factors), len(sense_factors)))
std_devs = np.zeros_like(means)

for d in data:
    mb_idx = mb_factors.index(d["MB"])
    sense_idx = sense_factors.index(d["SENSE"])
    means[mb_idx, sense_idx] = d["Mean"]
    std_devs[mb_idx, sense_idx] = d["Std_dev"]
    print(d["MB"])


# Plot the bar chart
x = np.arange(len(mb_factors))  # Multiband factors
width = 0.15  # Bar width
# Colors
colors = ['#FFEDA0', '#FD8D3C', '#E31A1C', '#BD0026', '#800026']

fig, ax = plt.subplots(figsize=(8, 6))

for i, sense in enumerate(sense_factors):
    print(sense)
    ax.bar(
        x + i * width,
        means[:, i],
        width,
        yerr=std_devs[:, i],
        label=f"SENSE {sense}",
        color=colors[i],
        capsize=4,
    )

# Add labels, title, and legend
if "tsnr" in json_dir:
    ax.set_ylabel("Temporal Signal to Noise (Mean)")
    ax.set_title("tSNR by Multiband and SENSE Factors")
else:
    ax.set_ylabel("Image Noise to Signal Ratio (Mean)")
    ax.set_title("iSNR by Multiband and SENSE Factors")

ax.set_xlabel("Multiband factor")
ax.set_xticks(x + width * (len(sense_factors) - 1) / 2)
ax.set_xticklabels(mb_factors)
ax.grid(axis='y', linestyle='--', alpha=0.6)
ax.legend(title="SENSE factor")
ax.set_ylim(0, thisylim) 

# Show the plot
plt.tight_layout()
#plt.show()

#output_plot_path = root_path + "iSNR_bar_chart_frat.png"

# Save the plot
if "tsnr" in json_dir:
    output_plot_path = root_path + "tSNR_bar_chart_frat.png"
else:
    output_plot_path = root_path + "iSNR_bar_chart_frat.png"


plt.tight_layout()
plt.savefig(output_plot_path, dpi=300)
print(f"Bar chart saved as {output_plot_path}")
