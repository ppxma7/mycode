%% Run_first_level.m
% This script sets up and runs a first-level GLM for fMRI data using a custom
% 4x4 stimulation scheme. (The 4x4 grid is conceptually “upsampled” later in
% the pRF analysis; here we simply generate 16 regressors.)
%
% Make sure that you have created your custom stimulus function 
% `prepare_inputs_somato.m` that returns a 96×1 structure array U with fields:
%   - x: the between-digit coordinate(s) (e.g., one of 4 unique values)
%   - y: the within-digit coordinate(s) (e.g., one of 4 unique values)
%   - ons: stimulus onset (secs)
%   - dur: stimulus duration (secs)
%   - dt: time resolution within each TR
%
% Adjust the paths below as needed for your data and working directories.

%% Settings

% Directory into which to download example dataset (or point to your own data)
data_root_dir =  '/Volumes/hermes/';
data_dir      = fullfile(data_root_dir, 'prf7_bayesprf_test','fMRI');
surf_dir      = fullfile(data_root_dir, '11251', 'surf');

% Directory for creating GLM outputs
glm_dir = fullfile(data_root_dir,'prf7_bayesprf_test','GLM');
%glm_dir  = fullfile(pwd, '../GLM');

% Directory containing this script
out_dir = fullfile(data_root_dir,'prf7_bayesprf_test','outputs');

% Number of sessions (adjust if needed)
nsess = 6;

% fMRI and stimulus timing parameters
TR            = 2;      % Repetition time: 2 s (your scanner parameter)
nmicrotime    = 16;     % Microtime resolution (bins per TR)
stim_duration = 4;      % Stimulus duration: 4 s (each column/row on 4 s)
% (Note: We no longer need a 'stim_diameter' because we are not using polar coordinates)

%% Set SPM defaults and initialize the job manager
spm('defaults', 'FMRI');
spm_jobman('initcfg');

%% Download and unzip example data (if not already present)
if ~exist(data_root_dir, 'dir')
    mkdir(data_root_dir);
end

% Download (if needed)
fn = fullfile(data_root_dir, 'Example.zip');
fprintf('%-40s:', 'Downloading example dataset...');
urlwrite('https://zenodo.org/record/163582/files/Example.zip', fn);

% Unzip the dataset
unzip(fn, data_root_dir);
fprintf(' %30s\n', '...done');

%% Prepare onsets
% --- Replace the following with your own stimulus file if desired ---
% In the original code, the file 'aps_Bars.mat' was loaded.
% Here we assume that ApFrm is a 3D matrix (4 x 4 x 96) representing your stimulus.
load(fullfile(data_dir, 'aps_Bars.mat')); % (Ensure that ApFrm matches your 4x4 design)

% Use your custom function to create the stimulus structure.
% This function should output U as a 96×1 struct array with fields: x, y, ons, dur, dt.
U = prepare_inputs_somato(ApFrm, TR, nmicrotime, stim_duration);

% --- Create the onsets matrix for the GLM ---
% We want one regressor per stimulator location. Although your device is 4×4,
% we will identify the unique positions from U.x and U.y.
all_x = []; all_y = [];
for t = 1:length(U)
    if ~isempty(U(t).x)
        all_x = [all_x; U(t).x(:)];
        all_y = [all_y; U(t).y(:)];
    end
end
bins_x = unique(all_x);  % e.g., should return 4 unique x values
bins_y = unique(all_y);  % e.g., should return 4 unique y values

% (Optional upsampling note: If later you want to “expand” to a 20×20 grid,
% you could use imresize or other interpolation when creating your stimulus
% representation for the pRF model. For the GLM, however, we use the 4×4 bins.)

% Initialize a time (TRs) × (number of bins) matrix.
% Total regressors = number of unique x values * number of unique y values = 16.
onsets_matrix = zeros(length(U), numel(bins_x) * numel(bins_y));

% For each time point, assign an onset count to the corresponding bin.
for t = 1:length(U)
    % Check that there is stimulation at this time point.
    if isempty(U(t).x)
        continue;
    end
    % For each activated stimulator at time t:
    for a = 1:length(U(t).x)
        x_val = U(t).x(a);
        y_val = U(t).y(a);
        % Find the nearest bin (using absolute difference; these should match exactly)
        [~, idx_x] = min(abs(bins_x - x_val));
        [~, idx_y] = min(abs(bins_y - y_val));
        % Compute bin index (using row-major order; note: sub2ind expects [nRows, nCols])
        bin_idx = sub2ind([numel(bins_y), numel(bins_x)], idx_y, idx_x);
        onsets_matrix(t, bin_idx) = onsets_matrix(t, bin_idx) + 1;
    end
