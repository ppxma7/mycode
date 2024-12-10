subject = '018';
mypath = '/Volumes/arianthe/exp016/231108_share/';
fMRIsubject = ['sub016_' subject '/'];
structPath = ['/Volumes/arianthe/exp016/freesurfer/' subject];

cd(structPath)

unix('rm ._*')

mlrImportFreeSurfer

cd([mypath fMRIsubject '/resultsSummary/'])
mkdir atlas
mkdir Raw/TSeries
gunzip('*2highres.nii.gz')
copyfile('*aveLeftHand_Cope1zstat_2highres.nii','Raw/TSeries/')
mrInit
