% look at plotting thresholds for pain subs
% Pain Relief Grant
% Feb 2024 [ma]
%
%
clear all
close all
close all hidden 
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/bhvr_plots/'];
thisFont = 'Helvetica';
myfontsize = 16;
painsubs = {'12778','15435','11251','14359','11766',...
    '15252','15874'};

hand_search = [46 43 45 43 41 43 45];
hand_limits = [49.2 49.1 48.7 47.8 40.2 47.3 49.9];

hand_search_3t = [46 43  0 43 0 0 43]; % missing subject 3, 5, 6, 7

hand = [hand_search hand_limits];

arm_search = [46 42 45 42 41 44 44];
arm_limits = [46.4 48.5 45.9 47.3 42 45.8 48.4];

arm_search_3t = [46 42 0  42 0 0 42]; % missing subject 3, 5, 6, 7

arm_search_postcap = [41 41 45 38 39 43 41];
arm_limits_postcap = [40.3 46.4 48.2 39.1 38.5 45.1 43.3];

arm = [arm_search arm_limits arm_search_postcap arm_limits_postcap];

hyperalgesia_med = [10 8 10 10 8 5 0];
hyperalgesia_lat = [10 20 12 12 4 0 0];
hyperalgesia_prox = [10 13 20 17 6 10 0];
hyperalgesia_dist = [15 15 30 20 17 5 0];
ha = [hyperalgesia_med hyperalgesia_lat hyperalgesia_prox hyperalgesia_dist];

handslGrp = [repmat({'search'},length(painsubs),1); repmat({'limits'},length(painsubs),1)];

armslGrp = [repmat({'search'},length(painsubs),1); repmat({'limits'},length(painsubs),1);...
    repmat({'search'},length(painsubs),1); repmat({'limits'},length(painsubs),1)];

armCap = [repmat({'preCap'},length(painsubs),1); repmat({'preCap'},length(painsubs),1);...
    repmat({'postCap'},length(painsubs),1); repmat({'postCap'},length(painsubs),1)];

haGrp = [repmat({'Medial'},length(painsubs),1); repmat({'Lateral'},length(painsubs),1);...
    repmat({'Proximal'},length(painsubs),1); repmat({'Distal'},length(painsubs),1)];

%% plot
figure
g = gramm('x',handslGrp,'y',hand);
g.stat_summary('type','std','geom',{'bar','black_errorbar'})
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Hand', 'y', 'Thresholds (temp, degrees)')
g.axe_property('YLim', [0 100],'PlotBoxAspectRatio',[1 1 1],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.draw()
    
filename = 'pain_hand';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')
%%
figure
clear g
g = gramm('x',armslGrp,'y',arm,'color',armCap);
g.stat_summary('type','std','geom',{'bar','black_errorbar'})
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Arm', 'y', 'Thresholds (temp, degrees)')
g.axe_property('YLim', [0 100],'PlotBoxAspectRatio',[1 1 1],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.draw()
filename = 'pain_arm';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')
%% hyperalgesia
figure
clear g
g = gramm('x',haGrp,'y',ha);
g.stat_summary('type','std','geom',{'bar','black_errorbar'})
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Hyperalgesia post Cap', 'y', 'distance (mm)')
g.axe_property('YLim', [0 40],'PlotBoxAspectRatio',[1 1 1],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.draw()
filename = 'ha_arm';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')






