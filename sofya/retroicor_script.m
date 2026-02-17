
close all
clear variables
clc
tic
disp('Starting up RETROICOR...')
%retPath = '/Volumes/kratos/SOFYA/12185_004/spl2/';
retPath = '/gpfs01/home/ppzma/sofya_nexpo_data/sub01/retroicor/';
cd(retPath)
MB = 2;
%rinput = [retPath '/12185_004_WIP_fMRI_RS_20220804125939_1001_nordic.nii'];
rinput = [retPath '/fMRI_RS_20220804125939_1001_nordic.nii'];

input_marker = [retPath 'SCANPHYSLOG20220804140114.log'];
[folder, name, ext] = fileparts(input_marker);
markerfile = fullfile(folder, [name '_markers' ext]);
disp(markerfile)

disp('First run add markers')
AddMarkers_fast(input_marker)
pause(3)

disp('Now run retroicor')
retroicor_noquestion(retPath,'y',2,2,2,MB,'y','b','y',rinput,markerfile)
disp('RETROICOR is complete')
toc

%%
close all
clear variables
clc
tic

disp('Starting up RETROICOR...')

% --------------------------------------------------------
% Define paths (passed or inferred)
% --------------------------------------------------------
retPath = pwd;  % assume script is run from retroicor directory
splPath = fullfile(fileparts(retPath), 'spl');

fprintf('Retroicor path: %s\n', retPath);
fprintf('SPL path      : %s\n', splPath);

% --------------------------------------------------------
% Find NORDIC file
% --------------------------------------------------------
nordicFiles = dir(fullfile(retPath, '*_nordic.nii'));

if isempty(nordicFiles)
    error('No NORDIC file found in %s', retPath);
elseif numel(nordicFiles) > 1
    error('Multiple NORDIC files found in %s — cannot choose safely', retPath);
end

rinput = fullfile(retPath, nordicFiles(1).name);
fprintf('Using NORDIC file: %s\n', rinput);

% --------------------------------------------------------
% Find physlog file
% --------------------------------------------------------
logFiles = dir(fullfile(splPath, '*.log'));

if isempty(logFiles)
    error('No physlog .log file found in %s', splPath);
elseif numel(logFiles) > 1
    error('Multiple .log files found in %s — cannot choose safely', splPath);
end

input_marker = fullfile(splPath, logFiles(1).name);
fprintf('Using physlog file: %s\n', input_marker);

% --------------------------------------------------------
% Define marker file name
% --------------------------------------------------------
[folder, name, ext] = fileparts(input_marker);
markerfile = fullfile(folder, [name '_markers' ext]);
disp(['Marker file will be: ' markerfile])

% --------------------------------------------------------
% Parameters
% --------------------------------------------------------
MB = 2;

% --------------------------------------------------------
% Run AddMarkers
% --------------------------------------------------------
disp('First run add markers')
AddMarkers_fast(input_marker)
pause(3)

% --------------------------------------------------------
% Run RetroICOR
% --------------------------------------------------------
disp('Now run RETROICOR')
retroicor_noquestion( ...
    retPath, ...
    'y',2,2,2,MB, ...
    'y','b','y', ...
    rinput, ...
    markerfile )

disp('RETROICOR is complete')
toc
