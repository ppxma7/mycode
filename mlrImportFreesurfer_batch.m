ccd
mypath = '/Volumes/ares/ZESPRI/structurals/freesurfer_outputs/zespri_freesurfer/';

nSubs = 14;

for ii = 1:nSubs

    cd(mypath)

    cd(['mzespri_' num2str(ii) 'A_mprage.freesurfer/'])

    pwd

    mlrImportFreeSurfer_copy('defaultParams')
    
end