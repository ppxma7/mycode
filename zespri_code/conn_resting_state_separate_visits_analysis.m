addpath('/software/imaging/spm12');  % Adjust the path to where SPM is installed
addpath('/software/imaging/conn/22a/conn');   % Adjust the path to where CONN is installed

% Display the version to ensure it's correctly added
spm('Defaults','fMRI');
%conn;

% Define the path for the project file
mypath = '/imgshare/7tfmri/michael/data/';
project_filename = fullfile(mypath, 'conn_project.mat');

% Initialize the CONN batch structure
clear batch;


% Load the existing project
conn_module('load', project_filename);



batch.filename = project_filename;



% here run analysis commands

batch.Analysis.done=1;
batch.Analysis.overwrite='Yes';

batch.vvAnalysis.done=1;
batch.vvAnalysis.overwrite='Yes';

batch.dynAnalysis.done=1;
batch.dynAnalysis.overwrite='Yes';

batch.Results.done=1;
batch.Results.overwrite='Yes';

conn_batch(batch);


conn('save', project_filename)

disp('Done')


