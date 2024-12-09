import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import os

indir = "/Volumes/hermes/canapi_051224/fslanalysis/parrec_WIP1bar_20241205082447_6_nordic_clv_aroma/"
# Path to ICA-AROMA output
classification_file = os.path.join(indir, "classification_overview.txt")

# Load the classification file
df = pd.read_csv(classification_file, sep='\t', names=['Component', 'Classification'])

# Count classifications
classification_counts = df['Classification'].value_counts()

# Plot
sns.barplot(x=classification_counts.index, y=classification_counts.values)
plt.title("ICA-AROMA Component Classification")
plt.xlabel("Classification")
plt.ylabel("Number of Components")
plt.show()
