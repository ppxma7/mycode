from nilearn import plotting
import nibabel as nib
import os

group="group_thickness_afirm"

# --- Paths ---
fsaverage_dir = "/Applications/freesurfer/subjects/fsaverage"
outdir = f"/Volumes/DRS-GBPerm/other/outputs/{group}"
#outfigdir = "/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/thickness_outputs"
outfigdir = "/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/thickness_outputs"

os.makedirs(outfigdir, exist_ok=True)

# --- Surface meshes ---
surf_lh = os.path.join(fsaverage_dir, "surf", "lh.pial")
surf_rh = os.path.join(fsaverage_dir, "surf", "rh.pial")

# --- Background ---
bg_lh = os.path.join(fsaverage_dir, "surf", "lh.sulc")
bg_rh = os.path.join(fsaverage_dir, "surf", "rh.sulc")

# --- Load group mean thickness ---
lh_data = nib.load(os.path.join(outdir, "lh.thickness.mean_subset.mgh")).get_fdata().squeeze()
rh_data = nib.load(os.path.join(outdir, "rh.thickness.mean_subset.mgh")).get_fdata().squeeze()

# --- Plot settings ---
vmin, vmax = 0.1, 3.5
threshold = 0.1
cmap = "viridis"

# ---------- PLOT (4 IMAGES TOTAL) ----------

# LH lateral
plotting.plot_surf_stat_map(
    surf_lh, lh_data,
    hemi="left",
    bg_map=bg_lh,
    bg_on_data=True,
    cmap=cmap,
    vmin=vmin, vmax=vmax,
    threshold=threshold,
    colorbar=True,
    title="LH thickness (lateral)",
    output_file=os.path.join(outfigdir, f"lh_lateral_{group}.png")
)

# LH medial
plotting.plot_surf_stat_map(
    surf_lh, lh_data,
    hemi="left",
    view="medial",
    bg_map=bg_lh,
    bg_on_data=True,
    cmap=cmap,
    vmin=vmin, vmax=vmax,
    threshold=threshold,
    colorbar=True,
    title="LH thickness (medial)",
    output_file=os.path.join(outfigdir, f"lh_medial_{group}.png")
)

# RH lateral
plotting.plot_surf_stat_map(
    surf_rh, rh_data,
    hemi="right",
    bg_map=bg_rh,
    bg_on_data=True,
    cmap=cmap,
    vmin=vmin, vmax=vmax,
    threshold=threshold,
    colorbar=True,
    title="RH thickness (lateral)",
    output_file=os.path.join(outfigdir, f"rh_lateral_{group}.png")
)

# RH medial
plotting.plot_surf_stat_map(
    surf_rh, rh_data,
    hemi="right",
    view="medial",
    bg_map=bg_rh,
    bg_on_data=True,
    cmap=cmap,
    vmin=vmin, vmax=vmax,
    threshold=threshold,
    colorbar=True,
    title="RH thickness (medial)",
    output_file=os.path.join(outfigdir, f"rh_medial_{group}.png")
)
