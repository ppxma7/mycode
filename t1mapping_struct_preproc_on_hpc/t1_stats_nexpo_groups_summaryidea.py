import pandas as pd
import os
import seaborn as sns
import matplotlib.pyplot as plt

root_dir = "/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_plots/anova_stats/"
hemisphere = "L"
fs_filename = os.path.join(root_dir, f"mult_{hemisphere}_t1_tbldombig.xlsx")
output_csv = os.path.join(root_dir, f"mult_{hemisphere}_t1_tbldombig_summary.csv")
output_mat = os.path.join(root_dir, f"mult_{hemisphere}_t1_tbldombig_summary_mat.xlsx")
plot_filename = os.path.join(root_dir, f"mult_{hemisphere}_t1_tbldombig_summary_plot.png")

df = pd.read_excel(fs_filename)
summary = df[['Region', 'Group A', 'Group B', 'P-value']].copy()
summary['Group Comparison'] = summary['Group A'].astype(str) + " vs " + summary['Group B'].astype(str)
summary = summary[['Region', 'Group Comparison', 'P-value']]
summary.to_csv(output_csv, index=False)


df['Comparison'] = df['Group A'].astype(str) + " vs " + df['Group B'].astype(str)
# pivot = df.pivot_table(index='Region', columns='Comparison', values='P-value', aggfunc='min')
# binary = pivot.notna().replace({True: "✅", False: ""})
# binary.to_csv(output_mat)

# Create a direction column based on A-B
df['Direction'] = df['A-B'].apply(lambda x: '↑' if x > 0 else '↓')
# Pivot to Region × Comparison with direction
heatmap = df.pivot_table(index='Region', columns='Comparison', values='Direction', aggfunc='first')
# Export to CSV or display
heatmap.to_excel(output_mat)


# === Pivot table: Rows = Region, Columns = Comparison, Values = A-B ===
heatmap_data = df.pivot(index="Region", columns="Comparison", values="A-B")

# === Plot ===
plt.figure(figsize=(12, len(heatmap_data) * 0.4))
sns.heatmap(
    heatmap_data,
    annot=True, fmt=".1f",
    cmap="coolwarm", center=0,
    linewidths=0.5, linecolor='gray',
    cbar_kws={"label": "A - B value"}
)
plt.title("Directional Effect Size (A - B) by Region and Group Comparison")
plt.tight_layout()
#plt.show()
# Save the plot
plt.savefig(plot_filename, dpi=300)
print(f"Plot saved to {plot_filename}")
