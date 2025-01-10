from PIL import Image, ImageFilter

# Load the image
root_path = "/Users/spmic/data/preDUST_FUNSTAR_MBSENSE_090125/qa_output_preDUST_FUNSTAR_MBSENSE_090125_2DEPI_MB1_SENSE1_24slc_2p5mm_20250109162844_7_clv/"
image_path = root_path + "classic_tSNR_montage.png"  # Update with the path to your file
image = Image.open(image_path)

# Apply Gaussian blur
blurred_image = image.filter(ImageFilter.GaussianBlur(radius=100))  # Adjust radius for more/less blur

# Save the blurred image
output_path = root_path + "blurred_tSNR_montage.png"
blurred_image.save(output_path)

print(f"Blurred image saved as {output_path}")
