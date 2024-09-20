
% Add SPM and CONN to the MATLAB path
addpath('/software/imaging/spm12');  % Adjust the path to where SPM is installed
addpath('/software/imaging/conn/22a/conn');   % Adjust the path to where CONN is installed

% Display the version to ensure it's correctly added
spm('Defaults','fMRI');
conn;
%conn_module('init', 'path');

% Your preprocessing and analysis script
mypath = '/imgshare/7tfmri/michael/data/';
cd(mypath);

%%
%mypath = '/Volumes/DRS-7TfMRI/michael/ZESPRI/';
%cd(mypath)

% Initialize the CONN batch structure
clear batch;
%batch.filename = fullfile(pwd, 'conn_project.mat');

project_filename = fullfile(mypath, 'conn_project.mat');
batch.filename = project_filename;


% Number of subjects, sessions, and conditions
nsubjects = 14;
nsessions = 2;
nconditions = 4;

% Define subject directories and filenames
subject_ids = arrayfun(@(x) sprintf('sub-%02d', x), 1:nsubjects, 'UniformOutput', false);
condition_names = {'rs_RED', 'rs_GOLD', 'rs_GREEN', 'rs_MTX'};

% Preprocessed functional and anatomical data paths
structural_dir = [mypath 'zespri_structurals/'];
functional_dir = [mypath 'rs_visits/%s/raw_data/'];

func_files = cell(nsubjects, nconditions, nsessions);
struct_files = cell(nsubjects, 1);

% Assign structural data
for subj = 1:nsubjects
    struct_files{subj} = fullfile(structural_dir, sprintf('%s/mzespri_%sA_mprage_masked.nii', subject_ids{subj}, num2str(subj)));
end

% Assign functional data
for cond = 1:nconditions
    for subj = 1:nsubjects
        for sess = 1:nsessions
            func_files{subj, cond, sess} = fullfile(sprintf(functional_dir, condition_names{cond}), sprintf('swurs%d_%s.nii', sess, subject_ids{subj}));
        end
    end
end

% Setup batch structure
batch.Setup.nsubjects = nsubjects;
batch.Setup.RT = 1.5; % Repetition time (adjust as necessary)
batch.Setup.conditions.names = {'Visit1', 'Visit2'};
batch.Setup.nsessions = nsessions;

% Link functional and structural files
batch.Setup.functionals = repmat({{}}, nsubjects, 1);
batch.Setup.structurals = struct_files;
for subj = 1:nsubjects
    for cond = 1:nconditions
        for sess = 1:nsessions
            batch.Setup.functionals{subj}{(cond-1)*nsessions + sess} = func_files{subj, cond, sess};
        end
    end
end

% 
% batch.Setup.conditions.names = condition_names;
% batch.Setup.conditions.onsets = cell(nconditions, nsubjects, nsessions);
% batch.Setup.conditions.durations = cell(nconditions, nsubjects, nsessions);
% for cond = 1:nconditions
%     for subj = 1:nsubjects
%         for sess = 1:nsessions
%             % Adjusted indexing to prevent exceeding array bounds
%             batch.Setup.conditions.onsets{cond, subj, sess} = 0;
%             batch.Setup.conditions.durations{cond, subj, sess} = inf;
%         end
%     end
% end





% Setup additional files
batch.Setup.masks.Grey.files = cell(nsubjects, 1);
batch.Setup.masks.White.files = cell(nsubjects, 1);
batch.Setup.masks.CSF.files = cell(nsubjects, 1);

for subj = 1:nsubjects
    % Assuming masks are named consistently for each subject
    batch.Setup.masks.Grey.files{subj} = fullfile(sprintf(structural_dir, subject_ids{subj}), sprintf('%s/c1cmzespri_%sA_mprage_masked.nii', subject_ids{subj}, num2str(subj)));
    batch.Setup.masks.White.files{subj} = fullfile(sprintf(structural_dir, subject_ids{subj}), sprintf('%s/c2cmzespri_%sA_mprage_masked.nii', subject_ids{subj}, num2str(subj)));
    batch.Setup.masks.CSF.files{subj} = fullfile(sprintf(structural_dir, subject_ids{subj}), sprintf('%s/c3cmzespri_%sA_mprage_masked.nii', subject_ids{subj}, num2str(subj)));
end


% % Preprocessing step
% batch.Setup.preprocessing.steps = {'functional_realign&unwarp', 'functional_coregister', 'functional_segment&normalize', 'functional_smooth'};
% batch.Setup.preprocessing.fwhm = 5; % Smoothing kernel size (adjust as necessary)
% batch.Setup.done = 1;
% batch.Setup.overwrite = 'Yes';

% Preprocessing step - only smoothing
% batch.Setup.preprocessing.steps = {'functional_smooth'};
% batch.Setup.preprocessing.fwhm = 5; % Smoothing kernel size (adjust as necessary)
% batch.Setup.done = 1;
% batch.Setup.overwrite = 'No'; % Ensure not to overwrite previously completed steps


%%
% conn_batch(batch);
% conn save project_filename;


%%

% Denoising step
batch.Denoising.filter = [0.008, 0.09]; % Frequency filter
batch.Denoising.detrend = 1; % Apply linear detrending
batch.Denoising.despiking = 1; % Apply despiking

% Specify confounding variables to regress out
batch.Denoising.confounds.names = {'White Matter', 'CSF', 'Realignment', 'Scrubbing'};
batch.Denoising.confounds.dimensions = [5, 5, 6, 1]; % Number of components for each confound


batch.Denoising.done = 1;
batch.Denoising.overwrite = 'Yes';


%%
% Analysis: Seed-Based Correlation, ROI-to-ROI, and ICA
% batch.Analysis.analysis_number = 1;
% batch.Analysis.measure = 1; % SBC
% batch.Analysis.measure = 2; % RRC
% batch.Analysis.measure = 4; % ICA
% batch.Analysis.done = 1;
% batch.Analysis.overwrite = 'Yes';

conn save project_filename;

% Run the batch
conn_batch(batch);







