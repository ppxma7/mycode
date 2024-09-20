%% 
numEIM = 12;
numNoEIM = 35;

myGroup = [repmat({'EIM'},numEIM,1); repmat({'NoEIM'},numNoEIM,1)];
myGroupC = [repmat({'Active'},25,1); repmat({'Fatigued'},5,1); repmat({'Non-Fatigued'},1,1); repmat({'Active'},9,1); repmat({'Fatigued'},2,1); repmat({'Non-Fatigued'},5,1)];
%myGroupC = [repmat({'HV'},numHV,1); repmat({'CD_Active'},numPain,1); repmat({'CD_Remission'},numCDR,1)];

myGroupD = [repmat({'Active'},21,1); repmat({'Remission'},5+1,1); ...
    repmat({'Active'},13,1); repmat({'Remission'},2+5,1)];



mycmap = [228,26,28; 77,175,74];
mycmap = mycmap ./ 256;
subjects = {'001_P04','001_P21','001_P22','001_P23','001_P27','001_P30','001_P31',...
    '001_P37','001_P15','001_P16','001_P33',...
    '001_P35','001_P01','001_P02','001_P05','001_P06','001_P12',...
    '001_P13','001_P17','001_P19','001_P26',...
    '001_P28','001_P40', '001_P41','001_P43',...
    'sub-003','sub-005','sub-006','sub-024','sub-038','sub-021',...
    '001_P08','001_P18','001_P20','001_P24','001_P32','001_P42',...
    '001_P44','001_P45','004_P01',...
    'sub-008','sub-012','sub-011','sub-014','sub-025','sub-032','sub-033'};
%%  GMV no eim

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_eim_gmv/noeim_gmv.mat');

figure('Position',[100 100 1200 700])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_793);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','GMV right lingual (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_453);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','GMV left post cingulum (cm3)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',ymean_267);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','GMV Left temporal pole sup(cm3)')
g(1,3).set_order_options('x',0)
g(1,4) = gramm('x',myGroup,'y',ymean_250);
g(1,4).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,4).set_point_options('markers', {'o'} ,'base_size',10)
g(1,4).set_text_options('Font','Helvetica','base_size',16)
g(1,4).set_names('x',[],'y','GMV Left rectus (cm3)')
g(1,4).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',ymean_203);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','GMV Right parahippocampal (cm3)')
g(2,1).set_order_options('x',0)
g(2,2) = gramm('x',myGroup,'y',ymean_146);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','GMV Right precuneus (cm3)')
g(2,2).set_order_options('x',0)
g(2,3) = gramm('x',myGroup,'y',ymean_74);
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','GMV Left temporal inf (cm3)')
g(2,3).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8)
g(1,4).update('color',myGroupD)
g(1,4).geom_jitter('alpha',0.8)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8)
g(2,2).update('color',myGroupD)
g(2,2).geom_jitter('alpha',0.8)
g(2,3).update('color',myGroupD)
g(2,3).geom_jitter('alpha',0.8)

%g.set_color_options('map',mycmap)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_793(1:numEIM),ymean_793(numEIM+1:end));
[H,P2,CI,STATS] = ttest2(ymean_453(1:numEIM),ymean_453(numEIM+1:end));
[H,P3,CI,STATS] = ttest2(ymean_267(1:numEIM),ymean_267(numEIM+1:end));
[H,P4,CI,STATS] = ttest2(ymean_250(1:numEIM),ymean_250(numEIM+1:end));
[H,P5,CI,STATS] = ttest2(ymean_203(1:numEIM),ymean_203(numEIM+1:end));
[H,P6,CI,STATS] = ttest2(ymean_146(1:numEIM),ymean_146(numEIM+1:end));
[H,P7,CI,STATS] = ttest2(ymean_74(1:numEIM),ymean_74(numEIM+1:end));


text(-90,12,['p=' num2str(round(P1,3)) ])
text(-45,12,['p=' num2str(round(P2,3)) ])
text(1,12,['p=' num2str(round(P3,3)) ])
text(45,12,['p=' num2str(round(P4,3)) ])
text(-90,1,['p=' num2str(round(P5,3)) ])
text(-45,1,['p=' num2str(round(P6,3)) ])
text(1,1,['p=' num2str(round(P7,3)) ])

g.export('file_name','gmv_ploteim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/eim/',...
    'file_type','pdf')

%% wmv no eim

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_eim_wmv/noeim_wmv.mat');

figure('Position',[100 100 1200 700])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_782);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','WMV Left temporal pole sup (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_491);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','WMV Right lingual (cm3)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',ymean_173);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','WMV Left temporal pole sup (cm3)')
g(1,3).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',ymean_136);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','WMV Right lingual (cm3)')
g(2,1).set_order_options('x',0)
g(2,2) = gramm('x',myGroup,'y',ymean_122);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','WMV Right calcarine (cm3)')
g(2,2).set_order_options('x',0)
g(2,3) = gramm('x',myGroup,'y',ymean_81);
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','WMV Right precuneus (cm3)')
g(2,3).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8)
g(2,2).update('color',myGroupD)
g(2,2).geom_jitter('alpha',0.8)
g(2,3).update('color',myGroupD)
g(2,3).geom_jitter('alpha',0.8)

%g.set_color_options('map',mycmap)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_782(1:numEIM),ymean_782(numEIM+1:end));
[H,P2,CI,STATS] = ttest2(ymean_491(1:numEIM),ymean_491(numEIM+1:end));
[H,P3,CI,STATS] = ttest2(ymean_173(1:numEIM),ymean_173(numEIM+1:end));
[H,P4,CI,STATS] = ttest2(ymean_136(1:numEIM),ymean_136(numEIM+1:end));
[H,P5,CI,STATS] = ttest2(ymean_122(1:numEIM),ymean_122(numEIM+1:end));
[H,P6,CI,STATS] = ttest2(ymean_81(1:numEIM),ymean_81(numEIM+1:end));


