import os
from PIL import Image, ImageFilter

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

# Define the output folder for blurred images
output_folder = "/Users/spmic/data/blurred_images/"
os.makedirs(output_folder, exist_ok=True)

# Loop through each folder
for folder in subfolders:
    input_path = os.path.join(root_path, folder, "classic_tSNR_montage.png")
    
    if os.path.exists(input_path):
        try:
            # Load the image
            image = Image.open(input_path)

            # Apply Gaussian blur
            blurred_image = image.filter(ImageFilter.GaussianBlur(radius=200))  # Adjust radius as needed

            # Save the blurred image
            output_path = os.path.join(output_folder, f"{folder}_blurred.png")
            blurred_image.save(output_path)

            print(f"Blurred image saved as {output_path}")
        except Exception as e:
            print(f"Error processing {input_path}: {e}")
    else:
        print(f"File not found: {input_path}")

print(f"All blurred images are saved in {output_folder}")
