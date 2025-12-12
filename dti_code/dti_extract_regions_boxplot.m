% Load in csv files
clc
close all
clear variables
csvdir = "/Volumes/kratos/dti_data/tbss_analysis_justnexpo/roi_output_tstat10/";

files = dir(csvdir);
fileTable = struct2table(files);
fileNames = fileTable.name;
csvFileNames = fileNames(contains(fileNames,'.csv'));
allData = table(); 

%% now csv files are a table
tic
for ii = 1:length(csvFileNames)
    thisCSV = readtable(fullfile(csvdir,csvFileNames{ii}));
    disp(csvdir)
    disp(["reading file " csvFileNames{ii}])
    allData = vertcat(allData, thisCSV);
end
toc

%% Extract group from first 5 digits of Subject
% allData.Group = extractBefore(allData.Subject, 6);  % first 5 digits for
% CHAIN
allData.Group = extractBefore(allData.Subject, 8);

% Truncate to max 30 characters
truncROI_Label = arrayfun(@(s) extractBefore(s, min(strlength(s)+1, 31)), allData.ROI_Label);


close all
clear g
figure('Position',[100 100 1600 768])
g = gramm('x', truncROI_Label, 'y', allData.Mean, 'color', allData.Group);
g.stat_boxplot();
g.set_names('x','ROI','y','Mean FA','color','Group');
g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.draw();
g.export('file_name', ...
    fullfile(csvdir,'roi_boxplots_by_group'), ...
    'file_type','pdf');