text(-90,12,['p=' num2str(round(P1,3)) ])
text(-45,12,['p=' num2str(round(P2,3)) ])
text(1,12,['p=' num2str(round(P3,3)) ])
text(-90,1,['p=' num2str(round(P4,3)) ])
text(-45,1,['p=' num2str(round(P5,3)) ])
text(1,1,['p=' num2str(round(P6,3)) ])

g.export('file_name','wmv_plotnoeim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/eim/',...
    'file_type','pdf')

%% CT noeim
% m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_pain_ct/nopain_ct.gii'); % this is manually derived cluster mask from SPM
% numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
% sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters
% 
% clusterMean = zeros(numClusters,length(subjects),1); % make space
% mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';
% 
% 
% 
% % takes about a minute for 6 clusters.
% tic
% for ii = 1:length(subjects)
%     
%     thicBoy = gifti([mypath 's15.mesh.thickness.resampled.m' subjects{ii} '.gii']); % all thickness 
%     
%     for jj = 1:numClusters
%         clusterMean(jj,ii) = mean(thicBoy.cdata(find(m.cdata==jj ))); % condensed! take the mean thick val in that cluster, loop over subs
%     end
% end
% toc
% 
% clusterMeanT = transpose(clusterMean);
% %%
% figure('Position',[100 100 1400 700])
% clear g
% 
% g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
% g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
% g(1,1).set_text_options('Font','Helvetica','base_size',16)
% g(1,1).set_names('x',[],'y','CT Left precentral mm')
% g(1,1).set_order_options('x',0)
% %g.axe_property('YLim',[0.2 0.5])c
% 
% g(1,2) = gramm('x',myGroup,'y',clusterMeanT(:,2));
% g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
% g(1,2).set_text_options('Font','Helvetica','base_size',16)
% g(1,2).set_names('x',[],'y','CT Left temporal mid mm')
% g(1,2).set_order_options('x',0)
% 
% g(1,3) = gramm('x',myGroup,'y',clusterMeanT(:,3));
% g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
% g(1,3).set_text_options('Font','Helvetica','base_size',16)
% g(1,3).set_names('x',[],'y','CT Left temporal mid mm')
% g(1,3).set_order_options('x',0)
% %g.axe_property('YLim',[0.2 0.5])
% 
% g(2,1) = gramm('x',myGroup,'y',clusterMeanT(:,4));
% g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
% g(2,1).set_text_options('Font','Helvetica','base_size',16)
% g(2,1).set_names('x',[],'y','CT Right temporal mid mm')
% g(2,1).set_order_options('x',0)
% %g.axe_property('YLim',[0.2 0.5])
% 
% g(2,2) = gramm('x',myGroup,'y',clusterMeanT(:,5));
% g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
% g(2,2).set_text_options('Font','Helvetica','base_size',16)
% g(2,2).set_names('x',[],'y','CT Right frontal mid mm')
% g(2,2).set_order_options('x',0)
% 
% g(2,3) = gramm('x',myGroup,'y',clusterMeanT(:,6));
% g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
% g(2,3).set_text_options('Font','Helvetica','base_size',16)
% g(2,3).set_names('x',[],'y','CT Right fusiform mm')
% g(2,3).set_order_options('x',0)
% %g.axe_property('YLim',[0.2 0.5])
% g.draw()
% 
% 
% g(1,1).update('color',myGroupC)
% g(1,1).geom_jitter('alpha',0.8)
% g(1,2).update('color',myGroupC)
% g(1,2).geom_jitter('alpha',0.8)
% g(1,3).update('color',myGroupC)
% g(1,3).geom_jitter('alpha',0.8)
% g(2,1).update('color',myGroupC)
% g(2,1).geom_jitter('alpha',0.8)
% g(2,2).update('color',myGroupC)
% g(2,2).geom_jitter('alpha',0.8)
% g(2,3).update('color',myGroupC)
% g(2,3).geom_jitter('alpha',0.8)
% g.draw()
% 
% 
% [H,P1,CI,STATS] = ttest2(clusterMeanT(1:42,1),clusterMeanT(43:end,1));
% [H,P2,CI,STATS] = ttest2(clusterMeanT(1:42,2),clusterMeanT(43:end,2));
% [H,P3,CI,STATS] = ttest2(clusterMeanT(1:42,3),clusterMeanT(43:end,3));
% [H,P4,CI,STATS] = ttest2(clusterMeanT(1:42,4),clusterMeanT(43:end,4));
% [H,P5,CI,STATS] = ttest2(clusterMeanT(1:42,5),clusterMeanT(43:end,5));
% [H,P6,CI,STATS] = ttest2(clusterMeanT(1:42,6),clusterMeanT(43:end,6));
% 
% text(-90,12,['p=' num2str(round(P1,3)) ])
% text(-45,12,['p=' num2str(round(P2,3)) ])
% text(1,12,['p=' num2str(round(P3,3)) ])
% text(-90,1,['p=' num2str(round(P4,3)) ])
% text(-45,1,['p=' num2str(round(P5,3)) ])
% text(1,1,['p=' num2str(round(P6,3)) ])
% 
% g.export('file_name','ct_nopain', ...
%     'export_path',...
%     '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/eim/',...
%     'file_type','pdf')


