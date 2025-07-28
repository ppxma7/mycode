clear variables
close all

clc


userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/'];

% Load the data
T = readtable([savedir 'nps_table_3T7T.xls']);

% Create gramm object
g(1,1) = gramm( ...
    'x', T.Subject, ...
    'y', T.NPS, ...
    'color', T.Condition);

g(1,2) = gramm( ...
    'x', T.Subject, ...
    'y', T.NPS, ...
    'color', T.Scan);

g(2,1) = gramm( ...
    'x', T.Subject, ...
    'y', T.NPS, ...
    'color', T.Details);

% Add jittered scatter plot
%g(1,1).geom_jitter('width', 0.5, 'dodge', 0.5);
g(1,1).geom_point('dodge',0.1);
g(1,2).geom_point('dodge',0.1);
g(2,1).geom_point('dodge',0.1);


% g(1,2).geom_jitter('width', 0.5, 'dodge', 0.5);
% g(2,1).geom_jitter('width', 0.5, 'dodge', 0.5);

g(1,1).set_names('x', 'Subject', 'y', 'NPS', 'color', 'Condition');
g(1,2).set_names('x', 'Subject', 'y', 'NPS', 'color', 'Scanner');
g(2,1).set_names('x', 'Subject', 'y', 'NPS', 'color', 'Location');

g.set_title('NPS score');
g.set_text_options("base_size",12)
g.set_point_options('base_size',10)
g.set_order_options('x',0)
g.axe_property('YLim',[-60 140])
figure('Position',[100 100 1200 800]);
g.draw()

filename = 'plotnpsvalues';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


