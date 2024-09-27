function [] = plotRealignTextFiles(thisTxt, names, savedir)
%plotRealignTextFiles 
%
% thisTxt is a struct, where each field is a text file, typically the text
%               file is N dynamics by 6 motion parameters
%
% names is a cell of names for the title, e.g. {'hello'}
%
% savedir is path to where you want save the png
%
% ma 2024

moparams = load(thisTxt);

figure('Position',[100 100 700 400])
tiledlayout(2,2)
nexttile([1 2])
%nexttile
plot(moparams(:,1),'LineWidth',2)
hold on
plot(moparams(:,2),'LineWidth',2)
plot(moparams(:,3),'LineWidth',2)
legend('x','y','z','Location','eastoutside')
%ylim([-0.8 0.8])
grid minor
ylabel('mm')
%title(sprintf('dataset %s',{names}))
title(sprintf('dataset %s', names{1}));
nexttile([1 2])
plot(moparams(:,4),'LineWidth',2)
hold on
plot(moparams(:,5),'LineWidth',2)
plot(moparams(:,6),'LineWidth',2)
legend('pitch','roll','yaw','Location','eastoutside')
%ylim([-0.02 0.02])
grid minor
ylabel('degrees/radians')
print([savedir 'subject_motion_' names{1} '.png'], '-dpng', '-r300');



end