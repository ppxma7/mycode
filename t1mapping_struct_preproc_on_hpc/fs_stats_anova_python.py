import pandas as pd
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import seaborn as sns
from statsmodels.stats.multitest import multipletests  # For multiple comparison correction
import os
from itertools import combinations  # For pairwise comparisons

# Load the data

# Read CSV data
root_folder = '/Users/spmic/data/san/'  # Replace with your file path
hemisphere = 'l'
file_path = os.path.join(root_folder,f'freesurfer_stats_{hemisphere}_combined.csv')
whichCol = 'gmv'
save_dir = os.path.join('/Users/spmic/data/san/plotdir/', whichCol)

data = pd.read_csv(file_path) # Replace 'your_data.csv' with the actual file path

# List of groups to compare
groups = ['SASHB', 'AFIRM', 'NEXPO']

alphaval = 0.01

# Perform ANOVA for each region and store p-values
p_values = []
regions = []

for region in data['StructName'].unique():
    region_data = [data[(data['StructName'] == region) & (data['Group'] == group)]['GrayVol'].dropna() for group in groups]
    if all(len(group_data) > 0 for group_data in region_data):  # Ensure there's data for all groups
        f_stat, p_value = stats.f_oneway(*region_data)
        p_values.append(p_value)
        regions.append(region)

# Correct for multiple comparisons
# Bonferroni correction
reject_bonferroni, pvals_corrected_bonferroni, _, _ = multipletests(p_values, alpha=alphaval, method='bonferroni')

# Benjamini-Hochberg FDR correction
reject_fdr, pvals_corrected_fdr, _, _ = multipletests(p_values, alpha=alphaval, method='fdr_bh')

# Identify significant regions after correction
significant_regions_bonferroni = [region for region, reject in zip(regions, reject_bonferroni) if reject]
significant_regions_fdr = [region for region, reject in zip(regions, reject_fdr) if reject]


significant_regions = significant_regions_bonferroni
#print("Significant regions (Bonferroni correction):", significant_regions_bonferroni)
#print("Significant regions (FDR correction):", significant_regions_fdr)


# Save plots for significant regions (using FDR correction as an example)
# if significant_regions_bonferroni:
#     for region in significant_regions_bonferroni:
#         plt.figure(figsize=(10, 6))
#         sns.boxplot(x='Group', y='GrayVol', data=data[data['StructName'] == region])
#         plt.title(f'GrayVol for {region} across groups (FDR-corrected)')
#         plt.savefig(os.path.join(save_dir, f'{region}_GrayVol.png'))  # Save the plot as a PNG file
#         plt.close()  # Close the plot to free up memory
#     print(f"Plots saved in the directory: {save_dir}")
# else:
#     print("No regions found with significant differences in GrayVol between groups after FDR correction.")


# Create a single plot for all significant regions
if significant_regions:
    plt.figure(figsize=(14, 8))
    sns.set(style="whitegrid")
    
    # Filter data for significant regions
    significant_data = data[data['StructName'].isin(significant_regions)]
    
    # Create a box plot
    ax = sns.boxplot(x='StructName', y='GrayVol', hue='Group', data=significant_data, palette="Set2")
    plt.xticks(rotation=45, ha='right')  # Rotate x-axis labels for better readability
    plt.title('GrayVol for Significant Regions (FDR-corrected)')
    plt.xlabel('Region')
    plt.ylabel('GrayVol')
    
    # Add annotations for significant pairwise differences
    for i, region in enumerate(significant_regions):
        region_data = significant_data[significant_data['StructName'] == region]
        
        # Get the x-coordinates for the groups
        x_offset = 0.2  # Offset to space out groups within a region
        x_positions = [i - x_offset, i, i + x_offset]  # Positions for SASHB, AFIRM, NEXPO
        
        # Perform pairwise t-tests between groups
        for (group1, group2) in combinations(groups, 2):
            t_stat, p_value = stats.ttest_ind(
                region_data[region_data['Group'] == group1]['GrayVol'],
                region_data[region_data['Group'] == group2]['GrayVol'],
                equal_var=False  # Welch's t-test (does not assume equal variance)
            )
            if p_value < 0.05:  # Significance level
                # Get the x-coordinates for the groups
                x1 = x_positions[groups.index(group1)]
                x2 = x_positions[groups.index(group2)]
                
                # Get the y-coordinate for the line (above the highest box)
                y_max = region_data['GrayVol'].max() + 50
                
                # Draw a line between the groups
                plt.plot([x1, x2], [y_max, y_max], color='black', lw=1.5)
                
                # Add an asterisk for significance
                plt.text((x1 + x2) / 2, y_max + 10, '*', ha='center', va='bottom', color='black', fontsize=12)
    
    # Save the plot
    plt.tight_layout()  # Adjust layout to prevent overlap
    thisname = os.path.join(save_dir,'significant_regions_GrayVol.png')
    plt.savefig(thisname, dpi=300)  # Save the plot as a PNG file
    plt.close()  # Close the plot to free up memory
    print("Plot saved as 'significant_regions_GrayVol.png'")
else:
    print("No regions found with significant differences in GrayVol between groups after FDR correction.")