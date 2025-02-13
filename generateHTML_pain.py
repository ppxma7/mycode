import os
import pandas as pd

# Root directory to scan
root_folder = '/Users/spmic/data/pain_redo/'
output_folder = os.path.join(root_folder,"html_report")  # Where the HTML files will be stored

# Ensure the output folder exists
os.makedirs(output_folder, exist_ok=True)

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

    html_content += "</body></html>"

    # Write to file
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html_content)

    # Recurse into subfolders
    for folder in folders:
        generate_html(os.path.join(directory, folder), os.path.join(rel_path, folder))

# Generate HTML starting from root
generate_html(root_folder)

print(f"HTML report generated in: {output_folder}")
