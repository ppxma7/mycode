function [] = plotGlobalSignal(original_data_path, repaired_data_path, names, savedir)
%plotGlobalSignal 
%
% Compare GS before and after Art Repair
%
% ma 2024

% load
original_data = niftiread(original_data_path);
repaired_data = niftiread(repaired_data_path);

% Number of volumes in the time series
n_volumes_original = size(original_data, 4);
n_volumes_repaired = size(repaired_data, 4);

% Initialize arrays to store global signal
global_signal_original = zeros(n_volumes_original, 1);
global_signal_repaired = zeros(n_volumes_repaired, 1);

% Calculate global signal for the original file
for t = 1:n_volumes_original
    % Get the 3D volume at time t
    volume_original = original_data(:,:,:,t);
    
    % Calculate the global signal by averaging non-zero voxels
    global_signal_original(t) = mean(volume_original(volume_original > 0));
end

% Calculate global signal for the repaired file
for t = 1:n_volumes_repaired
    % Get the 3D volume at time t
    volume_repaired = repaired_data(:,:,:,t);
    
    % Calculate the global signal by averaging non-zero voxels
    global_signal_repaired(t) = mean(volume_repaired(volume_repaired > 0));
end

%% Plot the global signals
figure('Position',[100 100 1200 400])
plot(global_signal_original, 'b', 'LineWidth', 2); hold on;
plot(global_signal_repaired, 'r--', 'LineWidth', 2);
%title('Global Signal Before and After ArtRepair');
title(sprintf('Global Signal Before and After ArtRepair %s', names{1}));
xlabel('Volumes');
ylabel('Mean Signal Intensity');
legend('Original', 'Repaired');
grid on;
hold off;
print([savedir 'subject_GS_' names{1} '.png'], '-dpng', '-r300');


end