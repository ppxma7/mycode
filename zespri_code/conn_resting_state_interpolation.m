
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Zespri- fMRI - General/analysis/rs/'];

mypath='/Volumes/nemosine/zespri_rs_smoothed_denoised_A/';
cd(mypath)

dataFile = {'bdswurs_mrg_4A.nii'};
tic
data = niftiread([mypath dataFile{:}]);
disp('loaded data')
toc
%% Try interpolation
[dim1, dim2, dim3, timepoints] = size(data);

% Reshape the data to 2D: voxels x timepoints
nifti_reshaped = reshape(data, [], timepoints);

% Define the time point with the spike
spike_timepoint = 400;

% Define the number of time points to include on either side of the spike
neighborhood_size = 8;

% Remove spike and neighboring time points
data_corrected = nifti_reshaped;
data_corrected(:, spike_timepoint - neighborhood_size : spike_timepoint + neighborhood_size) = NaN;

% Get the values before and after the spike region for interpolation
tp_before = data_corrected(:, spike_timepoint - neighborhood_size - 1);
tp_after = data_corrected(:, spike_timepoint + neighborhood_size + 1);

% Create indices for the middle window
middle_window_indices = spike_timepoint - neighborhood_size : spike_timepoint + neighborhood_size;
tic
% Interpolate missing values in the middle window for each voxel
interpolated_data = data_corrected;
for idx = 1:size(data_corrected, 1)
    % Perform linear interpolation
    interpolated_data(idx, middle_window_indices) = interp1([spike_timepoint - neighborhood_size - 1, spike_timepoint + neighborhood_size + 1], [tp_before(idx), tp_after(idx)], middle_window_indices, 'linear');
end
toc
disp('interpolation complete')

%% 

DVARS = sqrt(mean(diff(nifti_reshaped, 1, 2).^2, 1));
DVARS_corrected = sqrt(mean(diff(interpolated_data, 1, 2).^2, 1));

global_signal = mean(interpolated_data, 1);

nifti_normalized = zscore(interpolated_data, 0, 2);

% Improve the carpet plot appearance (optional)
% Sort voxels by their mean signal intensity
[~, sort_idx] = sort(mean(interpolated_data, 2), 'descend');
nifti_sorted = nifti_normalized(sort_idx, :);

%%
figure('Position',[100 100 1200 1000])
tiledlayout(2,3)
nexttile
plot(DVARS,'LineWidth',2);
title('DVARS (Root Mean Square Variance over Voxels)');
xlabel('Time Point');
ylabel('DVARS');

nexttile
plot(DVARS_corrected,'LineWidth',2);
title('DVARS (Root Mean Square Variance over Voxels)');
xlabel('Time Point');
ylabel('DVARS');

nexttile
imagesc(nifti_sorted);
colormap('gray');
colorbar;
title('Carpet Plot Z-scores sorted by mean signal intensity');
xlabel('Timepoints');
ylabel('Voxels');
clim([-10 10])

%
nexttile([1 3])
plot(global_signal,'LineWidth',2);
title('Global Signal');
xlabel('Timepoints');
ylabel('Mean Signal Intensity');

fontsize(12,"points")

filename = [savedir 'interp_plot_' extractBefore(dataFile{:},'.')];
print(filename,'-dpng')





