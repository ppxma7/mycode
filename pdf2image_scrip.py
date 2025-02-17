from pdf2image import convert_from_path
import os

#pdf_path = "/Users/spmic/data/painfiles/painsummary_march2024_subjects_tidied.pdf"
pdf_path = "/Users/spmic/data/painfiles/images/pain_hand.pdf"
output_folder = "/Users/spmic/data/painfiles/images/"
thisfile = "pain_hand"

# Ensure output folder exists
os.makedirs(output_folder, exist_ok=True)



# Convert PDF to images
images = convert_from_path(pdf_path)

# Save each page as an image
for i, img in enumerate(images):
    img_path = os.path.join(output_folder, f"{thisfile}_{i+1}.png")
    #img_path = os.path.join(output_folder, f"page_{i+1}.png")
    img.save(img_path, "PNG")

print("PDF pages converted to images.")
