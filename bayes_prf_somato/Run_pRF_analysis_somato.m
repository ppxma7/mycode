%% Run_pRF_analysis_somato.m
% This script runs a pRF analysis adapted for somatosensory (hand) space.
% It uses a custom input preparation function that processes a 4x4 grid
% (ApFrm from your stim files) and a pRF model that is tailored for somato data.

%% Settings and Directory Setup

data_root_dir = '/Volumes/hermes/';
thisDSet      = 'prf7_bayesprf_test';

% Directories for data, GLM outputs, and other outputs
data_dir      = fullfile(data_root_dir, thisDSet, 'fMRI');
top_dir       = fullfile(data_root_dir, thisDSet);
glm_dir       = fullfile(data_root_dir, thisDSet, 'GLM');
out_dir       = fullfile(data_root_dir, thisDSet, 'outputs');

% fMRI and stimulus timing parameters
TR            = 2;       % Repetition time (seconds)
nmicrotime    = 16;      % Microtime resolution (bins per TR)
stim_duration = 4;       % Stimulus duration in seconds

% Specify sessions (for example, 6 scans: FWD, REV, UP1, UP2, DWN1, DWN2)
sess          = 1:6;
num_sess      = length(sess);

% Hemisphere (or later, region) to analyze – adjust if necessary
hemi          = 'lh';

%% Prepare Somatosensory Stimulus Inputs

% List your somatosensory stim files
stim_files = {'fwd1.mat', 'rev1.mat', 'up1.mat', 'dwn1.mat'};

% For demonstration, we load one stim file (e.g., fwd1.mat).
% If you need to merge inputs across stim files, you might concatenate U
load(fullfile(top_dir, stim_files{1}));  % Loads variable 'ApFrm'
% Use your somato-specific preparation function. This function should take
% the 4x4x96 ApFrm matrix and return a structure U with fields 'x' and 'y'
% where x and y reflect the grid locations (e.g., with the center at 0,0)
U = prepare_inputs_polar_samsrf_somato(ApFrm, TR, nmicrotime, stim_duration);

%% Step 1: Load Surface Geometry
% This loads Srf with fields: Voxels, Vertices, etc.
load(fullfile(glm_dir, 'lh_Srf.mat'));  % Adjust the path as needed

% For our purposes, we need the vertices coordinates.
% Ensure that Srf.Vertices is in the same space as your fMRI data.
vertices = Srf.Voxels;  % [n_vertices x 3]

%% Step 2: Load fMRI 4D NIfTI Data
% Specify your fMRI timeseries file (4D NIfTI)
fmri_file = fullfile(top_dir, 'ubf_FWD_nordic_cleave_toppedup.nii');  % Replace with your actual file name
V = spm_vol(fmri_file);
n_time = numel(V);       % Number of time points (volumes)
n_vertices = size(vertices, 1);

%% Step 3: Extract the Timeseries for Each Vertex
% Initialize matrix to hold timeseries: each row = time, each column = vertex
timeseries = zeros(n_time, n_vertices);

for t = 1:n_time
    % Use spm_sample_vol to sample the volume at all vertex coordinates.
    % spm_sample_vol(V, x, y, z, interpolation) can accept vectors.
    % The vertices are assumed to be in the same space as the fMRI volumes.
    ts = spm_sample_vol(V(t), vertices(:,1), vertices(:,2), vertices(:,3), 1);
    timeseries(t,:) = ts;
end

%% Step 4: Create the xY Structure
% For the summary timeseries, you could use the mean signal across vertices.
summary_ts = mean(timeseries, 2);

% Alternatively, you might compute the principal eigenvariate (requires SPM's tools).
% For now, we use the mean.
xY_struct = struct;
xY_struct.Y = summary_ts;       % [n_time x 1] summary timeseries
xY_struct.y = timeseries;         % [n_time x n_vertices] full timeseries
xY_struct.XYZmm = vertices';      % [3 x n_vertices] vertex coordinates

% Wrap in a cell array (one session)
xY = {xY_struct};

%% Step 5: Specify the pRF Model
% Load SPM structure for timing information and image dimensions
SPM = load(fullfile(glm_dir, 'SPM.mat'));
SPM = SPM.SPM;
SPM.swd = glm_dir;  % Update working directory

% pRF specification options using your somatosensory model
options = struct('TE', 0.055, ...        % Echo time (adjust as needed)
                 'voxel_wise', true, ...
                 'name', [Srf.Hemisphere '_Somato_example'], ...
                 'model', 'spm_prf_fcn_gaussian_somato', ... % Use somato pRF model
                 'B0', 3);

% Specify the pRF model. The output file will be saved in the GLM directory.
PRF = spm_prf_analyse('specify', SPM, xY, U, options);





%% Estimate a Single Voxel as an Example

% For a quick test, estimate the pRF parameters for one voxel (e.g., voxel 1395)
voxel = 74994;
prf_file = fullfile(glm_dir, ['PRF_' hemi '_Somato_example.mat']);

% Estimation options: specify the voxel
est_options = struct('voxels', voxel);
PRF_est = spm_prf_analyse('estimate', prf_file, est_options);

% Review the estimation for the chosen voxel
spm_prf_review(prf_file, voxel);

%% Estimate All Voxels (Optional – may take longer)
% Uncomment and run this section if you want to estimate pRF parameters for all voxels
% est_options = struct('use_parfor', true);
% PRF_est = spm_prf_analyse('estimate', prf_file, est_options);
% spm_prf_review(prf_file);

%% (Optional) ROI Analysis and Visualization

% If you have an ROI label (e.g., for the somatosensory hand region), you can import it:
% label_file = fullfile(data_dir, 'lh_Somato.label');
% spm_prf_import_label(label_file, glm_dir);

% To summarize the pRF responses in an ROI:
% roi = fullfile(glm_dir, [hemi '_Somato.nii']);
% figure('Color','w');
% spm_prf_summarise(PRF, roi);
% title('Somatosensory Region of Interest','FontSize',16);

%% (Optional) Plot pRF Certainty via a Negative Entropy Map
% For somato data, you might plot the spatial certainty over x and y instead of angle/distance:
% spm_prf_plot_entropy(PRF, {'x', 'y'}, 'x_y', true);
