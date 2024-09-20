%% 
numPain = 27;
numNoPain = 20;

mycamp2 = [99,99,99; 189,189,189];
mycamp2 = mycamp2./256;


mycamp = [37,52,148; 44,127,184; 65,182,196; 161,218,180; 255,255,204];
mycamp = mycamp./256;


myGroup = [repmat({'Pain'},numPain,1); repmat({'NoPain'},numNoPain,1)];
myGroupC = [repmat({'Active'},21,1); repmat({'Fatigued'},5,1); repmat({'Non-Fatigued'},1,1); ...
    repmat({'Active'},13,1); repmat({'Fatigued'},2,1); repmat({'Non-Fatigued'},5,1)];
%myGroupC = [repmat({'HV'},numHV,1); repmat({'CD_Active'},numPain,1); repmat({'CD_Remission'},numCDR,1)];
myGroupD = [repmat({'Active'},21,1); repmat({'Remission'},5+1,1); ...
    repmat({'Active'},13,1); repmat({'Remission'},2+5,1)];


mycmap = [228,26,28; 77,175,74];
mycmap = mycmap ./ 256;
subjects = {'001_P01','001_P02','001_P04','001_P05','001_P06','001_P12','001_P13',...
    '001_P17','001_P19','001_P21','001_P22',...
    '001_P23','001_P26','001_P27','001_P28','001_P30','001_P31',...
    '001_P37','001_P40','001_P41','001_P43',...
    'sub-003','sub-005', 'sub-006',...
    'sub-024','sub-038','sub-021',...
    '001_P08','001_P15','001_P16','001_P18','001_P20','001_P24',...
    '001_P32','001_P33','001_P35','001_P42','001_P44','001_P45','004_P01',...
    'sub-008','sub-012','sub-011','sub-014','sub-025','sub-032','sub-033'};

figure
bb = gramm('x',{'Pain n=27';'No Pain n=20'},'y',[numPain;numNoPain],'color',{'Pain';'No Pain'});
bb.geom_bar
bb.set_names('x',[],'y',[])
bb.no_legend()
bb.set_color_options('map',mycamp2)
bb.set_order_options('x',0)
bb.set_text_options('Font','Helvetica','base_size',16)
bb.draw()
bb.export('file_name','numcount_pain', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')


%%  GMV no pain

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_pain_gmv/nopain_gmv.mat');

figure('Position',[100 100 1000 400])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left inferior temporal gyrus (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean2);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Left frontal pole (cm3)')
g(1,2).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8)

g.set_color_options('map',mycamp)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean(1:numPain),ymean(numPain+1:end));
[H,P2,CI,STATS] = ttest2(ymean2(1:numPain),ymean(numPain+1:end));


text(-45,1,['p=' num2str(round(P1,4)) ])
text(1,1,['p=' num2str(round(P2,4)) ])

g.export('file_name','gmv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/pain/',...
    'file_type','pdf')

thisfilename = 'GMV no pain';
T = table(subjects(:), ymean, ymean2);
T.Properties.VariableNames = {'Subject','Left inferior temporal gyrus','Left frontal pole'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/pain/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)



%% wmv pain

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_pain_wmv/pain_wmv.mat');

figure('Position',[100 100 1400 700])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_1037);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Right temporal pole (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_489);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Right precentral gyrus (cm3)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',ymean_145);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Left postcentral gyrus (cm3)')
g(1,3).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',ymean_142);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Left mid-frontal gyrus (cm3)')
g(2,1).set_order_options('x',0)
g(2,2) = gramm('x',myGroup,'y',ymean_126);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Left cerebellum (cm3)')
g(2,2).set_order_options('x',0)
g(2,3) = gramm('x',myGroup,'y',ymean_57);
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','Left precentral gyrus (cm3)')
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

g.set_color_options('map',mycamp)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_1037(1:numPain),ymean_1037(numPain+1:end));
[H,P2,CI,STATS] = ttest2(ymean_489(1:numPain),ymean_489(numPain+1:end));
[H,P3,CI,STATS] = ttest2(ymean_145(1:numPain),ymean_145(numPain+1:end));
[H,P4,CI,STATS] = ttest2(ymean_142(1:numPain),ymean_142(numPain+1:end));
[H,P5,CI,STATS] = ttest2(ymean_126(1:numPain),ymean_126(numPain+1:end));
[H,P6,CI,STATS] = ttest2(ymean_57(1:numPain),ymean_57(numPain+1:end));


