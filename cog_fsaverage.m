clear variables
close all
clc

%thisSub = 'prf1';

subjects = {'00393_LD_touchmap','00393_RD_touchmap',...
    '03677_LD', '03677_RD', '03942_LD', '03942_RD', '13172_LD', '13172_RD', ...
    '13493_Btx_LD', '13493_Btx_RD', '13493_NoBtx_LD', '13493_NoBtx_RD', ...
    '13658_Btx_LD', '13658_Btx_RD', '13658_NoBtx_LD', '13658_NoBtx_RD', ...
    '13695_Btx_LD', '13695_Btx_RD', '13695_NoBtx_LD', '13695_NoBtx_RD', ...
    '14001_Btx_LD', '14001_Btx_RD', '14001_NoBtx_LD', '14001_NoBtx_RD',...
    '04217_LD', '08740_RD','08966_RD', '09621_RD', '10301_LD', '10301_RD', ...
    '10875_RD', '11120_LD', '11120_RD', '11240_LD', '11240_RD', '11251_LD', '11251_RD',...
    'HB2_LD', 'HB2_RD', 'HB3_LD', 'HB3_RD', 'HB4_LD', 'HB4_RD', 'HB5_LD', 'HB5_RD'};


%subjects = {'00393_LD_touchmap','00393_RD_touchmap'};

userName = char(java.lang.System.getProperty('user.name'));

savedirUp = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Touch Remap - General/prfplots/'];


% Define parameters for the sphere marker
sphere_radius = 2;  % Adjust radius as needed for visibility
[sphere_x, sphere_y, sphere_z] = sphere(20);  % Sphere resolution (20x20 grid)

myspherecolors = {'r','g','c','b','m'};

nDigs = 5;

cog_list = zeros(nDigs, 3,length(subjects));  % Array to store each CoG's coordinates

for thisSub = 1:length(subjects)

    disp(['Running ' subjects{thisSub} ' now...'])


    mypath = ['/Volumes/styx/prf_fsaverage/' subjects{thisSub} '/'];
    %mypath = ['/Volumes/DRS-Touchmap/ma_ares_backup/prf_fsaverage/' subjects{thisSub} '/'];

    savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Touch Remap - General/prfplots/' subjects{thisSub} '/'];

    if ~isfolder(savedir)
        mkdir(savedir)
    end
    
    % Define paths

    if thisSub<25
        subjects_dir = '/Volumes/DRS-Touchmap/ma_ares_backup/subs/';  % Update to actual path
    else
        subjects_dir = '/Volumes/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/';
    end

    subject = 'fsaverage';

    if contains(subjects(thisSub), '_LD')
        hemisphere = 'r';  % Change to 'r' for right hemisphere
    elseif contains(subjects(thisSub),'_RD')
        hemisphere = 'l';
    end

    % Load the inflated surface vertices for visualization
    [vertices, faces] = read_surf(fullfile(subjects_dir, ...
        subject, 'surf', strcat(hemisphere, 'h.inflated')));

    %fsavg_path = '/Volumes/styx/fsaverage_copy/surf/';
    % Load fsaverage surface
    %[coords, faces] = read_surf([fsavg_path 'lh.inflated']);  % Replace with actual path
    % coords is Nx3 array of vertex coordinates, faces is Mx3 array of face indices
    
    % Load your intensity data
    %mgh_file = [mypath 'co_masked_0_1_57_co_thresh_fsaverage.mgh'];

    % Define thresholded phase-binned images and a list for CoG storage

    % threshold_files = {
    %     [mypath 'co_masked_0_1_57_co_thresh_fsaverage.mgh'], ...
    %     [mypath 'co_masked_1_57_3_14_co_thresh_fsaverage.mgh'], ...
    %     [mypath 'co_masked_3_14_4_71_co_thresh_fsaverage.mgh'], ...
    %     [mypath 'co_masked_4_71_6_28_co_thresh_fsaverage.mgh']
    %     };

    threshold_files = {
        [mypath 'co_masked_0_1_256_co_thresh_fsaverage.mgh'], ...
        [mypath 'co_masked_1_256_2_512_co_thresh_fsaverage.mgh'], ...
        [mypath 'co_masked_2_512_3_768_co_thresh_fsaverage.mgh'], ...
        [mypath 'co_masked_3_768_5_024_co_thresh_fsaverage.mgh'],...
        [mypath 'co_masked_5_024_6_28_co_thresh_fsaverage.mgh'],...
        };


    


    % Plot the surface using go_paint_freesurfer function without any intensity data
    % figure;
    % [h, cm] = go_paint_freesurfer(zeros(size(vertices, 1), 1), subject, hemisphere, ...
    %     'subjects_dir', subjects_dir, 'surface', ...
    %     'inflated', 'colormap', 'jet', 'range', [0.1 1], 'alpha', 1);
    % hold on;

    % Loop through each thresholded image and calculate the adjusted CoG
    for ii = 1:length(threshold_files)
        % Load intensity data for the current thresholded ROI
        intensity_data = load_mgh(threshold_files{ii});

        % Define the ROI using a minimum intensity threshold
        threshold = 0.3;  % Adjust as needed
        roi_mask = intensity_data >= threshold;

        % Apply the mask to exclude non-ROI vertices
        roi_intensity_data = intensity_data .* roi_mask;

        % Calculate the initial CoG based on intensity values
        weighted_coords = bsxfun(@times, vertices, roi_intensity_data);
        sum_weights = sum(roi_intensity_data);
        initial_cog = sum(weighted_coords, 1) / sum_weights;

        % Find the nearest vertex in the ROI to ensure CoG is within ROI bounds
        roi_vertices = vertices(roi_mask, :);
        nearest_idx = knnsearch(roi_vertices, initial_cog);
        adjusted_cog = roi_vertices(nearest_idx, :);

        % Store the adjusted CoG coordinates
        cog_list(ii, :, thisSub) = adjusted_cog;

        % Plot the thresholded image on the surface using go_paint_freesurfer
        figure;
        go_paint_freesurfer(roi_intensity_data, subject, hemisphere, ...
            'subjects_dir', subjects_dir, 'surface',...
            'inflated', 'colormap',...
            'jet', 'range', [0.1 max(intensity_data)], 'alpha', 1);

        hold on;

        % Plot the adjusted CoG as a green sphere on the surface
        surf(sphere_radius * sphere_x + adjusted_cog(1), ...
            sphere_radius * sphere_y + adjusted_cog(2), ...
            sphere_radius * sphere_z + adjusted_cog(3), ...
            'FaceColor', myspherecolors{ii}, 'EdgeColor', 'none', 'FaceAlpha', 0.8);  % Green sphere for each CoG


        if length(intensity_data) ~= size(vertices, 1)
            error('Mismatch between data points and surface vertices.');
        end
        title(sprintf('Center of Gravity for Phase Bin %d on Inflated Brain Surface', ii));
        hold off;

        % Save the figure as a PDF using exportgraphics
        pdf_filename = fullfile(savedir, sprintf('CoG_Phase_Bin_%d.pdf', ii));
        exportgraphics(gcf, pdf_filename, 'ContentType', 'image', 'Resolution', 300);

        

    end

    close all

