clear variables
close all
clc

subjects = {'prf1','prf2','prf3','prf4','prf6','prf8','prf9','prf10','prf11','prf12'};

userName = char(java.lang.System.getProperty('user.name'));

savedirUp = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Touch Remap - General/prfplots/prfsizes/'];
subjects_dir = '/Volumes/DRS-Touchmap/ma_ares_backup/subs/';  % Update to actual path
subject = 'fsaverage';
hemisphere = 'l';

% Initialize arrays to store data for FPM and overlap map
all_maps = [];
overlap_maps = [];

%upThre = max(subject_map(:));
upThre = 100;

% Loop through each subject to process pRF maps
for thisSub = 1:length(subjects)
    disp(['Processing subject ' subjects{thisSub} '...'])

    % Define the path to each subject's data
    mypath = ['/Volumes/styx/prf_fsaverage/' subjects{thisSub} '/'];
    savedir = fullfile(savedirUp, subjects{thisSub});
    if ~isfolder(savedir)
        mkdir(savedir)
    end

    % Load both rfx_fsaverage.mgh and rfy_fsaverage.mgh for each subject
    prf_files = {
        fullfile(mypath, 'rfx_fsaverage.mgh'), ...
        fullfile(mypath, 'rfy_fsaverage.mgh')
    };

    % Initialize an array to hold this subject's combined pRF map
    subject_map = zeros(size(load_mgh(prf_files{1}))); % Initialize with zeros
    
    % Load and average the rfx and rfy maps for this subject
    for ii = 1:length(prf_files)
        intensity_data = load_mgh(prf_files{ii});
        subject_map = subject_map + intensity_data;
    end
    subject_map = subject_map / length(prf_files); % Average of rfx and rfy

    % Add this subject's map to the full collection for FPM calculation
    all_maps = cat(3, all_maps, subject_map);

    % Create a binary version for overlap calculation
    overlap_maps = cat(3, overlap_maps, subject_map > 0);

    % Plot and save the individual pRF map
    figure;
    go_paint_freesurfer(subject_map, subject, hemisphere, ...
                        'subjects_dir', subjects_dir, ...
                        'surface', 'inflated', ...
                        'colormap', 'jet', ...
                        'range', [0.001 upThre], ...
                        'alpha', 1, 'cbar', true);
    % Save as PNG
    png_filename = fullfile(savedir, [subjects{thisSub} '_mean_pRF_fsaverage.png']);
    exportgraphics(gcf, png_filename, 'Resolution', 300);
    close;
end

%% 2. Calculate and save the Full Probabilistic Map (FPM)
fpm = mean(all_maps, 3); % Compute the mean across all subjects

% Plot the FPM on the fsaverage surface
figure;
go_paint_freesurfer(fpm, subject, hemisphere, ...
                    'subjects_dir', subjects_dir, ...
                    'surface', 'inflated', ...
                    'colormap', 'pink', ...
                    'range', [0.001 40], ...
                    'alpha', 1, 'cbar', true);


fpm_filename_png = fullfile(savedirUp, 'FPM_pRF_fsaverage.png');
exportgraphics(gcf, fpm_filename_png, 'Resolution', 300);
%close;
%%
% 3. Calculate and save the overlap map (number of subjects with non-zero data)
overlap_count = sum(overlap_maps, 3); % Sum across subjects to get overlap count

% Plot the overlap map on the fsaverage surface
figure;
go_paint_freesurfer(overlap_count, subject, hemisphere, ...
                    'subjects_dir', subjects_dir, ...
                    'surface', 'inflated', ...
                    'colormap', 'viridis', ...
                    'range', [1 max(overlap_count(:))], ...
                    'alpha', 1, 'cbar', true);

% Save the overlap map as an .mgh file and a PNG

overlap_filename_png = fullfile(savedirUp, 'Overlap_Map_fsaverage.png');
exportgraphics(gcf, overlap_filename_png, 'Resolution', 300);
close;

disp('All maps have been processed and saved.')
