import os
import subprocess
import glob
import numpy as np
import matplotlib.pyplot as plt
import sys

# ---------- USER CONFIG ----------
FSLDIR = "/usr/local/fsl"
MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz"
MNI_BRAIN_MASK = f"{FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz"
MY_CONFIG_DIR = "/Users/ppzma/data"  # contains bb_fnirt.cnf
#OPTIBET_PATH = "/Users/ppzma/Documents/MATLAB/optibet.sh"
FASTPATH = f"{FSLDIR}/share/fsl/bin/fast"

thisSubject = '12185_004'

# Paths to input and output folders
rootFold = os.path.join("/Volumes/kratos/SOFYA/",thisSubject)
fmri_path = os.path.join(rootFold,'fMRI')
fmri_outdir = os.path.join(rootFold, 'outputs')
struc_path = os.path.join(rootFold,'structural')
parfile_path = os.path.join(rootFold,'motion_params')

# Main MPRAGE 
mprage_matches = glob.glob(os.path.join(struc_path, "*MPRAGE*.nii*"))
if len(mprage_matches) == 0:
    raise FileNotFoundError(f"No MPRAGE file found in {struc_path}")
elif len(mprage_matches) > 1:
    print(f"Multiple MPRAGE files found, using first: {mprage_matches[0]}")
mprage_file = mprage_matches[0]
print(f"This is the T1w: {mprage_file}")

# fMRI data
# fmri_matches = glob.glob(os.path.join(fmri_path, "*rs*.nii*"))
# if len(fmri_matches) == 0:
#     raise FileNotFoundError(f"No resting state fMRI .nii found in {fmri_path}")
# elif len(fmri_matches) > 1:
#     print(f"Multiple resting state files found, using first: {fmri_matches[0]}")
# fmri_file = fmri_matches[0]

fMRI_files = glob.glob(os.path.join(fmri_path, "*rs*.nii*"))


def run(cmd, check=True):
    print("🔧 Running:", " ".join(cmd))
    subprocess.run(cmd, check=check)

def strip_ext(fname):
    if fname.endswith(".nii.gz"):
        return fname[:-7]  # strip 7 chars for '.nii.gz'
    else:
        return os.path.splitext(fname)[0]

def plotparfile(par_file, save_dir):
    # Loop through each file
    #par_file = os.path.join(input_folder, file + "_mc.par")  # Assuming motion parameter files end with "_mc.par"
    
    # Check if the .par file exists
    if not os.path.exists(par_file):
        print(f"Motion parameter file not found: {par_file}")
        return

    # make sure output directory exists
    os.makedirs(save_dir, exist_ok=True)

    # Load the motion parameters
    motion_params = np.loadtxt(par_file)

    # lower_limit = -2
    # upper_limit = 2

    # Plot translations and rotations
    fig, axes = plt.subplots(2, 1, figsize=(10, 6), sharex=True)

    # Plot translations (columns 3-5)
    axes[0].plot(motion_params[:, 3], label='X Translation', color='#7570b3')  # Hex color)
    axes[0].plot(motion_params[:, 4], label='Y Translation', color='#d95f02')  # Hex color)
    axes[0].plot(motion_params[:, 5], label='Z Translation', color='#1b9e77')  # Hex color)
    axes[0].set_title('Translations')
    axes[0].set_xlabel('Volume')
    axes[0].set_ylabel('Translation (mm)')
    axes[0].legend()
    axes[0].grid(True)
    #axes[0].set_ylim(lower_limit, upper_limit)

        # Plot rotations (columns 0-2)
    axes[1].plot(motion_params[:, 0], label='X Rotation', color='#7570b3')  # Hex color)
    axes[1].plot(motion_params[:, 1], label='Y Rotation', color='#d95f02')  # Hex color)
    axes[1].plot(motion_params[:, 2], label='Z Rotation', color='#1b9e77')  # Hex color)
    axes[1].set_title('Rotations')
    axes[1].set_ylabel('Rotations (radians)')
    axes[1].legend()
    axes[1].grid(True)
    #axes[1].set_ylim(lower_limit, upper_limit)


    # Save the plot as PNG
    base = os.path.basename(strip_ext(par_file))
    plot_file = os.path.join(save_dir, f"{base}_motion_plot.png")
    plt.tight_layout()
    plt.savefig(plot_file, dpi=300)
    plt.close()  # Close the plot to free memory
    print(f"Saved motion parameter plot: {plot_file}")




