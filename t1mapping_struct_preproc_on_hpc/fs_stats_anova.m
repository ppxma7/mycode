clear variables
close all
clc

%userName = char(java.lang.System.getProperty('user.name'));

%savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/blood_results/'];
%mypath = savedir;
%cd(mypath)
savedir = '/Users/spmic/data/san/';
mypath = savedir;

hemisphere = 'l';

myFile = [mypath 'freesurfer_stats_' hemisphere '_combined.csv'];

theTable = readtable(myFile);

%%
[p,tbl,stats] = anova1(theTable.GrayVol,theTable.Group);
[p2,tbl2,stats2] = anova1(theTable.ThickAvg,theTable.Group);

%

figure
[c,m,h,gnames] = multcompare(stats,"Dimension",1,'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('GMV')

writecell(tbl,sprintf([savedir 'anova_gmv_' hemisphere ],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_d1_gmv_' hemisphere ],'%s'),'FileType','spreadsheet')

figure
[c2,m2,h2,gnames2] = multcompare(stats2,"Dimension",1,'Display','on','CriticalValueType','bonferroni');
tbldom2 = array2table(c2,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom2.("Group A")=gnames(tbldom2.("Group A"));
tbldom2.("Group B")=gnames(tbldom2.("Group B"));
title('Cth')

writecell(tbl2,sprintf([savedir 'anova_cth_' hemisphere ],'%s'),'FileType','spreadsheet')
writetable(tbldom2,sprintf([savedir 'mult_d1_cth_' hemisphere ],'%s'),'FileType','spreadsheet')


%%

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



