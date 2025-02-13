import os
import pandas as pd

# Root directory to scan
root_folder = '/Users/spmic/data/pain_redo/'
output_folder = os.path.join(root_folder,"html_report")  # Where the HTML files will be stored

# Ensure the output folder exists
os.makedirs(output_folder, exist_ok=True)

image_folder = "/Users/spmic/data/painfiles/images/"

# Define page-to-subject mapping (update this as needed)
page_mapping = {
    range(1, 6): "sub01",
    range(7, 12): "sub02",
    range(13, 17): "sub03",
    range(18, 23): "sub04",
    range(24, 28): "sub05",
    range(29, 33): "sub06",
    range(34, 39): "sub07",
    range(40, 40): "sub08",
    # Add more mappings as needed
}

def find_subject_for_page(page_num):
    """Find which subject a page belongs to."""
    for page_range, subject in page_mapping.items():
        if page_num in page_range:
            return subject
    return None

def get_region_for_pdf(directory, pdf_filename):
    """Find the corresponding _atlas.csv file and extract the Region column."""
    csv_filename = pdf_filename.replace("_glassbrain.pdf", "_atlas.csv")  # Match CSV name
    csv_path = os.path.join(directory, csv_filename)
    
    if os.path.exists(csv_path):
        try:
            df = pd.read_csv(csv_path)  # Load CSV
            if "Region" in df.columns and not df["Region"].empty:
                return ", ".join(df["Region"].dropna().unique())  # Get unique regions
        except Exception as e:
            return f"Error reading CSV: {e}"
    return "Region data not available"

def generate_summary_page():
    """Generate a summary.html page from summary.txt or summary.md"""
    summary_file = os.path.join(root_folder, "summary.txt")  # Or use summary.md
    summary_content = ""

    if os.path.exists(summary_file):
        with open(summary_file, "r", encoding="utf-8") as f:
            summary_content = f.read().replace("\n", "<br>")  # Preserve newlines in HTML

    summary_html = f"""<html>
    <head>
        <title>Summary</title>
        <style>
            body {{ font-family: Arial, sans-serif; padding: 20px; }}
            .container {{ max-width: 800px; margin: auto; }}
            a {{ text-decoration: none; color: blue; }}
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Summary</h2>
            <p>{summary_content}</p>
            <p><a href="index.html">⬅ Back to Main Page</a></p>
        </div>
    </body>
    </html>"""

    # Write the summary.html file in the top-level output folder
    summary_path = os.path.join(output_folder, "summary.html")
    with open(summary_path, "w", encoding="utf-8") as f:
        f.write(summary_html)

    print("Summary page generated successfully.")

def generate_html(directory, rel_path=""):
    """Generate an index.html file for the given directory."""
    items = sorted(os.listdir(directory))  # Sort alphabetically
    folders = [item for item in items if os.path.isdir(os.path.join(directory, item))]
    pdfs = [item for item in items if item.endswith("glassbrain.pdf")]

    # Determine the output file path
    rel_output_path = os.path.join(output_folder, rel_path)

    # Fix: Ensure only the final folder structure is created
    if not os.path.exists(rel_output_path):
        os.makedirs(rel_output_path)
        
    #os.makedirs(rel_output_path, exist_ok=True)
    html_path = os.path.join(rel_output_path, "index.html")

    # Start HTML content
    html_content = f"""<html>
    <head>
        <title>{directory}</title>
        <style>
            body {{ font-family: Arial, sans-serif; padding: 20px; }}
            iframe {{ width: 100%; height: 600px; margin-top: 10px; border: 1px solid #ddd; }}
            .folder-list, .pdf-list {{ margin-top: 20px; }}
        </style>
    </head>
    <body>
    <h2>{directory}</h2>
    <h1>Hello there, weary traveller!</h1>
    <p>Click on any folder to explore its contents:</p>"""

    # **Add Summary Link Only on the Main Landing Page**
    if rel_path == "":  
        html_content += '<p><a href="summary.html"><strong>📄 View Summary</strong></a></p>'


    # Navigation link (if not the root)
    if rel_path:
        parent_path = os.path.dirname(rel_path)
        html_content += f'<p><a href="../index.html">⬅ Back</a></p>'

    # List folders
    if folders:
        html_content += "<h3>Folders:</h3><ul class='folder-list'>"
        for folder in folders:
            folder_link = os.path.join(folder, "index.html")
            html_content += f'<li><a href="{folder_link}">{folder}</a></li>'
        html_content += "</ul>"

    # Display PDFs directly on the page
    if pdfs:
        html_content += "<h3>Brain Images (PDFs):</h3>"
        for pdf in pdfs:
            pdf_path = os.path.join(directory, pdf)  # Keep the original file path
            region_info = get_region_for_pdf(directory, pdf)  # Get region data
            html_content += f"""
            <div>
                <p>{pdf} - <strong>Region:</strong> {region_info}</p>
                <iframe src="{pdf_path}"></iframe>
            </div>"""
    
    # Add PNGs based on subject mapping
    subject = os.path.basename(directory)
    subject_pages = [f"page_{i}.png" for i in range(1, 41) if find_subject_for_page(i) == subject]

    html_content += """
    <script>
    function openLightbox(imgSrc) {
        document.getElementById('lightbox-img').src = imgSrc;
        document.getElementById('lightbox').style.display = 'block';
    }
    function closeLightbox() {
        document.getElementById('lightbox').style.display = 'none';
    }
    </script>

    <style>
    #lightbox {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.8);
        text-align: center;
        z-index: 1000;
    }
    #lightbox img {
        max-width: 90%;
        max-height: 90%;
        margin-top: 5%;
    }
    #lightbox-close {
        position: absolute;
        top: 20px;
        right: 30px;
        font-size: 30px;
        color: white;
        cursor: pointer;
    }
    </style>

    <div id="lightbox" onclick="closeLightbox()">
        <span id="lightbox-close">&times;</span>
        <img id="lightbox-img">
    </div>
    """
    if subject_pages:
        html_content += "<h3>Relevant PNGs:</h3>"
        for img in subject_pages:
            img_path = os.path.join(image_folder, img)
            #html_content += f'<div><img src="{img_path}" style="width:100%; max-width:600px;"></div>'
            html_content += f'<div><img src="{img_path}" style="width:100%; max-width:600px; cursor:pointer;" onclick="openLightbox(\'{img_path}\')"></div>'



    html_content += "</body></html>"

    # Write to file
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html_content)

    # Recurse into subfolders
    for folder in folders:
        generate_html(os.path.join(directory, folder), os.path.join(rel_path, folder))


# Call this after generating the main HTML structure
generate_summary_page()


# Generate HTML starting from root
generate_html(root_folder)



print(f"HTML report generated in: {output_folder}")