end

% Finalize plot
% title('Centers of Gravity for Thresholded ROIs on Inflated Brain Surface');
% hold off;

%% Display calculated CoGs
%disp('Adjusted CoGs for each thresholded image:');
%disp(cog_list);

% Calculate the total Euclidean distance between each consecutive CoG
%total_distance = 0;

totalDistCogs = zeros(size(cog_list,3),1);
%totalDistCogsNames = cell(size(cog_list,3),1);

for loopSub = 1:size(cog_list,3)
    
    total_distance = 0;
    thisCog = cog_list(:,:,loopSub);

    for jj = 1:size(thisCog, 1) - 1
        % Calculate Euclidean distance between consecutive CoGs
        dist = norm(thisCog(jj+1, :) - thisCog(jj, :));
        total_distance = total_distance + dist;
    end

    totalDistCogs(loopSub) = total_distance; % save each subject's D1-D5 distance here
    %totalDistCogsNames{loopSub} = subjects{loopSub};

    % Display the total distance
    fprintf('Subject: %s \n', subjects{loopSub});
    fprintf('Total Euclidean distance between CoGs: %.2f mm\n', total_distance);


end




%%
csv_filename = [savedirUp 'full_cog.csv'];  % Update with your desired path

% Get the size of the array
[numRows, numCols, numSubjects] = size(cog_list);

% Preallocate a cell array for reshaping the data (for text and numeric data)
csvData = cell(numRows * numSubjects, numCols + 1);

% Populate the 2D cell array for CSV output
for ix = 1:numSubjects
    startIdx = (ix - 1) * numRows + 1;
    endIdx = ix * numRows;
    csvData(startIdx:endIdx, 1:numCols) = num2cell(cog_list(:, :, ix));  % Copy data as cells
    csvData(startIdx:endIdx, numCols + 1) = subjects(ix);  % Add subject name
end

% Convert to table and add column names
csvTable = cell2table(csvData, 'VariableNames', {'X', 'Y', 'Z', 'Subject'});

% Save as CSV
writetable(csvTable, csv_filename);

% also save out distances
csv_filename2 = [savedirUp 'total_cog.csv'];  % Update with your desired path
distanceTable = table(subjects', totalDistCogs, 'VariableNames', {'Subject', 'Distance'});
writetable(distanceTable, csv_filename2);

%% once this is all done, need to plot
% plot LD and RD separately
% and plot healthies (incl. atlas subs) vs touchmap BTX vs. touchmap NoBTX
% Just plot total distance, so one number for each subject. 






