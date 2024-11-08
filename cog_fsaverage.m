clear variables
close all
clc

thisSub = 'prf1';
mypath = ['/Volumes/styx/' thisSub '/'];
%fsavg_path = '/Volumes/styx/fsaverage_copy/surf/';
% Load fsaverage surface
%[coords, faces] = read_surf([fsavg_path 'lh.inflated']);  % Replace with actual path
% coords is Nx3 array of vertex coordinates, faces is Mx3 array of face indices
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Touch Remap - General/prfplots/' thisSub '/'];
% Define paths
subjects_dir = '/Volumes/DRS-Touchmap/ma_ares_backup/subs/';  % Update to actual path
subject = 'fsaverage';
hemisphere = 'l';  % Change to 'r' for right hemisphere

% Load the inflated surface vertices for visualization
[vertices, faces] = read_surf(fullfile(subjects_dir, ...
    subject, 'surf', strcat(hemisphere, 'h.inflated')));

% Load your intensity data
%mgh_file = [mypath 'co_masked_0_1_57_co_thresh_fsaverage.mgh'];

% Define thresholded phase-binned images and a list for CoG storage
threshold_files = {
    [mypath 'co_masked_0_1_57_co_thresh_fsaverage.mgh'], ...
    [mypath 'co_masked_1_57_3_14_co_thresh_fsaverage.mgh'], ...
    [mypath 'co_masked_3_14_4_71_co_thresh_fsaverage.mgh'], ...
    [mypath 'co_masked_4_71_6_28_co_thresh_fsaverage.mgh']
};
cog_list = zeros(4, 3);  % Array to store each CoG's coordinates

% Define parameters for the sphere marker
sphere_radius = 2;  % Adjust radius as needed for visibility
[sphere_x, sphere_y, sphere_z] = sphere(20);  % Sphere resolution (20x20 grid)

myspherecolors = {'r','g','b','m'};
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
    cog_list(ii, :) = adjusted_cog;

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

% Finalize plot
% title('Centers of Gravity for Thresholded ROIs on Inflated Brain Surface');
% hold off;

%% Display calculated CoGs
disp('Adjusted CoGs for each thresholded image:');
disp(cog_list);

% Calculate the total Euclidean distance between each consecutive CoG
total_distance = 0;

for jj = 1:size(cog_list, 1) - 1
    % Calculate Euclidean distance between consecutive CoGs
    dist = norm(cog_list(jj+1, :) - cog_list(jj, :));
    total_distance = total_distance + dist;
end

% Display the total distance
fprintf('Total Euclidean distance between CoGs: %.2f mm\n', total_distance);

%% % Define file path for saving the CSV
csv_filename = [savedir thisSub '_cog.csv'];  % Update with your desired path

% Assuming cog_list contains CoG coordinates and total_distance contains the total distance
% CoG coordinates (x, y, z) for each phase bin
% Example structure: cog_list = [x1, y1, z1; x2, y2, z2; x3, y3, z3; x4, y4, z4];

% Convert CoG coordinates to a table
cog_table = array2table(cog_list, 'VariableNames', {'X', 'Y', 'Z'});
cog_table.Properties.RowNames = {'Phase_Bin_1', 'Phase_Bin_2', 'Phase_Bin_3', 'Phase_Bin_4'};

% Add a row for the total distance
% Add a row for the total distance with empty values for X, Y, Z
total_distance_row = {NaN, NaN, NaN, total_distance};  % Use empty cells for X, Y, Z and total distance in the 4th column
total_distance_table = cell2table(total_distance_row, 'VariableNames', {'X', 'Y', 'Z', 'Total_Distance'}, 'RowNames', {'Total_Distance'});

% Combine the tables
combined_table = [cog_table, array2table(nan(height(cog_table), 1), 'VariableNames', {'Total_Distance'})]; % Add empty Total_Distance column to cog_table
combined_table = [combined_table; total_distance_table]; % Append total distance row

% Save to CSV
writetable(combined_table, csv_filename, 'WriteRowNames', true);

% Display a message to confirm the file was saved
fprintf('CoG data with total distance saved to %s\n', csv_filename);




