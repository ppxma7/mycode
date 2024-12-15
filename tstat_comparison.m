clear variables
close all
clc
tic

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle Injury) - General/data/canapi_051224/mni_aroma_redo/'];

thisCSV = "combined_withregions_custom.xlsx";

thisCSV_table = readtable(fullfile(savedir,thisCSV));

csvRegions = thisCSV_table.Region;
csvSubfolder = thisCSV_table.Subfolder;
csvT = thisCSV_table.peak_T;
csvLabel = thisCSV_table.Label;
%%
a = strrep(csvSubfolder,'aroma_mni_space','AROMA');
b = strrep(a,'no_aroma','NO AROMA');

%%
b = csvSubfolder;

adex = contains(thisCSV_table.Label,'50v1_fwe');
bdex = contains(thisCSV_table.Label,'50prc_fwe');
cdex = adex+bdex;
cdex = logical(cdex);

b(cdex) = [];
csvT(cdex) = [];
csvLabel(cdex) = [];
%%
close all
clear g
thisFont='Helvetica';
myfontsize=14;
figure('Position',[100 100 1000 600])
%figure
%figure
g = gramm('x',b,'y',csvT,'color',csvLabel);
g.stat_boxplot2('alpha', 1,'linewidth', 1, 'drawoutlier',0)
%g.stat_boxplot()
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Analysis', 'y', 'Peak T values')
g.set_order_options('x',0,'color',0)
g.axe_property('XGrid','on','YGrid','on')
g.draw()
g.update('y',csvT,'color',csvLabel) %,'color',subGrp)
%g.geom_jitter2('dodge',0.8,'alpha',1,'edgecolor',[0 0 0])

g.geom_jitter('dodge',0.8,'alpha',1)
g.set_point_options('base_size',5)
g.no_legend
g.set_order_options('x',0,'color',0)
g.draw()

filename = 'tstat_comp';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%%

[P, ANOVATAB, STATS] = anova1(csvT,b);

[COMPARISON,MEANS,H,GNAMES] = multcompare(STATS);
tbldom = array2table(COMPARISON,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedir 'mult_anova_tstat'],'FileType','spreadsheet')


