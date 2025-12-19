from nilearn import plotting, surface
import nibabel as nib
import os

group = "nexpo"

# --- Paths ---
subjects_dir = "/Volumes/DRS-GBPerm/other/outputs"
fsaverage_dir = "/Applications/freesurfer/subjects/fsaverage"
outdir = os.path.join(
    subjects_dir,
    f"group_thickness_{group}",
    "group_means"
)
outfigdir = "/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/thickness_outputs"

# --- Load surface mesh ---
surf_lh = os.path.join(fsaverage_dir, "surf", "lh.pial")
surf_rh = os.path.join(fsaverage_dir, "surf", "rh.pial")

# --- Load .mgh thickness data using nibabel ---
#lh_data = nib.load(os.path.join(outdir, "lh.thickness.mean_subset.mgh")).get_fdata().squeeze()
#rh_data = nib.load(os.path.join(outdir, "rh.thickness.mean_subset.mgh")).get_fdata().squeeze()

# --- Optional background (sulcal depth) ---
bg_lh = os.path.join(fsaverage_dir, "surf", "lh.sulc")
bg_rh = os.path.join(fsaverage_dir, "surf", "rh.sulc")


# --- Plot settings ---
vmin, vmax = 0.1, 3.5
threshold = 0.1
cmap = "viridis"

# --- Loop over groups ---
#for g in [1, 2, 3, 4]:
for g in [7]:
    print(f"Plotting group {g}")

    lh_file = os.path.join(outdir, f"lh.thickness.group{g}.mean.mgh")
    rh_file = os.path.join(outdir, f"rh.thickness.group{g}.mean.mgh")

    if not (os.path.exists(lh_file) and os.path.exists(rh_file)):
        print(f"  Skipping group {g} (files missing)")
        continue

    lh_data = nib.load(lh_file).get_fdata().squeeze()
    rh_data = nib.load(rh_file).get_fdata().squeeze()

    # --- Left hemisphere ---
    plotting.plot_surf_stat_map(
        surf_mesh=surf_lh,
        stat_map=lh_data,
        hemi="left",
        bg_map=bg_lh,
        bg_on_data=True,
        cmap=cmap,
        vmin=vmin,
        vmax=vmax,
        threshold=threshold,
        colorbar=True,
        title=f"Group {g} – LH thickness (lateral)",
        output_file=os.path.join(outfigdir, f"lh_group{g}_lateral.png")
    )

    plotting.plot_surf_stat_map(
        surf_mesh=surf_lh,
        stat_map=lh_data,
        hemi="left",
        bg_map=bg_lh,
        bg_on_data=True,
        cmap=cmap,
        vmin=vmin,
        vmax=vmax,
        threshold=threshold,
        view="medial",
        colorbar=True,
        title=f"Group {g} – LH thickness (medial)",
        output_file=os.path.join(outfigdir, f"lh_group{g}_medial.png")
    )

    # --- Right hemisphere ---
    plotting.plot_surf_stat_map(
        surf_mesh=surf_rh,
        stat_map=rh_data,
        hemi="right",
        bg_map=bg_rh,
        bg_on_data=True,
        cmap=cmap,
        vmin=vmin,
        vmax=vmax,
        threshold=threshold,
        colorbar=True,
        title=f"Group {g} – RH thickness (lateral)",
        output_file=os.path.join(outfigdir, f"rh_group{g}_lateral.png")
    )

    plotting.plot_surf_stat_map(
        surf_mesh=surf_rh,
        stat_map=rh_data,
        hemi="right",
        bg_map=bg_rh,
        bg_on_data=True,
        cmap=cmap,
        vmin=vmin,
        vmax=vmax,
        threshold=threshold,
        view="medial",
        colorbar=True,
        title=f"Group {g} – RH thickness (medial)",
        output_file=os.path.join(outfigdir, f"rh_group{g}_medial.png")
    )


# # --- Plot left hemisphere ---
# plotting.plot_surf_stat_map(
#     surf_mesh=surf_lh,
#     stat_map=lh_data,
#     hemi='left',
#     bg_map=bg_lh,
#     bg_on_data=True,
#     cmap='viridis',
#     vmin=0.1, vmax=3.5,
#     colorbar=True,
#     threshold=0.1,
#     title='Left Hemisphere (Cortical Thickness)',
#     output_file = os.path.join(outfigdir, f"lh_thickness_lateral_{group}.png")
# )
# plotting.plot_surf_stat_map(
#     surf_mesh=surf_lh,
#     stat_map=lh_data,
#     hemi='left',
#     bg_map=bg_lh,
#     bg_on_data=True,
#     cmap='viridis',
#     vmin=0.1, vmax=3.5,
#     colorbar=True,
#     threshold=0.1,
#     view='medial',
#     title='Left Hemisphere (Cortical Thickness)',
#     output_file = os.path.join(outfigdir, f"lh_thickness_medial_{group}.png")
# )

# # # --- Plot right hemisphere ---
# plotting.plot_surf_stat_map(
#     surf_mesh=surf_rh,
#     stat_map=rh_data,
#     hemi='right',
#     bg_map=bg_rh,
#     bg_on_data=True,
#     cmap='viridis',
#     vmin=0.1, vmax=3.5,
#     colorbar=True,
#     threshold=0.1,
#     title='Right Hemisphere (Cortical Thickness)',
#     output_file = os.path.join(outfigdir, f"rh_thickness_lateral_{group}.png")
# )
# plotting.plot_surf_stat_map(
#     surf_mesh=surf_rh,
#     stat_map=rh_data,
#     hemi='right',
#     bg_map=bg_rh,
#     bg_on_data=True,
#     cmap='viridis',
#     vmin=0.1, vmax=3.5,
#     colorbar=True,
#     threshold=0.1,
#     view='medial',
#     title='Right Hemisphere (Cortical Thickness)',
#     output_file = os.path.join(outfigdir, f"rh_thickness_medial_{group}.png")
# )

