% check SPM12 motion parameters
clc
close all
clear variables
%thispath = '/Volumes/hermes/canapi_051224/spmanalysis/';
thispath = '/Users/spmic/data/fMRI_pilot_jan2025/magnitude/';

userName = char(java.lang.System.getProperty('user.name'));
%savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_051224/plots/'];
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/Claire_fmrs/080125_piloting_fmrs/'];


% myFiles = {'rp_parrec_WIP1bar_20241205082447_6_nordic_clv.txt',...
%     'rp_parrec_WIP30prc_20241205082447_5_nordic_clv.txt',...
%     'rp_parrec_WIP50prc_20241205082447_4_nordic_clv.txt',...
%     'rp_parrec_WIP1bar_20241205082447_10_nordic_clv.txt',...
%     'rp_parrec_WIP30prc_20241205082447_9_nordic_clv.txt',...
%     'rp_parrec_WIP50prc_20241205082447_8_nordic_clv.txt',...
% };

myFiles = {'rp_fMRI_pilot_jan2025_3DEPI_localiser_TE20ms_20250108113313_8.txt',...
    'rp_fMRI_pilot_jan2025_3DEPI_localiser_TE20ms_20250108113313_9.txt'};

% nameFiles = {'1bar run 1','30 % run 1','50 % run 1',...
%     '1 bar run 2','30 % run 2','50 % run 2'};
nameFiles = {'scan8','scan9'};

for ii = 1:length(myFiles)
    plotRealignTextFiles([thispath myFiles{ii}],nameFiles{ii},savedir);

end

% textfile1 = [thispath 'rp_canapi_1bar_clv.txt'];
% textfile2 = [thispath 'rp_canapi_30prc_clv.txt'];
% textfile3 = [thispath 'rp_canapi_70prc_clv.txt'];
% 
% 
% names1 = {'1bar'};
% names2 = {'30%'};
% names3 = {'70%'};
% 
% plotRealignTextFiles(textfile1, names1, savedir)
% plotRealignTextFiles(textfile2, names2, savedir)
% plotRealignTextFiles(textfile3, names3, savedir)

%% plot global signal
names1 = {'1bar run 1'};
names2 = {'30% run 1'};
names3 = {'50% run 1'};
names4 = {'1bar run 2'};
names5 = {'30% run 2'};
names6 = {'70% run 2'};
% Load the NIfTI files using niftiread

filename1 = [thispath 'rparrec_WIP1bar_20241205082447_6_nordic_clv.nii'];
filename2 = [thispath 'vrparrec_WIP1bar_20241205082447_6_nordic_clv.nii'];
plotGlobalSignal(filename1, filename2, names1, savedir)

filename1 = [thispath 'rparrec_WIP30prc_20241205082447_5_nordic_clv.nii'];
filename2 = [thispath 'vrparrec_WIP30prc_20241205082447_5_nordic_clv.nii'];
plotGlobalSignal(filename1, filename2, names2, savedir)

filename1 = [thispath 'rparrec_WIP50prc_20241205082447_4_nordic_clv.nii'];
filename2 = [thispath 'vrparrec_WIP50prc_20241205082447_4_nordic_clv.nii'];
plotGlobalSignal(filename1, filename2, names3, savedir)

filename1 = [thispath 'rparrec_WIP1bar_20241205082447_10_nordic_clv.nii'];
filename2 = [thispath 'vrparrec_WIP1bar_20241205082447_10_nordic_clv.nii'];
plotGlobalSignal(filename1, filename2, names4, savedir)

filename1 = [thispath 'rparrec_WIP30prc_20241205082447_9_nordic_clv.nii'];
filename2 = [thispath 'vrparrec_WIP30prc_20241205082447_9_nordic_clv.nii'];
plotGlobalSignal(filename1, filename2, names5, savedir)

filename1 = [thispath 'rparrec_WIP50prc_20241205082447_8_nordic_clv.nii'];
filename2 = [thispath 'vrparrec_WIP50prc_20241205082447_8_nordic_clv.nii'];
plotGlobalSignal(filename1, filename2, names6, savedir)



