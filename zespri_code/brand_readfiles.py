import random

# Read image file paths from multiple CSV files into a list of Pandas DataFrames
csv_files = [
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_green.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_gold.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_green.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_red.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_gold.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_red.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_green.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_gold.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_green.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_red.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_gold.csv",
    "/Users/spmic/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_red.csv"
]

# Set the random seed for pseudorandomization
random_seed = 2398  # Change this seed for different pseudorandomization

# Set the random seed
random.seed(random_seed)

# Shuffle the CSV file paths pseudorandomly
random.shuffle(csv_files)

# Print the order of CSV files for this subject
print("Order of CSV files:")
for i, csv_file in enumerate(csv_files):
    print(f"Subject {i+1}: {csv_file}")


# Save the order to a text file
output_file = "order_of_csv_files.txt"
with open(output_file, "w") as file:
    for i, csv_file in enumerate(csv_files):
        file.write(f"Subject {i+1}: {csv_file}\n")

print(f"Order saved to '{output_file}'")