# Step 1: Run motion correction
for file in fMRI_files:
    input_path = os.path.join(fmri_path, os.path.basename(file))
    print(f"This is the fMRI data: {input_path}")
    base_name = strip_ext(os.path.basename(file))
    fixedout = os.path.join(fmri_outdir, base_name + "_dimfix")
    mcflirt_out = os.path.join(fmri_outdir, base_name + "_dimfix_mc")
    motion_params_out = os.path.join(fmri_path, base_name + "_motion.txt")

    #print(mcflirt_out)

    
    # First transform the file
    if not os.path.exists(fixedout + ".nii.gz"):
        run([
            "fslswapdim", input_path, "x", "-z", "y", fixedout
            ])
    else:
        print("skipped swapdim")

    #sys.exit(0)
    
    # Run MCFLIRT
    if not os.path.exists(mcflirt_out + ".nii.gz"):
        run([
            "mcflirt", "-in", fixedout, "-out", mcflirt_out, 
            "-mats", "-plots", "-rmsrel", "-rmsabs","-report"
        ])
    else:
        print("Skipping mcflirt")

    
    # print motion params
    parfile = mcflirt_out + ".par"
    plotfile = os.path.join(parfile_path, f"{os.path.basename(strip_ext(parfile))}_motion_plot.png")
    if not os.path.exists(plotfile):
        plotparfile(parfile, parfile_path)
    else:
        print("Skipping saving motion plot")

    #sys.exit(0)
    # Step 2: Find transform fMRI to MPRAGE

    fMRI_align = f"{strip_ext(mcflirt_out)}_align.nii.gz"
    fMRI_mat   = os.path.join(fmri_outdir,"fMRI_to_mprage.mat")
    #print(fMRI_align)
    #print(fMRI_mat)

    
    # Step 3: Move fMRI to MPRAGE
    if not os.path.exists(fMRI_align):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", mcflirt_out,
            "-ref", mprage_file,
            "-omat", fMRI_mat,
            "-out", fMRI_align,
            "-bins", "256",
            "-dof", "6",
            "-schedule", f"{FSLDIR}/etc/flirtsch/sch3Dtrans_3dof",
            "-cost", "normmi",
            "-searchrx", "0", "0",
            "-searchry", "0", "0",
            "-searchrz", "0", "0",
            "-interp", "trilinear"
        ])
    else:
        print("Skipping fMRI to MPRAGE flirt")

    # # step 3a - sanity check
    # fMRI_in_mprage = os.path.join(fmri_outdir, base_name + "_mc_inMPRAGE")

    # run([
    #     f"{FSLDIR}/bin/flirt",
    #     "-in", mcflirt_out + ".nii.gz",
    #     "-ref", mprage_file,
    #     "-applyxfm",
    #     "-init", fMRI_mat,
    #     "-out", fMRI_in_mprage + ".nii.gz",
    #     "-interp", "trilinear"
    # ])

    #sys.exit(0)

    affine_mprage_to_mni = os.path.join(struc_path, f"{thisSubject}_mprage2mni.mat")
    mprage_to_mni = os.path.join(struc_path, f"{thisSubject}_mprage2mni_linear.nii.gz")
    

    #Step 4: Move MPRAGE to MNI 
    if not os.path.exists(mprage_to_mni):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", mprage_file,
            "-ref", MNI_TEMPLATE,
            "-omat", affine_mprage_to_mni,
            "-out", mprage_to_mni,
            "-bins", "256",
            "-dof", "12",
            "-cost", "corratio",
            "-searchrx", "-90", "90",
            "-searchry", "-90", "90",
            "-searchrz", "-90", "90",
            "-interp", "trilinear"
        ])
    else:
        print("Skipping MPRAGE to MNI")


    # sanity check
    # fMRI_in_MNI = os.path.join(fmri_outdir, base_name + "_mc_inMNI")

    # run([
    #     f"{FSLDIR}/bin/flirt",
    #     "-in", fMRI_in_mprage + ".nii.gz",
    #     "-ref", MNI_TEMPLATE,
    #     "-applyxfm",
    #     "-init", affine_mprage_to_mni,
    #     "-out", fMRI_in_MNI + ".nii.gz",
    #     "-interp", "trilinear"
    # ])
    # sys.exit(0)

    # Step 5: Concatenate transforms so we can apply once
    fMRI_to_MNI_mat = os.path.join(fmri_outdir, f"{thisSubject}_fMRI2MNI.mat")
    if not os.path.exists(fMRI_to_MNI_mat):
        run([
            f"{FSLDIR}/bin/convert_xfm",
            "-omat", fMRI_to_MNI_mat,
            "-concat", affine_mprage_to_mni,
            fMRI_mat
        ])
    else:
        print("Skipping transform concat")


    # Step 6 fMRI to MNI
    # Apply composite transform once
    fMRI_MNI = os.path.join(fmri_outdir, f"{strip_ext(mcflirt_out)}_MNI.nii.gz")
    if not os.path.exists(fMRI_MNI):
        run([
            f"{FSLDIR}/bin/flirt",
            "-in", mcflirt_out,
            "-ref", MNI_TEMPLATE,
            "-applyxfm",
            "-init", fMRI_to_MNI_mat,
            "-out", fMRI_MNI,
            "-interp", "trilinear",
            "-verbose", "1"
        ])
    else:
        print("Skipping apply MNI transform to fMRI")




