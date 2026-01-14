clear all
close all

mypath = '/Volumes/DRS-GBPerm/other/outputs/';
userName = char(java.lang.System.getProperty('user.name'));
savepath = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/t2/'];


csvfile = 't2lesiontable_combined.csv';
T = readtable(fullfile(mypath, csvfile));

group = T.GROUP;

%%
clear g
close all

figure('Position',[100 100 800 500])

g = gramm('x',T.GROUP,'y',T.wmhvol);
g.stat_boxplot2('drawoutlier',0);
g.set_names('x','Group','y','wmhvol');
%g.set_names('x','ROI','y','Mean T1','color','Group');
%g.set_point_options('base_size',1)
%g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.axe_property('YGrid','on','XGrid','on');
g.set_order_options('x',0)
g.draw()

g.update('y',T.wmhvol)
g.geom_jitter()

g.draw();
filename = 't2plot_wmhvol';
g.export('file_name', ...
    fullfile(savepath,filename), ...
    'file_type','pdf');


clear g
close all

figure('Position',[100 100 800 500])

g = gramm('x',T.GROUP,'y',T.numclusters);
g.stat_boxplot2('drawoutlier',0);
g.set_names('x','Group','y','numclusters');
%g.set_names('x','ROI','y','Mean T1','color','Group');
%g.set_point_options('base_size',1)
%g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.axe_property('YGrid','on','XGrid','on');
g.set_order_options('x',0)
g.draw()

g.update('y',T.numclusters)
g.geom_jitter()

g.draw();
filename = 't2plot_numclusters';
g.export('file_name', ...
    fullfile(savepath,filename), ...
    'file_type','pdf');

