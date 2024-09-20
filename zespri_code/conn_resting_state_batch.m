
% Add SPM and CONN to the MATLAB path
addpath('/software/imaging/spm12');  % Adjust the path to where SPM is installed
addpath('/software/imaging/conn/22a/conn');   % Adjust the path to where CONN is installed

% Display the version to ensure it's correctly added
spm('Defaults','fMRI');
conn_module('init', 'path');

structPath='/imgshare/7tfmri/michael/data/zespri_structurals/';

%% try denoising one subject
% mypath='/imgshare/7tfmri/michael/data/resting_state_20mins_denoised/zespri_rs_smoothed_denoised_C/';
% cd(mypath)
% 
% iterationTimes = zeros(1,14);
% overallTic = tic;
% for ii = 1:14
%     iterationTic = tic;
% 
%     thisFile=['swurs_mrg_' num2str(ii) 'C.nii'];
%     thisFullFile=[mypath thisFile];
% 
% 
%     realignFile = ['rp_rs_mrg_' num2str(ii) 'C.txt'];
%     scrubFile = ['art_regression_outliers_urs_mrg_' num2str(ii) 'C.mat'];
% 
%     if ii<10
%         thisSub= ['sub-0' num2str(ii) '/'];
%     elseif ii>=10
%         thisSub= ['sub-' num2str(ii) '/'];
%     end
% 
%     c2File = [structPath thisSub 'c2cmzespri_' num2str(ii) 'A_mprage_masked.nii'];
%     c3File = [structPath thisSub 'c3cmzespri_' num2str(ii) 'A_mprage_masked.nii'];
% 
% 
%     conn_module('preprocessing',...
%         'functionals',   {thisFullFile}, ...
%         'covariates',    struct(...
%         'names',     {{'realignment','scrubbing'}},...
%         'files',     {{realignFile, scrubFile}}),...
%         'masks',         struct(...
%         'White',     {{c2File}},...
%         'CSF',       {{c3File}}), ...
%         'steps',         {'functional_regression', 'functional_bandpass'}, ...
%         'reg_names',     {'realignment','scrubbing','White Matter','CSF'}, ...
%         'reg_dimensions',[inf, inf, 5, 5], ...
%         'reg_deriv',     [1, 0, 0, 0], ...
%         'bp_filter',     [0.008 inf] )
% 
% 
%     iterationTimes(ii) = toc(iterationTic);
% 
%     fprintf('Time for iteration %d: %.4f seconds\n', ii, iterationTimes(ii));
% 
% 
% end
% overallTime = toc(overallTic);
% 
% fprintf('GROUP C Overall time for the loop: %.2f seconds\n', overallTime);

%% And for D
%% try denoising one subject
mypath='/imgshare/7tfmri/michael/data/resting_state_20mins_denoised/zespri_rs_smoothed_denoised_D/';
cd(mypath)

iterationTimes = zeros(1,14);
overallTic = tic;
for ii = 11:14
    iterationTic = tic;

    thisFile=['swurs_mrg_' num2str(ii) 'D.nii'];
    thisFullFile=[mypath thisFile];


    realignFile = ['rp_rs_mrg_' num2str(ii) 'D.txt'];
    scrubFile = ['art_regression_outliers_urs_mrg_' num2str(ii) 'D.mat'];

    if ii<10
        thisSub= ['sub-0' num2str(ii) '/'];
    elseif ii>=10
        thisSub= ['sub-' num2str(ii) '/'];
    end

    c2File = [structPath thisSub 'c2cmzespri_' num2str(ii) 'A_mprage_masked.nii'];
    c3File = [structPath thisSub 'c3cmzespri_' num2str(ii) 'A_mprage_masked.nii'];

%     c2File = [structPath 'c2cmzespri_' num2str(ii) 'A_mprage_masked.nii'];
%     c3File = [structPath 'c3cmzespri_' num2str(ii) 'A_mprage_masked.nii'];


    conn_module('preprocessing',...
        'functionals',   {thisFullFile}, ...
        'covariates',    struct(...
        'names',     {{'realignment','scrubbing'}},...
        'files',     {{realignFile, scrubFile}}),...
        'masks',         struct(...
        'White',     {{c2File}},...
        'CSF',       {{c3File}}), ...
        'steps',         {'functional_regression', 'functional_bandpass'}, ...
        'reg_names',     {'realignment','scrubbing','White Matter','CSF'}, ...
        'reg_dimensions',[inf, inf, 5, 5], ...
        'reg_deriv',     [1, 0, 0, 0], ...
        'bp_filter',     [0.008 inf] )


    iterationTimes(ii) = toc(iterationTic);

    fprintf('Time for iteration %d: %.4f seconds\n', ii, iterationTimes(ii));


end
overallTime = toc(overallTic);

fprintf('GROUP D Overall time for the loop: %.2f seconds\n', overallTime);






















