clear all
close all
clc

parentDir = '/Volumes/nemosine/SAN/AFIRM/afirm_new_ins/';

% Get all entries in the directory
dirInfo = dir(parentDir);

disp(dirInfo)

% Filter out only directories (excluding '.' and '..')
folderNames = {dirInfo([dirInfo.isdir]).name};
folderNames = folderNames(~ismember(folderNames, {'.', '..'}));

for ii = 1:length(folderNames)
    folderPath = fullfile(parentDir, folderNames{ii},'T1mapping'); % Full path to the folder
    %disp(folderPath)
    fprintf('Processing folder: %s\n', folderPath);

    

    thisFile = dir(fullfile(folderPath,'*01.nii'));

   
        

    %thisFileName = thisFile.name;
    
    if ~isDirEmpty(folderPath)
        if any(contains({thisFile.name}, 'fixed'))
            disp('already processed this folder')
        else
            thisFileName = thisFile.name;
            checkMagPhase_noprompt(folderPath, thisFileName)
        end
    elseif isDirEmpty(folderPath)
        disp('skipping this folder as T1 mapping is empty')
    end

    clc





end