clear all
close all
clc

parentDir = '/Volumes/nemosine/NEXPO/outputs';

% Get all entries in the directory
dirInfo = dir(parentDir);

% Filter out only directories (excluding '.' and '..')
folderNames = {dirInfo([dirInfo.isdir]).name};
folderNames = folderNames(~ismember(folderNames, {'.', '..'}));

for ii = 1:length(folderNames)
    folderPath = fullfile(parentDir, folderNames{ii},'T1mapping'); % Full path to the folder
    %disp(folderPath)
    fprintf('Processing folder: %s\n', folderPath);

    thisFile = dir(fullfile(folderPath,'*01.nii'));
    thisFileName = thisFile.name;

    checkMagPhase_noprompt(folderPath, thisFileName)





end