end

% Remove any regressors (columns) that were never activated
onsets_matrix = onsets_matrix(:, any(onsets_matrix, 1));
num_regressors = size(onsets_matrix, 2);

% Create SPM input structures for onsets.
names = cell(1, num_regressors); 
onsets = cell(1, num_regressors); 
durations = cell(1, num_regressors); 

for r = 1:num_regressors
    names{r} = ['Bin' num2str(r)];
    % Find all TRs at which this regressor was active.
    % (Multiply by TR to convert from volume index to seconds.)
    onsets{r} = (find(onsets_matrix(:, r)) - 1) * TR;
    durations{r} = 0; % Use zero duration for event-related regressors
end

% Save the onsets file for SPM.
save(fullfile(out_dir, 'onsets.mat'), 'names', 'onsets', 'durations');

%% Specify first-level design
start_dir = pwd;

% Create the GLM output directory if it does not exist.
if ~exist(glm_dir, 'dir')
    mkdir(glm_dir);
end

% Load a generic matlabbatch file for fmri_spec, fmri_est, and contrast definitions.
% (This file should be prepared in advance, for example based on SPM’s fMRI design.)
load('first_level_batch.mat'); % Ensure this batch file exists in the working directory

% Loop over sessions to set session-specific options.
for i = 1:nsess
    % Select motion regressors and the EPI images for session i.
    movement = spm_select('FPList', data_dir, sprintf('rp_bfBars%d.txt', i));
    epis     = spm_select('ExtFPList', data_dir, sprintf('ubfBars%d.nii', i), 1:999);
    
    % Set session-specific regressors and scans.
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi_reg = cellstr(movement);
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).scans     = cellstr(epis);
    % Use the onsets file we just created.
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi     = cellstr(fullfile(out_dir, 'onsets.mat'));
    
    % Clear any previous conditions (we are using the multiple-regressor approach)
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).regress = struct('name', {}, 'val', {});
    
    % Set high-pass filter cutoff (in seconds)
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).hpf = 128;    
end

% Set global model specifications.
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(glm_dir);
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;

% Run the SPM first-level specification job.
spm_jobman('run', matlabbatch);
cd(start_dir);

%% Import cortical surface
% This creates surface images (lh_surface.nii, rh_surface.nii) and accompanying .mat files.
structural_image = fullfile(data_dir, 'T1.nii');
spm_prf_import_surface(glm_dir, structural_image, surf_dir, 'lh');
spm_prf_import_surface(glm_dir, structural_image, surf_dir, 'rh');

%% Build a mask of voxels surviving p < 0.001
clear matlabbatch;
matlabbatch{1}.spm.stats.results.spmmat = cellstr(fullfile(glm_dir, 'SPM.mat'));
matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.export{1}.binary.basename = 'mask_uncorrected';
spm_jobman('run', matlabbatch);

%% Remove voxels from the mask anterior to y = 0
cd(glm_dir);
V = spm_vol('spmF_0001_mask_uncorrected.nii');
[Y, XYZmm] = spm_read_vols(V);
% Remove voxels with y-coordinate greater than 0 (in mm)
i = XYZmm(2, :) > 0;
Y(i) = 0;
spm_write_vol(V, Y);
cd(start_dir);

%% Extract timeseries from surface voxels surviving p < 0.001
hemi = 'lh';  % Analyze left hemisphere (adjust as needed)
spm_F_mask   = fullfile(glm_dir, 'spmF_0001_mask_uncorrected.nii');
surface_mask = fullfile(glm_dir, [hemi '_surface.nii']);

% Load the extraction batch file (make sure 'extract_timeseries_batch.mat' exists)
load('extract_timeseries_batch.mat');
matlabbatch{1}.spm.util.voi.name   = [hemi '_prf_mask'];
matlabbatch{1}.spm.util.voi.spmmat = cellstr(fullfile(glm_dir, 'SPM.mat'));
matlabbatch{1}.spm.util.voi.roi{1}.mask.image = cellstr(spm_F_mask);
matlabbatch{1}.spm.util.voi.roi{2}.mask.image = cellstr(surface_mask);
matlabbatch{1}.spm.util.voi.expression = 'i1 & i2';

spm_jobman('run', matlabbatch);
