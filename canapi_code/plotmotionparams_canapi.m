% check SPM12 motion parameters
clc
close all
clear variables
thispath = '/Volumes/hermes/canapi_dry_run_270924/spm_analysis/';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_dry_run_270924/plots/'];

textfile1 = [thispath 'rp_canapi_1bar_clv.txt'];
textfile2 = [thispath 'rp_canapi_30prc_clv.txt'];
textfile3 = [thispath 'rp_canapi_70prc_clv.txt'];


names1 = {'1bar'};
names2 = {'30%'};
names3 = {'70%'};

plotRealignTextFiles(textfile1, names1, savedir)
plotRealignTextFiles(textfile2, names2, savedir)
plotRealignTextFiles(textfile3, names3, savedir)

%% plot global signal


% Load the NIfTI files using niftiread

filename1 = [thispath 'rcanapi_1bar_clv.nii'];
filename2 = [thispath 'vrcanapi_1bar_clv.nii'];
plotGlobalSignal(filename1, filename2, names1, savedir)

filename1 = [thispath 'rcanapi_30prc_clv.nii'];
filename2 = [thispath 'vrcanapi_30prc_clv.nii'];
plotGlobalSignal(filename1, filename2, names2, savedir)

filename1 = [thispath 'rcanapi_70prc_clv.nii'];
filename2 = [thispath 'vrcanapi_70prc_clv.nii'];
plotGlobalSignal(filename1, filename2, names3, savedir)

