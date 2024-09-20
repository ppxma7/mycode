%% paths laods

clear all
close all
clc

mapcol = brewermap(256,'*YlGnBu');
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Zespri- fMRI - General/analysis/rs/'];

if strcmpi(userName,'spmic')
    whichSPM = 'MATLAB/spm';
else
    whichSPM = 'spm12';
end

%% atlas file
atlas_file = niftiread(['/Users/' userName '/Documents/' whichSPM '/tpm/HarvardOxford-cort-maxprob-thr25-2mm.nii']);

% Get unique ROI indices
roi_indices = unique(atlas_file);
roi_indices(roi_indices == 0) = []; % Remove the background (index 0)

% Number of ROIs
num_rois = numel(roi_indices);

label_file=['/Users/' userName '/Documents/' whichSPM '/tpm/HarvardOxford-cort-maxprob-thr25-2mm_labels.txt'];
% Open the file
fileID = fopen(label_file, 'r');
% Read the file line by line
labels = textscan(fileID, '%s', 'Delimiter', '\t');
% Close the file
fclose(fileID);
labels{1,2} = [1:48]';

roi_labels = labels{1};
roi_indices = labels{2};

% Display the ROI indices and labels
for i = 1:length(roi_indices)
    fprintf('ROI %d: %s\n', roi_indices(i), roi_labels{i});
end

%% can we try plotting one guy to check?

mypath='/Volumes/nemosine/resting_state_20mins_denoised/zespri_rs_smoothed_denoised_D/';
cd(mypath)

%scans={'bdswurs_mrg_1A.nii'};
%motionFiles={'rp_rs_mrg_1A.txt'};

roi_time_series_stack = zeros(48,800,14);

nSubs = 14;
nSubs = 1;



tic
for ii = 1:nSubs

    if contains(mypath,'RED')
        if ii<7
            letter = 'A';
        elseif ii>=7 && ii<12
            letter = 'B';
        elseif ii>=12
            letter = 'A';
        end
    elseif contains(mypath,'GOLD')
        if ii<7
            letter = 'B';
        elseif ii>=7 && ii<12
            letter = 'A';
        elseif ii>=12
            letter = 'B';
        end
    elseif contains(mypath,'C')
        letter = 'C';
    elseif contains(mypath,'D')
        letter = 'D';
