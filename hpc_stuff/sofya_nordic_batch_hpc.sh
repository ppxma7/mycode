#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=64gb
#SBATCH --time=48:00:00
#SBATCH --array=0
module load extension/imaging/
module load fsl-img/6.0.7.x
module load matlab-uon/r2024a


FILELIST=/gpfs01/home/ppzma/sofya_nexpo_data/sofya_inputs.txt

mapfile -t PARAMS < "$FILELIST"

index=${SLURM_ARRAY_TASK_ID}
sindex=$index
param=${PARAMS[$sindex]}

echo "Job array ID: $SLURM_ARRAY_TASK_ID"
echo "Input file: $param"

dir=$(dirname "$param")
base=$(basename "$param")
newfilename=${base%.nii}
newfilename=${newfilename%.nii.gz}

# subject directory (e.g. sub01)
subdir=$(dirname "$(dirname "$param")")

nordicdir="${dir}/NORDIC/Noise_input"
nordicfile="${nordicdir}/${newfilename}_nordic.nii"

retrodir="${subdir}/retroicor"
clvfile="${retrodir}/${newfilename}_nordic_clv.nii.gz"
clvfile_unzipped="${retrodir}/${newfilename}_nordic_clv.nii"
retrofile="${retrodir}/${newfilename}_nordic_clv_RCR.nii"

spldir="${subdir}/spl"

topupdir="${subdir}/topup"
pretopupfile="${subdir}/topup/${newfilename}_nordic_clv_RCR.nii"
topupfile="${subdir}/topup/${newfilename}_nordic_clv_RCR_toppedup.nii.gz"

echo "Subject dir : $subdir"
echo "NORDIC dir  : $nordicdir"
echo "RETROICOR dir : $retrodir"
echo "SPL dir    : $spldir"
echo "TOPUP dir    : $topupdir"

# ----
# Run NORDIC
# ----
if [ -f "$nordicfile" ]; then
    echo "NORDIC output already exists — skipping NORDIC"
else
    echo "Running NORDIC processing for $param"
    matlab -nodisplay -nosplash -nodesktop -r \
    "try, addpath(genpath('/gpfs01/home/ppzma/code')); nordic_hpc('${param}'); catch ME, disp(getReport(ME,'extended')); exit(1); end; exit(0)"
    echo "NORDIC processing completed for $param"
fi

if [ ! -f "$nordicfile" ]; then
    echo "ERROR: Cannot find NORDIC output:"
    echo "$nordicfile"
    exit 1
fi

# now we need to run retroicor
# first move files to appropriate directory
if [ ! -d "$retrodir" ]; then
    echo "ERROR: RETROICOR directory not found:"
    echo "$retrodir"
    exit 1
fi

# copy dont move
# cp "$nordicfile" "$retrodir"
# echo "Copied NORDIC file to $retrodir"

if [ ! -f "$retrodir/$(basename "$nordicfile")" ]; then
    cp "$nordicfile" "$retrodir"
    echo "Copied NORDIC file to $retrodir"
else
    echo "NORDIC file already exists in $retrodir — skipping copy"
fi

if [ ! -d "$spldir" ]; then
    echo "ERROR: SPL directory not found:"
    echo "$spldir"
    exit 1
fi

# need to remove last dynamic from the nordic file
nvols=$(fslval "$retrodir/$(basename "$nordicfile")" dim4)
if [ -f "$clvfile" ]; then
    echo "CLV file already exists — skipping cleaving"
else
    fslroi "$retrodir/$(basename "$nordicfile")" "$clvfile" 0 $((nvols - 1))
    echo "Cleaved last dynamic from NORDIC file"
fi

# Unzip only if the .nii does not already exist
if [ ! -f "$clvfile_unzipped" ]; then
    echo "Unzipping $clvfile ..."
    gunzip -c "$clvfile" > "$clvfile_unzipped"
    echo "Created unzipped CLV file: $clvfile_unzipped"
else
    echo "Unzipped CLV file already exists — skipping"
fi

if [ -f "$retrofile" ]; then
    echo "RETROICOR output already exists — skipping RETROICOR"
else
    echo "Running RETROICOR processing for $param"
    matlab -nodisplay -nosplash -nodesktop -r \
        "addpath(genpath('/gpfs01/home/ppzma/code')); run_retroicor('${retrodir}','${spldir}','${clvfile_unzipped}'); exit"

    echo "RETROICOR processing completed for $param"
fi


# echo "DEBUG - Stopping before TOPUP !"
# exit 0

# now run TOPUP
if [ ! -d "$topupdir" ]; then
    echo "ERROR: TOPUP directory not found:"
    echo "$topupdir"
    exit 1
fi

# copy dont move
cp "$retrofile" "$topupdir"
echo "Copied RETROICOR file to $topupdir"

# Find FOR and REV files in topupdir
forfile=$(ls "$topupdir"/*FOR*.nii* 2>/dev/null)
revfile=$(ls "$topupdir"/*REV*.nii* 2>/dev/null)

if [ ! -f "${forfile[0]}" ] || [ ! -f "${revfile[0]}" ]; then
    echo "ERROR: Could not find FOR and/or REV files in $topupdir"
    exit 1
fi

forfile="${forfile[0]}"
revfile="${revfile[0]}"

acqparams="$topupdir/acqparams.txt"
if [ ! -f "$acqparams" ]; then
    echo "ERROR: acqparams.txt not found in $topupdir"
    exit 1
fi

numDyn=2

if [ -f "$topupfile" ]; then
    echo "TOPUP output already exists — skipping TOPUP"
else
    echo "Running TOPUP..."
    sh /gpfs01/home/ppzma/code/toppedup.sh \
        "$topupdir" \
        "$forfile" \
        "$revfile" \
        "$numDyn"

    echo "Applying TOPUP..."
    sh /gpfs01/home/ppzma/code/applytoppedup.sh \
        "$topupdir" \
        "$pretopupfile" \
        "$topupdir/$(basename "$forfile" | sed 's/\.nii.*//')_merged"
    echo "TOPUP processing completed for $param"
fi

