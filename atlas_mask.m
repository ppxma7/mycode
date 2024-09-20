% save out specific ROIs into mask
% from harvard oxford atlas

%% paths
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Zespri- fMRI - General/analysis/rs/'];
if strcmpi(userName,'spmic')
    whichSPM = 'MATLAB/spm';
else
    whichSPM = 'spm12';
end

%% load atlas
atlasfilename = ['/Users/' userName '/Documents/' whichSPM '/tpm/HarvardOxford-cort-maxprob-thr25-2mm.nii'];
atlas_file = niftiread(atlasfilename);

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

%% start masking
bloop = atlas_file(:);
[X,Y,Z] = size(atlas_file);

regions_of_interest = [2, 4, 7, 17, 26, 29, 30];

tem = bloop==regions_of_interest;
temfill = zeros(length(bloop),1);
for ii = 1:length(regions_of_interest)
    tem1 = tem(:,ii);
    roidex = find(tem1);
    tem1 = double(tem1);
    tem1(roidex) = regions_of_interest(ii);
    temfill(:,ii)=tem1;
end
Bfill = sum(temfill,2);
Bfill8 = uint8(Bfill);
Bfill8resh = reshape(Bfill8,X,Y,Z);


theHDR = niftiinfo(atlasfilename);

niftiwrite(Bfill8resh,[savedir '/harv_oxf_rs_roi_regions'],theHDR)






