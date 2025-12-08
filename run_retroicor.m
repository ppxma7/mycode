function[]=run_retroicor(retroicor_path, spl_path, clv_file)

disp('Starting up RETROICOR...')

% --------------------------------------------------------
% Define paths (passed or inferred)
% --------------------------------------------------------
%retPath = pwd;  % assume script is run from retroicor directory
retPath = retroicor_path;   % passed in from bash
splPath = spl_path;

%splPath = fullfile(fileparts(retPath), 'spl');

fprintf('Retroicor path: %s\n', retPath);
fprintf('SPL path      : %s\n', splPath);

% --------------------------------------------------------
% Find NORDIC file
% --------------------------------------------------------
%%nordicFiles = dir(fullfile(retPath, '*_nordic_clv.nii'));
% nordicFiles = clv_file;
% 
% if isempty(nordicFiles)
%     error('No NORDIC file found in %s', retPath);
% elseif numel(nordicFiles) > 1
%     error('Multiple NORDIC files found in %s — cannot choose safely', retPath);
% end
% 
% rinput = fullfile(retPath, nordicFiles(1).name);
% fprintf('Using NORDIC file: %s\n', rinput);

% --------------------------------------------------------
% Use NORDIC CLV file passed from bash
% --------------------------------------------------------
rinput = clv_file;

if ~isfile(rinput)
    error('CLV NORDIC file not found: %s', rinput);
end

fprintf('Using NORDIC file: %s\n', rinput);



% --------------------------------------------------------
% Find physlog file
% --------------------------------------------------------
logFiles = dir(fullfile(splPath, '*.log'));

if isempty(logFiles)
    error('No physlog .log file found in %s', splPath);
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
if exist(markerfile, 'file')
    fprintf('Marker file already exists — skipping AddMarkers.\n');
else
    disp('First run AddMarkers')
    AddMarkers_fast(input_marker)
    pause(3)
end

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

