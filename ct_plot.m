cd /Volumes/ares/data/elliot/brainstorm_stats/
load('brainstorm_export_DK.mat')

Y1 = compThick.Value(:,1);
Y2 = compThick.Value(:,2);

% X = 1:length(Y1);
% X = X(:);
Y = [Y1;Y2];

X = compThick.Description;
X = [X;X];

whichScan = [repmat({'noCS'},length(Y1),1); repmat({'CS'},length(Y1),1) ];

%%
clear g
close all
figure('Position',[100 100 1800 700])
g = gramm('x',X,'y',Y,'color',whichScan);
g.geom_point()
g.set_point_options('markers', {'o'} ,'base_size',15)
%g.axe_property('YLim',[30 75])
%g.set_title('Mot')
%g.axe_property('YLim',[1.5 4])
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','DK region', 'y','Cortical thickness (mm^2)')
g.draw

xtickangle(-45)


 g.export('file_name','cs_elliot', ...
        'export_path','/Users/ppzma/Google Drive/PhD/latex/affinity/elliot/' ,'file_type','pdf')

% figure
% plot(X,Y1,'b','Linewidth',2)
% hold on
% plot(X,Y2,'r','Linewidth',2)
% legend('noCS','CS')
% title('CS vs noCS thickness')
% xlabel('DK atlas regions')
% ylabel('cortical thickness (mm2)')

% resids = abs(Y1-Y2);
% figure, plot(resids)
% 
% figure
% plot(Y1_ind,'b','Linewidth',2)
% hold on
% plot(Y2_ind,'r','Linewidth',2)
% legend('noCS','CS')
% title('CS vs noCS thickness')
% xlabel('DK atlas regions')
% ylabel('cortical thickness (mm2)')


