close all
clear variables
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/forceplots/'];

T = readtable([savedir 'force.xlsx']);

%%
nSubs = 16;
areaFac = 125.7; % from Rosie; 
% This is A, equivalent to F / A x 
% 100000 to go from Force (N/m2) to Pressure (Bar)

T.MVCRightLegBar = T.MVCRightLeg./areaFac;
T.MVCLeftLegBar = T.MVCLeftLeg./areaFac;

MVCs = [T.MVCRightLegBar; T.MVCLeftLegBar;...
    T.x15_Right; T.x15_Left];

grp = [repmat({'MVC Right Leg'}, nSubs,1);...
    repmat({'MVC Left Leg'}, nSubs,1);...
    repmat({'15% Right Leg'}, nSubs,1);...
    repmat({'15% Left Leg'}, nSubs,1);...
    ];

% subj = repmat({'sub01';'sub02';'sub03';'sub04';'sub05';...
%     'sub06';'sub07';'sub08';'sub09';'sub10'},length(unique(grp)),1);

subj = repmat(compose('sub%02d', (1:nSubs)'), length(unique(grp)), 1);
%%
close all
clear g
figure('Position',[100 100 1000 800])
g = gramm('x',grp,'y',MVCs);
g.stat_boxplot2('width',0.2,'alpha',0,'linewidth',1,'drawoutlier',0);  % mean over subjects
g.set_names('x','Group','y','MVC','color','Subject');
g.set_title('Maximum Voluntary Force');
g.set_text_options('Font','Helvetica', 'base_size', 14)
g.set_point_options('base_size',8)
g.set_order_options('x',0)
g.draw()
g.update('y',MVCs,'color',subj);
g.geom_jitter2('dodge', 0.6);  % adds subject dots
%g.no_legend

g.set_order_options('x',0)
g.axe_property('YLim', [0 7],'XGrid','on','YGrid','on');
g.draw();


filename = ('MVCplot');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% facet plot
close all
clear g

% Split data
isMVC = contains(grp, 'MVC');
is15  = contains(grp, '15%');

figure('Position',[100 100 1000 800])

% --- MVC panel ---
g(1,1) = gramm('x', grp(isMVC), 'y', MVCs(isMVC));
g(1,1).stat_boxplot2('width',0.2,'alpha',0,'linewidth',1,'drawoutlier',0);
g(1,1).set_names('x','Group','y','Force');
g(1,1).set_title('MVC');
g(1,1).set_text_options('Font','Helvetica','base_size',14);
g(1,1).set_order_options('x',0);
g(1,1).axe_property('YLim', [0 10],'XGrid','on','YGrid','on');

% --- 15% panel ---
g(1,2) = gramm('x', grp(is15), 'y', MVCs(is15));
g(1,2).stat_boxplot2('width',0.2,'alpha',0,'linewidth',1,'drawoutlier',0);
g(1,2).set_names('x','Group','y','Force');
g(1,2).set_title('15% MVC');
g(1,2).set_text_options('Font','Helvetica','base_size',14);
g(1,2).set_order_options('x',0);
g(1,2).axe_property('YLim', [0 1],'XGrid','on','YGrid','on');

g.draw();

% --- overlay jitter ---
subjMVC = subj(isMVC);
subj15  = subj(is15);

g(1,1).update('y', MVCs(isMVC), 'color', subjMVC);
g(1,1).geom_jitter2('dodge',0.6);
g(1,1).set_order_options('x',0);
g(1,1).no_legend();

g(1,2).update('y', MVCs(is15), 'color', subj15);
g(1,2).geom_jitter2('dodge',0.6);
g(1,2).set_order_options('x',0);
%g(1,2).no_legend();

g.draw();
filename = ('MVCfacetplot');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% can we stats on this

[P, ANOVATAB, STATS] = anova1(MVCs,grp);

[COMPARISON,MEANS,H,GNAMES] = multcompare(STATS);
tbldom = array2table(COMPARISON,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedir 'MVCplot_stats'],'FileType','spreadsheet')


%% and just get the numbers

mvc_mean = mean([T.MVCRightLegBar; T.MVCLeftLegBar]);
mvc_std = std([T.MVCRightLegBar; T.MVCLeftLegBar]);

low_mean = mean([T.x15_Right; T.x15_Left]);
low_std = std([T.x15_Right; T.x15_Left]);

% Format the output string
outstr = sprintf('MVC: Mean (stdev): %.3f (%.3f)\n  Low: Mean (stdev): %.3f (%.3f)\n', mvc_mean, mvc_std, low_mean, low_std);
fprintf(outstr)
outfile = fullfile(savedir, 'mvc_vals.txt');
writelines(outstr, outfile)
