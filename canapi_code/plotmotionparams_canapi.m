% check SPM12 motion parameters
clc
close all
clear variables
thispath = '/Volumes/hermes/canapi_full_run_111024/spm_analysis/';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_full_run_111024/plots/'];


myFiles = {'rp_parrec_WIP1bar_20241011131601_4_nordic_clv.txt',...
    'rp_parrec_WIP1bar_20241011131601_10_nordic_clv.txt',...
    'rp_parrec_WIP30prc_20241011131601_5_nordic_clv.txt',...
    'rp_parrec_WIP30prc_20241011131601_11_nordic_clv.txt',...
    'rp_parrec_WIP50prc_20241011131601_6_nordic_clv.txt',...
    'rp_parrec_WIP50prc_20241011131601_12_nordic_clv.txt',...
    'rp_parrec_WIP70prc_20241011131601_13_nordic_clv.txt'};

nameFiles = {'1bar right leg','1bar left leg',...
    '30 % right leg','30 % left leg',...
    '50 % right leg','50 % left leg',...
    '70 % left leg'};

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

