clear variables
close all
whichMac = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' whichMac '/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/Monthly_meetings/meeting_nov24/'];

mypath = '/Users/spmic/data/';


fMRI_gen_file = readtable([mypath 'fMRI.csv']);
fMRI_task_file = readtable([mypath 'taskfMRI.csv']);
fMRI_rs_file = readtable([mypath 'rsfMRI.csv']);
fMRI_uhf_file = readtable([mypath 'uhffmri.csv']);
fMRI_clin_file = readtable([mypath 'clinicalfmri.csv']);

% fix missing entries in UHF
tmpY = [fMRI_uhf_file.Year(1:26); 1998; fMRI_uhf_file.Year(27:32); 1991; fMRI_uhf_file.Year(33)];
tmpX = [fMRI_uhf_file.Count(1:26); 0; fMRI_uhf_file.Count(27:32); 0; fMRI_uhf_file.Count(33)];

fMRI_uhf_file = table; % clear height issue 

fMRI_uhf_file.Year = tmpY;
fMRI_uhf_file.Count = tmpX;
%%
mapCol = [102,194,165;...
252,141,98;...
141,160,203;...
231,138,195;...
166,216,84];
mapCol = mapCol/256;
%%
x = [fMRI_gen_file.Year; fMRI_gen_file.Year; fMRI_gen_file.Year;...
    fMRI_gen_file.Year; fMRI_gen_file.Year];
y = [fMRI_gen_file.Count; fMRI_task_file.Count; fMRI_rs_file.Count;...
    fMRI_uhf_file.Count; fMRI_clin_file.Count];
grp = [repmat({'fMRI'},length(fMRI_gen_file.Year),1);...
    repmat({'task fMRI'},length(fMRI_task_file.Year),1);...
    repmat({'rs fMRI'},length(fMRI_rs_file.Year),1);...
    repmat({'UHF fMRI'},length(fMRI_uhf_file.Year),1);...
    repmat({'Clinical fMRI'},length(fMRI_clin_file.Year),1)];
% Plot using Gramm
close all
figure('Position',[100 100 1024 768])
clear g
g = gramm('x', x, 'y', y, 'color', grp);
g.geom_point
g.set_title('PubMed: Number of Publications (Nov 1990-Nov 2024)');
g.set_names('x', 'Year', 'y', 'Publications', 'color', 'Search term');
g.set_text_options('base_size', 14);
g.set_point_options('markers', {'o'} ,'base_size',12)
g.axe_property('XGrid','on','YGrid','on');
g.set_color_options('map',mapCol)
%g.set_order_options('color',0)
g.draw();

g.update('y',y)
g.geom_line()
g.no_legend
g.draw()
filename = 'fMRITrends_1';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','eps')

%%
x = [fMRI_task_file.Year; fMRI_task_file.Year; fMRI_task_file.Year];
y = [fMRI_task_file.Count; fMRI_rs_file.Count;...
    fMRI_uhf_file.Count];
grp = [
    repmat({'task fMRI'},length(fMRI_task_file.Year),1);...
    repmat({'rs fMRI'},length(fMRI_rs_file.Year),1);...
    repmat({'UHF fMRI'},length(fMRI_uhf_file.Year),1);...
    ];


figure('Position',[100 100 1024 768])
clear g
g = gramm('x', x, 'y', y, 'color', grp);
g.geom_point
g.set_title('PubMed: Number of Publications (Nov 1990-Nov 2024)');
g.set_names('x', 'Year', 'y', 'Publications', 'color', 'Search term');
g.set_text_options('base_size', 14);
g.set_point_options('markers', {'o'} ,'base_size',12)
g.axe_property('XGrid','on','YGrid','on');
g.set_color_options('map',mapCol([2,4,5],:))
g.draw();

g.update('y',y)
g.geom_line()
g.no_legend
g.draw()

filename = 'fMRITrends_2';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','eps')
