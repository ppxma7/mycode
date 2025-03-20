# Load subject IDs from two text files, extracting only the first 5 digits
def load_ids(filename):
    with open(filename, 'r') as f:
        return set(line.strip()[:5] for line in f if line.strip())

longer_list = load_ids('longerlist.txt')
shorter_list = load_ids('mylist.txt')

# Find missing IDs
missing_subjects = longer_list - shorter_list

# Print missing subjects
print("Subjects missing from the shorter list (first 5 digits):")
for subject in sorted(missing_subjects):
    print(subject)