%        disp('Need to fix this for C (Green) and D (MTXDRN)')
    end

    % load the data - can take a while
    %data=niftiread(scans{ii});
    data = niftiread(['bdswurs_mrg_' num2str(ii) letter '.nii']);

    fprintf('Loaded subject %d\n', ii);

    %% Get the dimensions of the data
    [dim1, dim2, dim3, timepoints] = size(data);

    % Reshape the data to 2D: voxels x timepoints
    nifti_reshaped = reshape(data, [], timepoints);

    % Load realignment parameters (motion parameters)
    % motion_params_file = motionFiles{ii};
    motion_params_file = ['rp_rs_mrg_' num2str(ii) letter '.txt'];
    motion_params = load(motion_params_file); % assuming it's a simple text file

    % Check the dimensions and make sure they match the number of timepoints
    [motion_timepoints, num_params_motion] = size(motion_params);
    assert(motion_timepoints == timepoints, 'Mismatch in number of timepoints');

    % Compute the global signal (mean time series across all voxels)
    global_signal = mean(nifti_reshaped, 1);

    % Plot the global signal
    figure('Position',[100 100 1200 1000])
    tiledlayout(3,3)
    nexttile([1 2])
    plot(global_signal,'LineWidth',2);
    title('Global Signal');
    xlabel('Timepoints');
    ylabel('Mean Signal Intensity');

    % Generate the carpet plot
    % Normalize the data for better visualization
    nifti_normalized = zscore(nifti_reshaped, 0, 2);

    % Improve the carpet plot appearance (optional)
    % Sort voxels by their mean signal intensity
    [~, sort_idx] = sort(mean(nifti_reshaped, 2), 'descend');
    nifti_sorted = nifti_normalized(sort_idx, :);


    %% Create the carpet plot
    %figure('Position',[100 100 800 400])
    nexttile(4, [1 2])
    imagesc(nifti_sorted);
    colormap('gray');
    colorbar;
    title('Carpet Plot Z-scores sorted by mean signal intensity');
    xlabel('Timepoints');
    ylabel('Voxels');
    clim([-10 10])

    %% Get average timeseries in each atlas ROI
    % Need rois, otherwise matlab struggles with doing every voxel

    % Initialize matrix to hold the average time series for each ROI
    roi_time_series = zeros(num_rois, timepoints);

    for jj = 1:num_rois
        roi_idx = roi_indices(jj);
        % Find voxels in the current ROI
        roi_voxels = nifti_reshaped(atlas_file == roi_idx, :);
        % Compute the average time series
        roi_time_series(jj, :) = mean(roi_voxels, 1);

        % Print the ROI label
        %fprintf('Extracting time series for ROI: %s\n', roi_labels{jj});
    end

    %% Compute Dynamic FC matrices

    % A sliding window approach to compute Functional Connectivity (FC)
    % matrices over time. Each FC matrix represents the connectivity
    % between ROIs within a specific time window.

    % Define the window length and step size
    window_length = 30; % Example: 30 time points per window
    step_size = 1; % Slide one time point at a time

    % Number of windows
    num_windows = floor((timepoints - window_length) / step_size) + 1;

    % Initialize dynamic FC matrices
    dynamic_FC = zeros(num_rois, num_rois, num_windows);

    % Compute dynamic FC matrices
    for win = 1:num_windows
        start_idx = (win-1)*step_size + 1;
        end_idx = start_idx + window_length - 1;

        window_data = roi_time_series(:, start_idx:end_idx);

        dynamic_FC(:, :, win) = corr(window_data');
    end


    %% QC-FC

    % QC-FC Association:
    % The chart visually represents how much the head movement
    % (as captured by the motion parameters) is associated with
    % changes in functional connectivity.

    % High absolute values of correlation (either positive or negative)
    % suggest that the motion parameter strongly influences the FC values.

    % This information is crucial for understanding the impact of motion
    % on your fMRI data quality. High motion-FC correlations might
    % indicate that your FC measures are confounded by head movement,
    % which is an artifact you want to minimize.

    % Initialize QC-FC correlation vector
    QC_FC = zeros(num_params_motion, 1);

    % Compute mean motion parameter for each window
    % For each time window, you computed the mean of the
    % motion parameters. These motion parameters
    % include translations and rotations that
    % represent the subject's head movement.
    window_motion_means = zeros(num_windows, num_params_motion);
    for kk = 1:num_params_motion
        for win = 1:num_windows
            start_idx = (win-1)*step_size + 1;
            end_idx = start_idx + window_length - 1;
            window_motion_means(win, kk) = mean(motion_params(start_idx:end_idx, kk));
        end
    end

    % Flatten dynamic FC matrices into 1D Vector
    FC_values_all_windows = reshape(dynamic_FC, num_rois * num_rois, num_windows)';

    % Compute QC-FC associations
    % Computed the correlation between the mean motion parameters
    % for each window and the mean of the corresponding flattened FC
    % matrices across all windows. This resulted in a
    % correlation value for each motion parameter.

    for kk = 1:num_params_motion
        QC_FC(kk) = corr(window_motion_means(:, kk), mean(FC_values_all_windows, 2));
    end

    % Plot QC-FC associations
    %figure;
    nexttile(3)
    bar(QC_FC);
    title('QC-FC Associations (Dynamic FC)');
    xlabel('QC Metric Index (Motion Parameters)');
    ylabel('Correlation with FC values');

    %% Other measures

    % Plot the distribution of FC values
    %figure;
    FC_values_all_windows_NZ = FC_values_all_windows(:);
    FC_values_all_windows_NZ = FC_values_all_windows_NZ(FC_values_all_windows_NZ~=1);
    nexttile(6)
    histogram(FC_values_all_windows_NZ(:), 'Normalization', 'probability','DisplayStyle','stairs','LineWidth',2);
    title('Distribution of FC Values');
    xlabel('FC Value');
    ylabel('Probability');

    % Compute DVARS
    % DVARS (D referring to temporal derivative and VARS referring
    % to root mean square variance over voxels) quantifies the rate
    % of change of BOLD signal across the entire brain
    DVARS = sqrt(mean(diff(nifti_reshaped, 1, 2).^2, 1));

    % Plot DVARS
    %figure;
    nexttile(7, [1 2])
    %figure
    plot(DVARS,'LineWidth',2);
    title('DVARS (Root Mean Square Variance over Voxels)');
    xlabel('Time Point');
    ylabel('DVARS');

    % Also plot static FC
    % Compute the ROI-based FC matrix
    FC_roi = corr(roi_time_series');
    %figure;
    ax = nexttile(9);
    imagesc(FC_roi)
    title('Static FC');
    xlabel('Atlas label');
    ylabel('Atlas label');
    colormap(ax,'viridis')
    colorbar(ax)


    %thisFileName = extractBefore(scans{ii},'.');
    thisFileName = ['bdswurs_mrg_' num2str(ii) letter];
    filename = [savedir 'QC_FC_plot_' thisFileName];
    %print(filename,'-dpng')

    close all


    % save for later
    roi_time_series_stack(:,:,ii) = roi_time_series;



end
toc


%% Now plot out the mean timeseries in atlas regions?


% Assume roi_time_series is a [num_regions x num_timepoints] matrix
num_regions = 48;
num_timepoints = 800;
num_bins = 20;
bin_size = num_timepoints / num_bins;  % 800 time points / 20 bins = 40 time points per bin

% Initialize the binned data matrix
binned_data = zeros(num_regions, num_bins,nSubs);


for ii = 1:nSubs

    thisTC = roi_time_series_stack(:,:,ii);
    % Bin the data
    for bin = 1:num_bins
        start_idx = (bin - 1) * bin_size + 1;
        end_idx = bin * bin_size;
        binned_data(:, bin,ii) = mean(thisTC(:, start_idx:end_idx), 2);
    end
end

%%

region_mean = mean(binned_data, 2);  
normalized_data = binned_data - region_mean;

mean_data = mean(normalized_data,3);
std_error = std(normalized_data, 0, 3) / sqrt(size(binned_data, 3));

num_regions = size(mean_data, 1);
num_timepoints = size(mean_data, 2);
% 
% fg = figure('Position',[100 100 1600 1024]);
% %hold on;
% %tiledlayout(6,8)
% tiledlayout(3,3)
% % Plot each region's mean timecourse with standard error bars
% % Look at insula, midFG, preCG, postCG, SMA, ACC, PCC
% for region = [2 4 7 17 26 29 30] %1:num_regions
%     nexttile
%     errorbar(1:num_timepoints, mean_data(region, :), std_error(region, :),'LineWidth',2);
%     title(sprintf('%s',roi_labels{region}))
%     ylim([-200 200])
% end
% fontsize(fg,12,"points")
% thisFileName = 'ROI_bins_bdswurs_mrg_session_RED';
% filename = [savedir thisFileName];
% print(filename,'-dpng')



%% Can we compare the first ten mins to the last ten mins?

% Extract the data for the first and last 10 minutes
first_10 = binned_data(:, 1:10, :);
last_10 = binned_data(:, 11:20, :);

% Calculate the mean across subjects for each region and time bin
mean_first_10 = mean(first_10, 3); % 48x10
mean_last_10 = mean(last_10, 3);   % 48x10

% Initialize arrays to store p-values and t-values
p_values = zeros(num_regions, 1);
t_values = zeros(num_regions, 1);

% Perform paired t-test for each region comparing the average of the first
% and last 10 minutes
for region = 1:num_regions
    [h, p, ci, stats] = ttest(mean_first_10(region, :), mean_last_10(region, :));
    p_values(region) = p;
    t_values(region) = stats.tstat;
end

% Display the p-values and t-values
disp('P-values for each region:');
disp(p_values);

disp('T-values for each region:');
disp(t_values);

% Optional: Apply multiple comparison correction (e.g., Bonferroni)
corrected_p_values = p_values * num_regions;
corrected_p_values(corrected_p_values > 1) = 1;

% Plotting the timecourses with significant regions highlighted
fg = figure('Position', [100, 100, 1600, 1024]);
tiledlayout(3, 3);

% Define the regions of interest
regions_of_interest = [2, 4, 7, 17, 26, 29, 30];

% Plot each region's mean timecourse with standard error bars
for region_idx = 1:length(regions_of_interest)
    region = regions_of_interest(region_idx);
    nexttile;
    errorbar(1:num_timepoints, mean_data(region, :), std_error(region, :), 'LineWidth', 2);
    if corrected_p_values(region) < 0.05
        title(sprintf('%s\np = %.3f (significant)', roi_labels{region}, p_values(region)), 'Color', 'r');
    else
        title(sprintf('%s\np = %.3f', roi_labels{region}, p_values(region)));
    end
    ylim([-200 200]);
end

fontsize(fg, 12, "points");

mypats = {'RED','GOLD','C','D'};
patName = logical([0 0 0 0]);
for ii = 1:length(mypats)
    patName(ii) = contains(mypath,mypats{ii});
end
thisPatName = mypats(patName);

if strcmpi(thisPatName,'C')
    thisPatName = 'GREEN';
elseif strcmpi(thisPatName,'D')
    thisPatName = 'MTXDRN';
end



thisFileName = ['ROI_bins_bdswurs_mrg_session_' char(thisPatName)];
filename = [savedir thisFileName];
print(filename, '-dpng');












