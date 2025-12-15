% Load in csv files
clc
close all
clear variables
%csvdir = "/Volumes/kratos/dti_data/tbss_analysis_justnexpo/roi_output_tstat10/";
csvdir = "/Volumes/kratos/dti_data/tbss_analysis_justnexpo/MD_rois/roi_output_tstat9/";
%csvdir = "/Volumes/nemosine/SAN/t1mnispace/nocsfver_justnexpo/atlasextract12/";

files = dir(csvdir);
files = files(~ismember({files.name}, {'.', '..'}));
fileTable = struct2table(files);
fileNames = fileTable.name;
csvFileNames = fileNames(contains(fileNames,'.csv'));
allData = table(); 

%% now csv files are a table
tic
for ii = 1:length(csvFileNames)
    thisCSV = readtable(fullfile(csvdir,csvFileNames{ii}));

    % Ensure Subject is a cell array of strings
    if isnumeric(thisCSV.Subject)
        thisCSV.Subject = cellstr(num2str(thisCSV.Subject));
    elseif isstring(thisCSV.Subject)
        thisCSV.Subject = cellstr(thisCSV.Subject);
    end

    disp(csvdir)
    disp(["reading file " csvFileNames{ii}])
    allData = vertcat(allData, thisCSV);
end
toc

%% Extract group from first 5 digits of Subject
% NEXPO
%allData.Group = extractBefore(allData.Subject, 6);  % first 5 digits for
% CHAIN
allData.Group = extractBefore(allData.Subject, 8);

% For t1mapping NEXPO just get numbers
% tmp = [repmat({'Group1'},46,1); repmat({'Group2'},45,1); repmat({'Group3'},45,1); repmat({'Group4'},44,1)];
% harvatlasregs = 40;
% groupAssoc = repmat(tmp,harvatlasregs,1);
% allData.Group = groupAssoc;


% Truncate to max 30 characters
truncROI_Label = arrayfun(@(s) extractBefore(s, min(strlength(s)+1, 31)), allData.ROI_Label);
%%

close all
clear g
figure('Position',[100 100 1600 768])
g = gramm('x', truncROI_Label, 'y', allData.Mean, 'color', allData.Group);
g.stat_boxplot2('drawoutlier',1);
g.set_names('x','ROI','y','Mean MD','color','Group');
%g.set_names('x','ROI','y','Mean T1','color','Group');
%g.set_point_options('base_size',1)
%g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.axe_property('XTickLabelRotation',45,'YGrid','on','XGrid','on');


g.draw();
g.export('file_name', ...
    fullfile(csvdir,'roi_boxplots_by_group'), ...
    'file_type','pdf');
