clear variables
close all
clc

%userName = char(java.lang.System.getProperty('user.name'));

%savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/blood_results/'];
%mypath = savedir;
%cd(mypath)
savedir = '/Users/spmic/data/san/gmv/';
mypath = savedir;

hemisphere = 'l';

myFile = [mypath 'freesurfer_stats_' hemisphere '_combined.csv'];

theTable = readtable(myFile);

%% GMV all regions
[p,tbl,stats] = anova1(theTable.GrayVol,theTable.Group);
[p2,tbl2,stats2] = anova1(theTable.ThickAvg,theTable.Group);

%
alphaval = 0.01;

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
anova_results_gmv = [];
for ii = 1:length(regions)

    region_name = regions{ii};
    disp(region_name)

    thisRegion = theTable.StructName(ii); % this region for this loop
    idxRegion = strcmpi(theTable.StructName,thisRegion); % get indices of each subject's region
    regionData = theTable(idxRegion,:); %index into table

    % now stats between groups for THIS region

    [p, tbl, stats] = anova1(regionData.GrayVol, regionData.Group, 'off');
    % Post-hoc comparisons (Tukey's HSD)
    [c, ~, ~, gnames] = multcompare(stats, "Dimension", 1, 'Display', 'off', ...
        'CriticalValueType', 'bonferroni', 'Alpha', alphaval);

    % Convert comparison results to table
    tbldom = array2table(c, "VariableNames", ...
        ["Group A", "Group B", "Lower Limit", "A-B", "Upper Limit", "P-value"]);
    tbldom.("Group A") = gnames(tbldom.("Group A"));
    tbldom.("Group B") = gnames(tbldom.("Group B"));

    % Store in summary table
    anova_results_gmv = [anova_results_gmv; {region_name, p}];

    % Save to spreadsheet
    writetable(tbldom, sprintf('%s/mult_gmv_%s_%s.xlsx', savedir, hemisphere, region_name));

end


toc



%% now org and plot

clear Mat
anVals = cell2mat(anova_results_gmv(:,2));
anValDex = anVals<alphaval;
sigRegions = regions(anValDex);

for ii = 1:length(sigRegions)
    region_name = sigRegions{ii};
    disp(region_name)

    thisRegion = sigRegions(ii); % this region for this loop
    idxRegion = strcmpi(theTable.StructName,thisRegion); % get indices of each subject's region
    regionData = theTable(idxRegion,:); %index into table

    Mat(:,ii) = regionData.GrayVol;

end

myGroup = regionData.Group;


%% %% plot
clear g
close all


for ii = 1:length(sigRegions)

    figure('Position', [100 100 600 400])
    g = gramm();
    region_name = sigRegions{ii};
    thisData = Mat(:,ii); % Extract GMV values for this region
    
    
    g = gramm('x', myGroup, 'y', thisData, 'color', myGroup);
    g.stat_summary('geom', {'bar', 'black_errorbar'},'type','std','width',1,'dodge',1); % Mean & Std
    %g(ii,1).stat_boxplot2(); % Boxplot for additional info
    g.set_names('x', 'Group', 'y', ['GMV - ' region_name]);
    g.set_title(region_name);

    g.set_text_options('Font', 'Helvetica', 'base_size', 12);
    g.set_order_options('x', 0, 'color', 0);
    g.draw();

    filename = sprintf(['plot_GMV_' sigRegions{ii}], '%s');
    g.export('file_name', filename, 'export_path', savedir, 'file_type', 'pdf');
    g.export('file_name', filename, 'export_path', savedir, 'file_type', 'eps');
end




%% T1?

myFile = [mypath 't1_stats_destrieux_combined_' hemisphere '.csv'];

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



