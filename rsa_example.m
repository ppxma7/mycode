% Clear workspace and set up paths
clear; clc; close all;
returnHere = pwd;
cd ..; addpath(genpath(pwd)); cd(returnHere);

% Define user options
userOptions = defineUserOptions();
outPath = '/Volumes/hermes/canapi_full_run_111024/rsa_test/';
userOptions.rootPath = outPath;
userOptions.projectName = 'Your_Project_Name';
userOptions.analysisName = 'RSA_Analysis';
userOptions.distance = 'euclidean';
% Define figure saving options in userOptions
userOptions.saveFiguresPDF = 1; % Save as PDF
userOptions.saveFiguresPNG = 1; % Save as PNG

% Load the Harvard-Oxford Cortical Atlas
atlasPath = '/Users/spmic/Documents/MATLAB/spm/tpm/rHarvardOxford-cort-maxprob-thr25-2mm.nii';
atlas = spm_read_vols(spm_vol(atlasPath));
atlas_vec = atlas(:);

% Define ROIs based on labels in the atlas
% Identify all unique ROI labels (ignoring background, assumed to be 0)

% roi_labels = unique(atlas);
% roi_labels(roi_labels == 0) = []; % Remove background label if it's 0
% nROIs = numel(roi_labels);


% Define only the ROIs of interest
roi_labels = [16]; % pre and post central g
nROIs = numel(roi_labels);

% Load beta maps for each condition/block
mypath = '/Volumes/hermes/canapi_full_run_111024/spm_analysis/firstlevel_rightleg/';
con1 = spm_read_vols(spm_vol([mypath 'con_0001.nii'])); % Block 1 - 1 bar
con2 = spm_read_vols(spm_vol([mypath 'con_0002.nii'])); % Block 2 - 30 prc
con3 = spm_read_vols(spm_vol([mypath 'con_0003.nii'])); % Block 3 - 50 prc

% clear nans
i = size(con1,1);
j = size(con1,2);
k = size(con1,3);

con1tmp = con1(:);
con2tmp = con2(:);
con3tmp = con3(:);

con1tmp(isnan(con1tmp))=0;
con2tmp(isnan(con2tmp))=0;
con3tmp(isnan(con3tmp))=0;

con1 = reshape(con1tmp,[i j k]);
con2 = reshape(con2tmp,[i j k]);
con3 = reshape(con3tmp,[i j k]);

% Continue for other blocks...

% Organize data into a structure for RSA
% Initialize structure for ROI-based activity patterns
data_struct = struct();

% Loop over each ROI label
for roi_idx = 1:nROIs
    roi_label = roi_labels(roi_idx);
    roi_mask = atlas == roi_label; % Binary mask for current ROI
    
    % Calculate mean activity within the ROI for each block
    data_struct(roi_idx).activity(1) = mean(con1(roi_mask)); % Block 1
    data_struct(roi_idx).activity(2) = mean(con2(roi_mask)); % Block 2
    data_struct(roi_idx).activity(3) = mean(con3(roi_mask)); % Block 3
    % Continue for each block
    data_struct(roi_idx).name = ['ROI ' num2str(roi_label)];
end



