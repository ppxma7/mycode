% Load the image (assuming it's in a 3D matrix)
close all
clear all
clc
userName = char(java.lang.System.getProperty('user.name'));

savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-TheUniversityofNottingham/stage/postDUST_Files/head/'];

% preDUST
pre_rootDir = '/Volumes/DRS-7TfMRI/preDUST/preDUST_HEAD_MBSENSE/';
pre_noise_dir = 'magnitude/raw_clv/fRAT_analysis_withnoisescan/sub-01/noise_volume/';
pre_sig_dir = 'magnitude/raw_clv/fRAT_analysis_withnoisescan/sub-01/func_volumes/';
filenameA = 'preDUST_HEAD_MBSENSE_2DEPI_MB2_SENSE1_36slc_2p5mm_20250120071225_13.nii.gz';
filenameB = 'preDUST_HEAD_MBSENSE_2DEPI_MB2_SENSE1_36slc_2p5mm_20250120071225_13_noise_volume.nii.gz';
pre_sig_data = load_nifti(fullfile(pre_rootDir,pre_sig_dir,filenameA));
pre_noise_data = load_nifti(fullfile(pre_rootDir,pre_noise_dir,filenameB));
pre_sig_vol = pre_sig_data.vol;
pre_noise_vol = pre_noise_data.vol;

% postDUST
post_rootDir = '/Volumes/DRS-7TfMRI/postDUST/postDUST_MBSENSE_HEAD_200225/';
post_noise_dir = 'fRAT_analysis_isnr/sub-01/noise_volume/';
post_sig_dir = 'fRAT_analysis_isnr/sub-01/func_volumes/';
filenameC = 'postDUST_HEAD_200225_WIPMB2_SENSE1_20250220151249_10.nii.gz';
filenameD = 'postDUST_HEAD_200225_WIPMB2_SENSE1_20250220151249_10_noise_volume.nii.gz';
post_sig_data = load_nifti(fullfile(post_rootDir,post_sig_dir,filenameC));
post_noise_data = load_nifti(fullfile(post_rootDir,post_noise_dir,filenameD));
post_sig_vol = post_sig_data.vol;
post_noise_vol = post_noise_data.vol;

%%
% Example file names
filenames = string({filenameA, filenameB, filenameC, filenameD})';

% Data (using cell arrays to store actual NIfTI data)
data = {pre_sig_vol; pre_noise_vol; post_sig_vol; post_noise_vol};

% Example group labels
groups = {'preDUST'; 'preDUST'; 'postDUST'; 'postDUST'};
% Create table
T = table(filenames, data, groups, ...
    'VariableNames', {'Filename', 'Data', 'Group'});

%% Compute standard deviation for each entry in the Data column
std_dev = cellfun(@(x) std(x(:)), T.Data);

% Add the new column to the table
T.StdDev = std_dev;

% Display updated table
disp(T)

%% diff
d = T.Data{1};
iSlice = round(size(d,4)/2);
d_diff = d(:,:,:,iSlice+1) - d(:,:,:,iSlice);
T.diff_dyn{1} = d_diff;

d = T.Data{3};
iSlice = round(size(d,4)/2);
d_diff = d(:,:,:,iSlice+1) - d(:,:,:,iSlice);

T.diff_dyn{3} = d_diff;

%% PRE
sliceNum = 18;
bins = 100;

figure('Position', [100 100 1000 600])
tiledlayout(2,3)

nexttile(1)
histogram(T.Data{1}(:), bins); % 50 bins
title('Histogram of Signal');
xlabel('Pixel Intensity');
ylabel('Frequency');

nexttile(2)
mSig = mean(T.Data{1},4);
imagesc(mSig(:,:,sliceNum))
colormap(gray)
title(['Mean signal slice: ' num2str(sliceNum) ])
colorbar

nexttile(3)
imagesc(T.diff_dyn{1}(:,:,sliceNum))
colormap(gray)
title(['Diff dynamics vol: ' num2str(iSlice+1) '-' num2str(iSlice) ])
colorbar

nexttile(4)
histogram(T.Data{2}(:), bins); % 50 bins
title('Histogram of Signal');
xlabel('Pixel Intensity');
ylabel('Frequency');

nexttile(5)
imagesc(T.Data{2}(:,:,sliceNum))
colormap(gray)
title(['Noise slice: ' num2str(sliceNum) ' std: ' num2str(T.StdDev(2))]);
colorbar
clim([0 3000])

ax = gcf;
exportgraphics(ax,fullfile(savedir,'predust_mb2_s1.png'))

%% montage
figure;
montage(T.Data{2}, 'DisplayRange', []); % Auto scale
colormap gray;
colorbar
title('Noise scan');
clim([0 3000])
ax = gcf;
exportgraphics(ax,fullfile(savedir,'predust_mb2_s1_montage.png'))

%% POST

sliceNum = 18;
bins = 100;

figure('Position', [100 100 1000 600])
tiledlayout(2,3)

nexttile(1)
histogram(T.Data{3}(:), bins); % 50 bins
title('Histogram of Signal');
xlabel('Pixel Intensity');
ylabel('Frequency');

nexttile(2)
mSig = mean(T.Data{3},4);
imagesc(mSig(:,:,sliceNum))
colormap(gray)
title(['Mean signal slice: ' num2str(sliceNum) ])
colorbar

nexttile(3)
imagesc(T.diff_dyn{3}(:,:,sliceNum))
colormap(gray)
title(['Diff dynamics vol: ' num2str(iSlice+1) '-' num2str(iSlice) ])
colorbar

nexttile(4)
histogram(T.Data{4}(:), bins); % 50 bins
title('Histogram of Signal');
xlabel('Pixel Intensity');
ylabel('Frequency');
colorbar

nexttile(5)
imagesc(T.Data{4}(:,:,sliceNum))
colormap(gray)
title(['Noise slice: ' num2str(sliceNum) ' std: ' num2str(T.StdDev(4))]);
colorbar
clim([0 1000])

ax = gcf;
exportgraphics(ax,fullfile(savedir,'postdust_mb2_s1.png'))

%% montage
figure;
montage(T.Data{4}, 'DisplayRange', []); % Auto scale
colormap gray;
colorbar
title('Noise scan');
clim([0 1000])
ax = gcf;
exportgraphics(ax,fullfile(savedir,'postdust_mb2_s1_montage.png'))

