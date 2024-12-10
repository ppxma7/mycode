%% exportROIs
%
% Background:
% This is a script to export multiple ROIs from a mrLoadRet view, which you
% must have open
% This calls the function mlrExportROI_group(), which is a slight
% modification of mlrExportROI(), an mrTools function, which skips using
% the current ROI selected.
%
% Michael Asghar November 2023

% get the currently open view
v = viewGet([],'view',1);
myROIs = {'LD1.nii','LD2.nii','LD3.nii','LD4.nii','LD5.nii',...
    'RD1.nii','RD2.nii','RD3.nii','RD4.nii','RD5.nii'};

% myROIs = { 'RD1b.nii','RD2b.nii','RD3b.nii','RD4b.nii','RD5b.nii',...
%     'LD1b.nii','LD2b.nii','LD3b.nii','LD4b.nii','LD5b.nii',...
%     };

% order is important - magic numbered here based on your ROIs
%roiNums = 3:12;
roiNums = 1:10;
for ii = 1:length(myROIs)
    mlrExportROI_group(v,myROIs{ii},'roiNum',roiNums(ii));
end