%% Compute RDMs for each ROI based on condition/block activity patterns
RDMs = struct();
for roi_idx = 1:nROIs
    % Get activity across blocks for the current ROI
    activity_pattern = data_struct(roi_idx).activity; % Vector of mean activity per block
    RDMs(roi_idx).RDM = rsa.rdm.squareRDMs(pdist(activity_pattern', userOptions.distance));
    RDMs(roi_idx).name = data_struct(roi_idx).name;
end

%% Visualize the Data RDMs for each ROI (Optional)
% Define condition labels
conditionLabels = {'1bar', '30%', '50%'};

for roi_idx = 1:nROIs
    rsa.fig.showRDMs(RDMs(roi_idx).RDM, roi_idx);
    %outputFileName = fullfile(userOptions.rootPath, ['RSA_RDM_ROI_', num2str(roi_labels(roi_idx))]);
    rsa.fig.handleCurrentFigure([userOptions.rootPath, filesep, 'Data_RDM_' data_struct(roi_idx).name], userOptions);
end


%%
% Assuming you already have RDMs(roi_idx).RDM for the specific ROI

% Define condition labels

% Plot the RDM using imagesc
figureHandle = figure;
imagesc(RDMs(roi_idx).RDM); % Display the RDM

% Customize color map and color bar
colormap(viridis); % Choose a color map; adjust as needed
colorbar; % Add a color bar

% Set axis labels and title
set(gca, 'XTick', 1:3, 'XTickLabel', conditionLabels, 'YTick', 1:3, 'YTickLabel', conditionLabels);
xlabel('Conditions');
ylabel('Conditions');
title(['RDM for ROI ', num2str(roi_labels(roi_idx))]);

% Adjust aspect ratio to make it square
axis square;
outputPath = fullfile(userOptions.rootPath, ['Rank_Scaled_RDM_ROI_', num2str(roi_labels(roi_idx))]);
exportgraphics(figureHandle, [outputPath, '.png'], 'Resolution', 300);


trueModel = RDMs.RDM;
%% stats
rsademopath='/Users/spmic/Documents/MATLAB/rsatoolbox_matlab/Demos/92imageData/';
load([rsademopath 'Kriegeskorte_Neuron2008_supplementalData.mat'])
rdm_mIT=rsa.rdm.squareRDMs(RDMs_mIT_hIT_fig1(1).RDM);
rdm_hIT=rsa.rdm.squareRDMs(RDMs_mIT_hIT_fig1(2).RDM);

load([rsademopath '92_brainRDMs.mat'])
RDMs_hIT_bySubject = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session');
rsa.fig.showRDMs(RDMs_hIT_bySubject,1);
rsa.fig.handleCurrentFigure([userOptions.rootPath,filesep,'subjectRDMs_hIT_fMRI'],userOptions);

% define categorical model RDMs
[binRDM_animacy, nCatCrossingsRDM]=rsa.rdm.categoricalRDM(categoryVectors(:,1),3,true);
ITemphasizedCategories=[1 2 5 6]; % animate, inanimate, face, body
[binRDM_cats, nCatCrossingsRDM]=rsa.rdm.categoricalRDM(categoryVectors(:,ITemphasizedCategories),4,true);
load([rsademopath 'faceAnimateInaniClustersRDM.mat'])

% load behavioural RDM from Mur et al. (Frontiers Perc Sci 2013)
load([rsademopath '92_behavRDMs.mat'])
rdm_simJudg=mean(rsa.rdm.stripNsquareRDMs(rdms_behav_92),3);

% load RDMs for V1 model and HMAX model with natural image patches from Serre et al. (Computer Vision and Pattern Recognition 2005)
load([rsademopath 'rdm92_V1model.mat'])
load([rsademopath 'rdm92_HMAXnatImPatch.mat'])

% load RADON and silhouette models and human early visual RDM
load([rsademopath '92_modelRDMs.mat']);
FourCatsRDM=Models(2).RDM;
humanEarlyVisualRDM=Models(4).RDM;
silhouetteRDM=Models(7).RDM;
radonRDM=Models(8).RDM;

% concatenate and name the modelRDMs

% let's just take the top 3 ones to match (not very clever but hey ho)
modelRDMs=cat(3,binRDM_animacy(1:3,1:3),faceAnimateInaniClustersRDM(1:3,1:3),FourCatsRDM(1:3,1:3),...
    rdm_simJudg(1:3,1:3),humanEarlyVisualRDM(1:3,1:3),rdm_mIT(1:3,1:3),silhouetteRDM(1:3,1:3),...
    rdm92_V1model(1:3,1:3),rdm92_HMAXnatImPatch(1:3,1:3),radonRDM(1:3,1:3),trueModel);

modelRDMs=rsa.rdm.wrapAndNameRDMs(modelRDMs,{'ani./inani.','face/ani./inani.','face/body/nat./artif.','sim. judg.','human early visual','monkey IT','silhouette','V1 model','HMAX-2005 model','RADON','true model'});
%modelRDMs=modelRDMs(1:end-2); % leave out the true with noise models

rsa.fig.showRDMs(modelRDMs,5);
rsa.fig.handleCurrentFigure([userOptions.rootPath,filesep,'allModels'],userOptions);
% place the model RDMs in cells in order to pass them to
% compareRefRDM2candRDMs as candidate RDMs
for modelRDMI=1:numel(modelRDMs)
    modelRDMs_cell{modelRDMI}=modelRDMs(modelRDMI);
end

% make struct
trueModelStr.name = 'true model';
trueModelStr.color = [ 0 0 0];
trueModelStr.RDM = trueModel;


%% RDM correlation matrix and MDS
% 2nd order correlation matrix
userOptions.RDMcorrelationType='Kendall';

rsa.pairwiseCorrelateRDMs({trueModelStr, modelRDMs}, userOptions, struct('figureNumber', 12,'fileName','RDMcorrelationMatrix'));

% % 2nd order MDS
% rsa.MDSRDMs({trueModelStr, modelRDMs}, userOptions, struct('titleString', 'MDS of different RDMs', 'figureNumber', 13,'fileName','2ndOrderMDSplot'));

%% statistical inference
userOptions.RDMcorrelationType='Kendall_taua';
userOptions.RDMrelatednessTest = 'subjectRFXsignedRank';
userOptions.RDMrelatednessThreshold = 0.05;
userOptions.RDMrelatednessMultipleTesting = 'FDR';
userOptions.saveFiguresPDF = 1;
userOptions.candRDMdifferencesTest = 'subjectRFXsignedRank';
userOptions.candRDMdifferencesThreshold = 0.05;
userOptions.candRDMdifferencesMultipleTesting = 'none';
userOptions.plotpValues = '=';
userOptions.barsOrderedByRDMCorr=true;
userOptions.resultsPath = userOptions.rootPath;
userOptions.figureIndex = [14 15];
userOptions.figure1filename = 'compareRefRDM2candRDMs_barGraph_simulatedITasRef';
userOptions.figure2filename = 'compareRefRDM2candRDMs_pValues_simulatedITasRef';
userOptions.nRandomisations = 6;

stats_p_r=rsa.compareRefRDM2candRDMs(trueModelStr, modelRDMs_cell, userOptions);











