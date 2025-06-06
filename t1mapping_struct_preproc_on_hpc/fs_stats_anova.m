clear variables
close all
clc

%userName = char(java.lang.System.getProperty('user.name'));

%savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/blood_results/'];
%mypath = savedir;
%cd(mypath)
savedir = '/Users/spmic/data/san/';

hemisphere = 'r';

myFile = [savedir 'freesurfer_stats_' hemisphere '_combined.csv'];

theTable = readtable(myFile);

whichCol = 'cth';
plotdir = fullfile('/Users/spmic/data/san/plotdir/',whichCol);


alphaval = 0.01;


%% GMV all regions
[p,tbl,stats] = anova1(theTable.GrayVol,theTable.Group);
[p2,tbl2,stats2] = anova1(theTable.ThickAvg,theTable.Group);

%

figure
[c,m,h,gnames] = multcompare(stats,"Dimension",1,'Display','on','CriticalValueType','bonferroni','Alpha',alphaval);
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('GMV')

writecell(tbl,sprintf([savedir 'anova_gmv_' hemisphere ],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_d1_gmv_' hemisphere ],'%s'),'FileType','spreadsheet')

figure
[c2,m2,h2,gnames2] = multcompare(stats2,"Dimension",1,'Display','on','CriticalValueType','bonferroni','Alpha',alphaval);
tbldom2 = array2table(c2,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom2.("Group A")=gnames(tbldom2.("Group A"));
tbldom2.("Group B")=gnames(tbldom2.("Group B"));
title('Cth')

writecell(tbl2,sprintf([savedir 'anova_cth_' hemisphere ],'%s'),'FileType','spreadsheet')
writetable(tbldom2,sprintf([savedir 'mult_d1_cth_' hemisphere ],'%s'),'FileType','spreadsheet')

%% what about all regions individually
tic
disp('running all regions....')
alphaval = 0.01;
regions = unique(theTable.StructName);
anova_results = [];
tbldom_big = table();
for ii = 1:length(regions)

    region_name = regions{ii};
    disp(region_name)

    %thisRegion = theTable.StructName(ii); % this region for this loop
    %idxRegion = strcmpi(theTable.StructName,thisRegion); % get indices of each subject's region

    idxRegion = strcmpi(theTable.StructName, region_name);

    regionData = theTable(idxRegion,:); %index into table

    % now stats between groups for THIS region
    
    if strcmpi(whichCol,'gmv')
        [p, tbl, stats] = anova1(regionData.GrayVol, regionData.Group, 'off');
    elseif strcmpi(whichCol,'cth')
        [p, tbl, stats] = anova1(regionData.ThickAvg, regionData.Group, 'off');
    elseif strcmpi(whichCol,'t1')
        [p, tbl, stats] = anova1(regionData.Mean, regionData.Group, 'off');
    end

    
    % Post-hoc comparisons (Tukey's HSD)
    [c, ~, ~, gnames] = multcompare(stats, "Dimension", 1, 'Display', 'off', ...
        'CriticalValueType', 'bonferroni', 'Alpha', alphaval);

    % Convert comparison results to table
    tbldom = array2table(c, "VariableNames", ...
        ["Group A", "Group B", "Lower Limit", "A-B", "Upper Limit", "P-value"]);
    tbldom.("Group A") = gnames(tbldom.("Group A"));
    tbldom.("Group B") = gnames(tbldom.("Group B"));

    % Store in summary table
    anova_results = [anova_results; {region_name, p}];


    % Save to spreadsheet
    if any(tbldom.("P-value")<alphaval)
        writetable(tbldom, sprintf('%s/mult_%s_%s_%s.xlsx', plotdir, hemisphere, region_name, whichCol));
        
        rowDex = find(tbldom.("P-value")<alphaval);
        temptbldom = tbldom(rowDex,:); % just get sig mult compare rows
        temptbldom.Region = repmat({region_name}, height(temptbldom), 1);
        tbldom_big = [tbldom_big; temptbldom];
    end

end

writetable(tbldom_big, sprintf('%s/mult_%s_%s_tbldombig.xlsx', plotdir, hemisphere, whichCol));


toc


%% now org and plot

% clear Mat
% anVals = cell2mat(anova_results(:,2));
% anValDex = anVals<alphaval;
% sigRegions = regions(anValDex);
% 
% for ii = 1:length(sigRegions)
%     region_name = sigRegions{ii};
%     disp(region_name)
% 
%     thisRegion = sigRegions(ii); % this region for this loop
%     idxRegion = strcmpi(theTable.StructName,thisRegion); % get indices of each subject's region
%     regionData = theTable(idxRegion,:); %index into table
% 
%     if strcmpi(whichCol,'gmv')
%         Mat(:,ii) = regionData.GrayVol;
%     elseif strcmpi(whichCol,'cth')
%         Mat(:,ii) = regionData.ThickAvg;
%     elseif strcmpi(whichCol,'t1')
%         Mat(:,ii) = regionData.Mean;
%     end
% 
% end
% 
% myGroup = regionData.Group;
% 
% 
% % Extract significant comparisons
% sigComparisons = tbldom_big(tbldom_big.("P-value") < alphaval, :);
% %sigComparisons.("Group A") = categorical(sigComparisons.("Group A"));
% %sigComparisons.("Group B") = categorical(sigComparisons.("Group B"));
% 
% % Flatten for gramm facet grid
% region_labels = repelem(sigRegions, size(Mat, 1)); % Repeat region names for subjects
% subjectData = repmat(myGroup, length(sigRegions), 1); % Repeat group labels
% flattenedData = Mat(:); % Flatten data for plotting


%% Try again
anVals = cell2mat(anova_results(:,2));
anValDex = anVals<alphaval;
sigRegions = regions(anValDex);

Mat = []; % clear and preallocate
allGroups = {}; % to store group labels for all regions
allRegionLabels = {}; % to store region names

for ii = 1:length(sigRegions)
    region_name = sigRegions{ii};
    disp(region_name)

    idxRegion = strcmpi(theTable.StructName, region_name);
    regionData = theTable(idxRegion,:);

    if strcmpi(whichCol,'gmv')
        regionVals = regionData.GrayVol;
    elseif strcmpi(whichCol,'cth')
        regionVals = regionData.ThickAvg;
    elseif strcmpi(whichCol,'t1')
        regionVals = regionData.Mean;
    end

    % Store the data
    Mat = [Mat; regionVals]; % vertically concatenate values
    allGroups = [allGroups; regionData.Group]; % concatenate group labels
    allRegionLabels = [allRegionLabels; repmat(sigRegions(ii), height(regionData), 1)]; % repeat region name
end

% Now flattenedData, subjectData, and region_labels are all properly aligned
flattenedData = Mat;
subjectData = allGroups;
region_labels = allRegionLabels;

%%
clear g
close all

% Define subplot layout (adjust rows and cols based on number of regions)
if strcmpi(whichCol,'t1')
    numCols = 6;
    myHorz = 1200;
    myVertz = 800;
else
    numCols = 13;
    myHorz = 2000;
    myVertz = 800;
end
%subjectData = categorical(subjectData);
%uniqueGroups = unique(subjectData);

% Initialize gramm object with facetting
%figure('Position', [100 100 1400 800]); % Adjust figure size
figure('Position', [100 100 myHorz myVertz]); % Adjust figure size
g = gramm('x', subjectData, 'y', flattenedData, 'color', subjectData);
g.facet_wrap(region_labels, 'ncols', numCols,'scale','independent','column_labels',1); % Arrange in grid layout
g.stat_summary('geom', {'bar', 'black_errorbar'},'type','std','width',1,'dodge',1); % Mean & Std
% Plot as violin + boxplot
%g.stat_violin('fill', 'transparent', 'width', 0.6);
%g.stat_boxplot('width', 0.2);


% Aesthetics
g.set_names('x', 'Group', 'y', whichCol,'column',[]);
%g.set_title('Significant GMV Regions');
%g.set_color_options('map', [0 0 0; 0 0.5 1; 1 0 0]); % Adjust color scheme
g.set_text_options('Font', 'Helvetica', 'base_size', 6, 'facet_scaling', 1);
g.set_order_options('x', 0, 'color', 0);
g.no_legend()

if strcmpi(whichCol,'cth')
    g.axe_property('YLim', [1 4]); % Allow individual Y-limits per region
end
%g.set_text_options('facet', false); % Removes facet (subplot) titles

% Draw all tiles in one figure
g.draw();


% Save figure
filename = [whichCol '_sig_Regions_' hemisphere];
g.export('file_name', filename, 'export_path', plotdir, 'file_type', 'pdf');
g.export('file_name', filename, 'export_path', plotdir, 'file_type', 'eps');



%% T1?


close all
clear all
clc

savedir = '/Users/spmic/data/san/';

hemisphere = 'R';
whichCol = 't1';
myFile = [savedir 't1_stats_destrieux_combined_' hemisphere '.csv'];
plotdir = fullfile('/Users/spmic/data/san/plotdir/',whichCol);

theTable = readtable(myFile);

[p,tbl,stats] = anova1(theTable.Mean,theTable.Group);

figure
[c,m,h,gnames] = multcompare(stats,"Dimension",1,'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('T1')

writecell(tbl,sprintf([savedir 'anova_t1_' hemisphere ],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_d1_t1_' hemisphere ],'%s'),'FileType','spreadsheet')

theTable.Properties.VariableNames{1} = 'StructName';

%%




