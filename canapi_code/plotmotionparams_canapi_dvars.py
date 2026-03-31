import numpy as np
import matplotlib.pyplot as plt
import os
import glob

main_dir = "/Volumes/kratos/CANAPI/"
savedir = "/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/grouplevel_results/"

subject_folders = sorted([f for f in os.listdir(main_dir) if f.startswith("canapi_sub")])

all_dvars_raw = []
all_dvars_aroma = []

for subj in subject_folders:
    spm_dir = os.path.join(main_dir, subj, "spm_analysis")
    if not os.path.exists(spm_dir):
        continue

    aroma_dirs = sorted(glob.glob(os.path.join(spm_dir, "*_nonan_aroma")))
    if not aroma_dirs:
        print(f"No aroma folders found for {subj}")
        continue

    subj_raw, subj_aroma = [], []

    for adir in aroma_dirs:
        raw_file   = os.path.join(adir, "dvars_raw.txt")
        aroma_file = os.path.join(adir, "dvars_aroma.txt")

        if os.path.exists(raw_file) and os.path.exists(aroma_file):
            subj_raw.append(np.loadtxt(raw_file))
            subj_aroma.append(np.loadtxt(aroma_file))
        else:
            print(f"Missing DVARS files in {adir}")

    if subj_raw:
        all_dvars_raw.append(np.concatenate(subj_raw))
        all_dvars_aroma.append(np.concatenate(subj_aroma))

# Truncate to shortest
min_len = min(len(d) for d in all_dvars_raw)
raw_arr   = np.array([d[:min_len] for d in all_dvars_raw])   # [n_subs, min_len]
aroma_arr = np.array([d[:min_len] for d in all_dvars_aroma])

mean_raw   = np.mean(raw_arr, axis=0)
std_raw    = np.std(raw_arr, axis=0)
mean_aroma = np.mean(aroma_arr, axis=0)
std_aroma  = np.std(aroma_arr, axis=0)

# Plot
fig, ax = plt.subplots(figsize=(12, 4))
t = np.arange(min_len)

ax.plot(t, mean_raw,   color='#d95f02', label='DVARS raw')
ax.fill_between(t, mean_raw - std_raw, mean_raw + std_raw, color='#d95f02', alpha=0.2)

ax.plot(t, mean_aroma, color='#1b9e77', label='DVARS post-AROMA')
ax.fill_between(t, mean_aroma - std_aroma, mean_aroma + std_aroma, color='#1b9e77', alpha=0.2)

ax.set_xlabel('Volume')
ax.set_ylabel('DVARS')
ax.set_title('Mean ± SD DVARS Before and After ICA-AROMA')
ax.legend()
ax.grid(True)
plt.tight_layout()

plt.savefig(os.path.join(savedir, "CANAPI_group_DVARS.png"), dpi=300)
plt.close()




# mean dvars plot
mean_fd_raw   = np.mean(raw_arr, axis=1)   # per subject
mean_fd_aroma = np.mean(aroma_arr, axis=1)

subject_labels = [s.replace('canapi_', '') for s, d in zip(subject_folders, all_dvars_raw)]

fig3, ax = plt.subplots(figsize=(10, 4))
x = np.arange(len(subject_labels))
width = 0.35

ax.bar(x - width/2, mean_fd_raw,   width=width, color='#d95f02', label='DVARS raw')
ax.bar(x + width/2, mean_fd_aroma, width=width, color='#1b9e77', label='DVARS post-AROMA')

ax.set_xticks(x)
ax.set_xticklabels(subject_labels, rotation=45, ha='right', fontsize=8)
ax.set_ylabel('Mean DVARS')
ax.set_title('Mean DVARS per Subject (Before vs After ICA-AROMA)')
ax.legend()
ax.grid(axis='y')
plt.tight_layout()

plt.savefig(os.path.join(savedir, "CANAPI_per_subject_DVARS.png"), dpi=300)
plt.close()


