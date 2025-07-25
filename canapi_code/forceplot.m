close all
clear variables
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/forceplots/'];

T = readtable([savedir 'force.xlsx']);

%%
nSubs = 10;
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

subj = repmat({'sub01';'sub02';'sub03';'sub04';'sub05';...
    'sub06';'sub07';'sub08';'sub09';'sub10'},length(unique(grp)),1);


close all
clear g
figure('Position',[100 100 800 400])
g = gramm('x',grp,'y',MVCs);
g.stat_boxplot2('width',0.2,'alpha',0,'linewidth',1,'drawoutlier',0);  % mean over subjects
g.set_names('x','Group','y','MVC','color','Subject');
g.set_title('Maximum Voluntary Force');
g.set_text_options('Font','Helvetica', 'base_size', 14)
g.set_point_options('base_size',8)
g.set_order_options('x',0)
g.draw()
g.update('y',MVCs,'color',subj);
g.geom_jitter('dodge', 0.6);  % adds subject dots
%g.no_legend

g.set_order_options('x',0)
g.axe_property('YLim', [0 7]);
g.draw();


filename = ('MVCplot');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