text(-90,12,['p=' num2str(round(P1,3)) ])
text(-45,12,['p=' num2str(round(P2,3)) ])
text(1,12,['p=' num2str(round(P3,3)) ])
text(-90,1,['p=' num2str(round(P4,3)) ])
text(-45,1,['p=' num2str(round(P5,3)) ])
text(1,1,['p=' num2str(round(P6,3)) ])

g.export('file_name','wmv_plot', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/pain/',...
    'file_type','pdf')

thisfilename = 'WMV pain';
T = table(subjects(:), ymean_1037, ymean_489, ymean_145, ymean_126, ymean_57, ymean_142);
T.Properties.VariableNames = {'Subject','Right temporal pole','Right precentral gyrus',...
    'Left postcentral gyrus','Left cerebellum','Left precentral gyrus','Left mid-frontal gyrus'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/pain/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)



%% CT nopain 
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_pain_ct/nopain_ct.gii'); % this is manually derived cluster mask from SPM
numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters

clusterMean = zeros(numClusters,length(subjects),1); % make space
mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';



% takes about a minute for 6 clusters.
tic
for ii = 1:length(subjects)
    
    thicBoy = gifti([mypath 's15.mesh.thickness.resampled.m' subjects{ii} '.gii']); % all thickness 
    
    for jj = 1:numClusters
        clusterMean(jj,ii) = mean(thicBoy.cdata(find(m.cdata==jj ))); % condensed! take the mean thick val in that cluster, loop over subs
    end
end
toc

clusterMeanT = transpose(clusterMean);
%%
figure('Position',[100 100 1400 700])
clear g

g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left precentral gyrus (mm)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])c

g(1,2) = gramm('x',myGroup,'y',clusterMeanT(:,2));
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Left temporal pole (mm)')
g(1,2).set_order_options('x',0)

g(1,3) = gramm('x',myGroup,'y',clusterMeanT(:,3));
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Left inferior temporal gyrus (mm)')
g(1,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(2,1) = gramm('x',myGroup,'y',clusterMeanT(:,4));
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Right mid-temporal gyrus (mm)')
g(2,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(2,2) = gramm('x',myGroup,'y',clusterMeanT(:,5));
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Right frontal pole (mm)')
g(2,2).set_order_options('x',0)

g(2,3) = gramm('x',myGroup,'y',clusterMeanT(:,6));
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','Right temporal fusiform cortex (mm)')
g(2,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
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


g.set_color_options('map',mycamp)
g.draw()


[H,P1,CI,STATS] = ttest2(clusterMeanT(1:numPain,1),clusterMeanT(numPain+1:end,1));
[H,P2,CI,STATS] = ttest2(clusterMeanT(1:numPain,2),clusterMeanT(numPain+1:end,2));
[H,P3,CI,STATS] = ttest2(clusterMeanT(1:numPain,3),clusterMeanT(numPain+1:end,3));
[H,P4,CI,STATS] = ttest2(clusterMeanT(1:numPain,4),clusterMeanT(numPain+1:end,4));
[H,P5,CI,STATS] = ttest2(clusterMeanT(1:numPain,5),clusterMeanT(numPain+1:end,5));
[H,P6,CI,STATS] = ttest2(clusterMeanT(1:numPain,6),clusterMeanT(numPain+1:end,6));

text(-90,12,['p=' num2str(round(P1,3)) ])
text(-45,12,['p=' num2str(round(P2,3)) ])
text(1,12,['p=' num2str(round(P3,3)) ])
text(-90,1,['p=' num2str(round(P4,3)) ])
text(-45,1,['p=' num2str(round(P5,3)) ])
text(1,1,['p=' num2str(round(P6,3)) ])

g.export('file_name','ct_nopain', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/pain/',...
    'file_type','pdf')

cl1 = clusterMeanT(:,1);
cl2 = clusterMeanT(:,2);
cl3 = clusterMeanT(:,3);
cl4 = clusterMeanT(:,4);
cl5 = clusterMeanT(:,5);
cl6 = clusterMeanT(:,6);

thisfilename = 'ct_nopain';
T = table(subjects(:), cl1, cl2, cl3, cl4, cl5, cl6);
T.Properties.VariableNames = {'Subject','Left precentral gyrus','Left temporal pole',...
    'Left inferior temporal gyrus','Right mid-temporal gyrus','Right frontal pole',...
    'Right temporal fusiform cortex'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/pain/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)




