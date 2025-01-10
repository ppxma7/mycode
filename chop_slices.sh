#!/bin/bash

mount=("/Users/spmic/data/preDUST_FUNSTAR_MBSENSE_090125/magnitude_clv/")

# List of input NIfTI files
# files=(
#     "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE1p5_30slc_2p5mm_20250109162844_8_clv.nii"
#     "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE2_30slc_2p5mm_20250109162844_9_clv.nii"
#     "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE2p5_30slc_2p5mm_20250109162844_10_clv.nii"
#     "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE3_30slc_2p5mm_20250109162844_11_clv.nii"
# )

files=(
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE1_36slc_2p5mm_20250109162844_12_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE1p5_36slc_2p5mm_20250109162844_13_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE2_36slc_2p5mm_20250109162844_14_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE2p5_36slc_2p5mm_20250109162844_15_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB2_SENSE3_36slc_2p5mm_20250109162844_16_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE1_36slc_2mm_20250109162844_17_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE1p5_36slc_2p5mm_20250109162844_18_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE2_36slc_2p5mm_20250109162844_19_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE2p5_36slc_2p5mm_20250109162844_20_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB3_SENSE3_36slc_2p5mm_20250109162844_21_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE1_36slc_2mm_20250109162844_22_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE1p5_36slc_2mm_20250109162844_23_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE2_36slc_2mm_20250109162844_24_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE2p5_36slc_2mm_20250109162844_25_clv.nii"
    "preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB4_SENSE3_36slc_2mm_20250109162844_26_clv.nii"
)

# Iterate over each file
for file in "${files[@]}"; do

    # Construct the full file path
    full_file_path="${mount}${file}"

    # Extract the base name without the extension
    base_name=$(basename "$file" .nii)
    
    # Define the output file name
    output_file="${mount}${base_name}_clipped.nii"
    
    # Remove top 3 and bottom 3 slices using fslmaths
    fslroi "$full_file_path" "$output_file" 0 -1 0 -1 6 24
    
    # Check if the command was successful
    if [ $? -eq 0 ]; then
        echo "Processed $full_file_path -> $output_file"
    else
        echo "Error processing $full_file_path"
    fi
done
