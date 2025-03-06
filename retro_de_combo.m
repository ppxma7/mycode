% Script to combine echoes and run RETROICOR on both echoes separately
%
% Dependencies: 
%
% retroicor_2023.m <- nottingham/retroicor/
% AddMarkers_fast.m <- nottingham/retroicor/ (run this first)
%   AddMarkers_fast(MB), e.g. for multiband 3. Check the GZ threshold. This
%   function skips the checking and plotting things for maximum speed.
% de.m <- nottingham/doubleEcho/
% Nordic_batch_func.m <- nottingham/fMRI_preproc/
%
% Michael Asghar
% 6th March 2025
%
% See Also retroicor_2023.m AddMarkers_fast.m de.m Nordic_batch_func.m
% NIFTI_NORDIC.m Nordic_testing_Michael.m



clear all
close all
clc
close all hidden


thispath = '/Volumes/hermes/postDUST_HEAD_MBHIRES_1p25/';


if ~exist(fullfile(thispath,'magnitude'),'dir')
    error('I need a magnitude and phase dir for nordic')
end

file = 'postDUST_HEAD_MBHIRES_1p25_WIPMB3_SENSE3_2mmiso_DE_TE17TE44_20250306111336_14';

magfile1 = fullfile(thispath,'magnitude','RETROICOR',[file '_e1_clv.nii']);
magfile2 = fullfile(thispath,'magnitude','RETROICOR',[file '_e2_clv.nii']);
magfile3 = fullfile(thispath,'magnitude','RETROICOR',[file '_e1_nordic_clv.nii.gz']);
magfile4 = fullfile(thispath,'magnitude','RETROICOR',[file '_e2_nordic_clv.nii.gz']);

% phfile1 = fullfile(thispath,'phase',[file '_e1_ph.nii.gz']);
% phfile2 = fullfile(thispath,'phase',[file '_e2_ph.nii.gz']);


%mycell = {magfile1, magfile2};

% %% send to nordic
% if ~exist(fullfile(thispath,'magnitude/NORDIC/'),'dir')
%     Nordic_batch_func(mypath,mycell)
% end
% 
% close all

%% RETROICOR each echo
if exist(fullfile(thispath,'magnitude/RETROICOR'),'dir')

    retPath = fullfile(thispath,'magnitude/RETROICOR/');

    %mkdir(retPath)

    if isfolder(fullfile(thispath,'spl'))
        findlogs = dir(fullfile(thispath,'spl','*markers.log'));
        copyfile(fullfile(thispath,'spl', findlogs.name), retPath)
    else
        error('Can"t find the scan phys log')
    end

%     copyfile(magfile1,retPath)
%     copyfile(magfile2,retPath)
%     copyfile(magfile3,retPath)
%     copyfile(magfile4,retPath)

    % now run retroicor
    MB = 3;
    rinput = magfile1;
    markerfile = fullfile(retPath,findlogs.name);
    retroicor_2023(retPath,'y',2,2,2,MB,'y','b','y',rinput,markerfile)

    

end
close all


%% Combine echoes



