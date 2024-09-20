
clear variables
close all
clc

% Locate data
mypath = '/Volumes/arianthe/PAIN/mni_first_level_scripts/';
cd(mypath)

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/negative_comparePrePost/'];

nSubs = {'sub01','sub02','sub04','sub05','sub06','sub07'};

% Initialize variables to store all peak_T values and corresponding subject names
all_peak_T1 = [];
all_peak_T2 = [];
all_subject_names_T1 = [];
all_subject_names_T2 = [];

for iSub = nSubs

    disp(iSub)

    thisCSV_pre = [mypath iSub{:} '/preCap/thermode_arm/negH_masked.csv'];
    thisCSV_post = [mypath iSub{:} '/postCap/thermode_arm/negH_masked.csv'];
    
    if isfile(thisCSV_pre)
        file1 = readtable(thisCSV_pre);
        thisT1 = file1.peak_T;
        thisT1_names = repmat(iSub,length(thisT1),1);
        % Concatenate to the big variables
        all_peak_T1 = [all_peak_T1; thisT1];
        all_subject_names_T1 = [all_subject_names_T1; thisT1_names];
    end

    if isfile(thisCSV_post)
        file2 = readtable(thisCSV_post);
        thisT2 = file2.peak_T;
        thisT2_names = repmat(iSub,length(thisT2),1);
        % Concatenate to the big variables
        all_peak_T2 = [all_peak_T2; thisT2];
        all_subject_names_T2 = [all_subject_names_T2; thisT2_names];

    end

end

visit1 = repmat({'Pre-Capsaicin'},length(all_peak_T1),1);
visit2 = repmat({'Post-Capsaicin'},length(all_peak_T2),1);

visits = [visit1; visit2];
all_peaks_T12 = [all_peak_T1; all_peak_T2];
all_subject_names_T12 = [all_subject_names_T1; all_subject_names_T2];


%%
thisFont = 'Helvetica';
myfontsize = 16;
mycmap = [0.8 0.8 0.8];
figure('Position',[100 100 800 600])
clear g
close all

g = gramm('x',visits,'y',all_peaks_T12,'color',all_subject_names_T12);
%g.stat_summary('type','std','geom',{'bar','black_errorbar'})
%g.stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g.stat_boxplot
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Visit', 'y', 'Peak T scores')
%g.axe_property('YLim',[-15 30],'XGrid','on','YGrid','on');
g.set_order_options('x',0)
%g.set_color_options('map',mycmap)
%g.set_title('7T NPS Scalar values')
g.draw()
% g.update('color',details_stack)
% g.geom_jitter
% g.set_point_options('base_size',10)
% g.set_order_options('x',0,'color',0)
% g.set_color_options('map','lch')
% g.draw()

filename = 'preVsPost';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')



%% Stats

[p,tbl,stats,terms] = anovan(all_peaks_T12,{visits,all_subject_names_T12},'model','linear','varnames',{'Visits','Subs'}); %interaction?

figure
[c,m,h,gnames] = multcompare(stats,"Dimension",[1 2]);
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
writecell(tbl,sprintf([savedir 'anova'],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_d12'],'%s'),'FileType','spreadsheet')














