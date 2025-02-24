% Load the image (assuming it's in a 3D matrix)
close all
clear all
clc
userName = char(java.lang.System.getProperty('user.name'));

here = ['/Users/' userName '/data/postDUST_MBSENSE_HEAD_200225/fRAT_analysis_isnr/sub-01/noise_volume/'];
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-TheUniversityofNottingham/stage/postDUST_Files/head/'];

%image = niftiread('postDUST_HEAD_200225_WIPMB2_SENSE1_20250220151249_10_noise_volume.nii.gz');
data = load_nifti('postDUST_HEAD_200225_WIPMB4_SENSE3_20250220151249_38_noise_volume.nii.gz');
image = data.vol;
%image = double(image);
%%
flat = image(:);
%image = randn(96, 96, 36); % Replace with your image data

% Calculate the standard deviation of the entire image
std_dev = std(image(:));
bins = 400;
% Plot the histogram of the image
figure('Position', [100 100 1000 400])

tiledlayout(1,2)
nexttile
histogram(image(:), bins); % 50 bins
title('Histogram of Image');
xlabel('Pixel Intensity');
ylabel('Frequency');

% Display a single slice of the image
slice_num = 18; % Choose which slice to display (between 1 and 36)
nexttile
imagesc(image(:, :, slice_num));
colormap gray;
colorbar;
title(['Slice ' num2str(slice_num) '  stdev: ' num2str(std_dev)]);
xlabel('X');
ylabel('Y');


ax = gcf;
exportgraphics(ax,fullfile(savedir,'noisestdev_mb4_s3_tile.png'))

% Show standard deviation in the command window
%disp(['Standard Deviation of the Image: ' num2str(std_dev)]);
