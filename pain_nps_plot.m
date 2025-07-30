clear variables
close all

clc


userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/'];

% Load the data
T3t = readtable([savedir 'nps_table_3T7T.xlsx'],'Sheet','3T');
T7t = readtable([savedir 'nps_table_3T7T.xlsx'],'Sheet','7T');

%%
close all
clear g


t7 = 1;

if t7
    T = T7t;
    filename = 'plotnpsvalues_7t';
    mytitle = '7T';
    lims = [-20 30];
    mymark = {'d','o','p'};
else
    T = T3t;
    mymark = {'o','p'};
    lims = [-60 140];
    mytitle = '3T';
    filename = 'plotnpsvalues_3t';
end

%lims = [-60 140];
% Create gramm object
g = gramm( ...
    'x', T.Subject, ...
    'y', T.NPS, ...
    'color', T.Condition,...
    'marker',T.Details);

% g(1,2) = gramm( ...
%     'x', T.Subject, ...
%     'y', T.NPS, ...
%     'color', T.Scan);

% g(1,2) = gramm( ...
%     'x', T.Subject, ...
%     'y', T.NPS, ...
%     'color', T.Details);

% Add jittered scatter plot
%g(1,1).geom_jitter('width', 0.5, 'dodge', 0.5);
g.geom_jitter2('width',0.2,'height',0.5,'dodge',0.1);
%g(1,2).geom_jitter2('width',0.2,'height',0.5,'dodge',0.1);
%g(2,1).geom_point('dodge',0.1);


% g(1,2).geom_jitter('width', 0.5, 'dodge', 0.5);
% g(2,1).geom_jitter('width', 0.5, 'dodge', 0.5);

g.set_names('x', 'Subject', 'y', 'NPS', 'color', 'Condition');
%g(1,2).set_names('x', 'Subject', 'y', 'NPS', 'color', 'Location');
%g(2,1).set_names('x', 'Subject', 'y', 'NPS', 'color', 'Location');

g.set_title(mytitle);
g.set_text_options("base_size",12)
%g.set_point_options('base_size',10)
g.set_order_options('x',0,'color',0)
%g.axe_property('YLim',[-30 50])
g.axe_property('YLim',lims)

%g.set_point_options("markers",{'o','p'}, 'base_size',10)
g.set_point_options("markers",mymark, 'base_size',10)

figure('Position',[100 100 1000 400]);
g.draw()
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')
% try just capsaicin plot

if t7
    filename2 = 'plotnpsvalues_7t_capsaicin';
    mytitle2 = '7T Arm Capsaicin';
    rowsToRemove = contains(T.Details, 'thermode_hand_pre');
    T(rowsToRemove, :) = [];
    clear g
    g = gramm( ...
        'x', T.Subject, ...
        'y', T.NPS, ...
        'color', T.Condition,...
        'marker',T.Details);
    g.geom_jitter2('width',0.2,'height',0.5,'dodge',0.1);
    g.set_names('x', 'Subject', 'y', 'NPS', 'color', 'Condition');
    g.set_title(mytitle2);
    g.set_text_options("base_size",12)
    g.set_order_options('x',0,'color',0)
    g.axe_property('YLim',lims)
    g.set_point_options("markers",mymark, 'base_size',10)
    figure('Position',[100 100 1000 400]);
    g.draw()
    g.export('file_name',filename2, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

end






