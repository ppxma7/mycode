%% 
numEIM = 12;
numNoEIM = 35;

myGroup = [repmat({'EIM'},numEIM,1); repmat({'NoEIM'},numNoEIM,1)];

myGroupC = [repmat({'Active'},10,1); repmat({'Fatigued'},2,1); repmat({'Active'},24,1); repmat({'Fatigued'},2,1);...
    repmat({'Non-Fatigued'},1,1); repmat({'Fatigued'},1,1); repmat({'Non-Fatigued'},2,1); repmat({'Fatigued'},1,1);...
    repmat({'Non-Fatigued'},3,1); repmat({'Fatigued'},1,1)];

myGroupD = [repmat({'Active'},10,1); repmat({'Remission'},2,1); ...
    repmat({'Active'},24,1); repmat({'Remission'},11,1)];

mycmap = [228,26,28; 77,175,74];
mycmap = mycmap ./ 256;

mycamp = [37,52,148; 44,127,184; 65,182,196; 161,218,180; 255,255,204];
mycamp = mycamp./256;

subjects = {'001_P04','001_P16','001_P17','001_P18','001_P20','001_P22','001_P23',...
    '001_P24','001_P41','001_P42','sub-003','sub-005'...
    '001_P01','001_P02','001_P05','001_P06','001_P08','001_P12',...
    '001_P13','001_P15','001_P19','001_P21',...
    '001_P26','001_P27', '001_P28','001_P30',...
    '001_P31','001_P32','001_P33','001_P35','001_P37','001_P40',...
    '001_P43','001_P44','001_P45','004_P01',...
    'sub-006','sub-008','sub-011','sub-012','sub-014','sub-021','sub-024','sub-025',...
    'sub-032','sub-033','sub-038'};

figure
bb = gramm('x',{'EIM n=12';'No EIM n=35'},'y',[numEIM;numNoEIM],'color',{'EIM';'No EIM'});
bb.geom_bar
bb.set_names('x',[],'y',[])
bb.no_legend()
bb.set_color_options('map',mycmap)
bb.set_order_options('x',0)
bb.set_text_options('Font','Helvetica','base_size',16)
bb.draw()
bb.export('file_name','numcount_eim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

%%  GMV no eim


load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/oct_2020_jg_eim_gmv/noeim_gmv.mat');

figure('Position',[100 100 1400 900])

clear g
g(1,1) = gramm('x',myGroup,'y',ymean_1602);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left postcentral gyrus (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_1113);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Right precuneus (cm3)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',ymean_575);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Right middle temporal gyrus (cm3)')
g(1,3).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',ymean_333);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Left precuneus (cm3)')
g(2,1).set_order_options('x',0)
g(2,2) = gramm('x',myGroup,'y',ymean_292);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Right mid-frontal gyrus (cm3)')
g(2,2).set_order_options('x',0)
g(2,3) = gramm('x',myGroup,'y',ymean_274);
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','GMV Right temporal mid (cm3)')
g(2,3).set_order_options('x',0)
g(3,1) = gramm('x',myGroup,'y',ymean_207);
g(3,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,1).set_point_options('markers', {'o'} ,'base_size',10)
g(3,1).set_text_options('Font','Helvetica','base_size',16)
g(3,1).set_names('x',[],'y','GMV Right rectus (cm3)')
g(3,1).set_order_options('x',0)
g(3,2) = gramm('x',myGroup,'y',ymean_148);
g(3,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,2).set_point_options('markers', {'o'} ,'base_size',10)
g(3,2).set_text_options('Font','Helvetica','base_size',16)
g(3,2).set_names('x',[],'y','GMV Left temporal mid (cm3)')
g(3,2).set_order_options('x',0)
g(3,3) = gramm('x',myGroup,'y',ymean_131);
g(3,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,3).set_point_options('markers', {'o'} ,'base_size',10)
g(3,3).set_text_options('Font','Helvetica','base_size',16)
g(3,3).set_names('x',[],'y','GMV Right temporal inferior (cm3)')
g(3,3).set_order_options('x',0)

g(4,1) = gramm('x',myGroup,'y',ymean_1602_co);
g(4,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(4,1).set_point_options('markers', {'o'} ,'base_size',10)
g(4,1).set_text_options('Font','Helvetica','base_size',16)
g(4,1).set_names('x',[],'y','Left central opercular (cm3)')
g(4,1).set_order_options('x',0)

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
g(3,1).update('color',myGroupD)
g(3,1).geom_jitter('alpha',0.8)
g(3,2).update('color',myGroupD)
g(3,2).geom_jitter('alpha',0.8)
g(3,3).update('color',myGroupD)
g(3,3).geom_jitter('alpha',0.8)
g(4,1).update('color',myGroupD)
g(4,1).geom_jitter('alpha',0.8)
g.set_color_options('map',mycamp)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_1602(1:numEIM),ymean_1602(numEIM+1:end));
[H,P2,CI,STATS] = ttest2(ymean_1113(1:numEIM),ymean_1113(numEIM+1:end));
[H,P3,CI,STATS] = ttest2(ymean_575(1:numEIM),ymean_575(numEIM+1:end));
[H,P4,CI,STATS] = ttest2(ymean_333(1:numEIM),ymean_333(numEIM+1:end));
[H,P5,CI,STATS] = ttest2(ymean_292(1:numEIM),ymean_292(numEIM+1:end));
[H,P6,CI,STATS] = ttest2(ymean_274(1:numEIM),ymean_274(numEIM+1:end));
[H,P7,CI,STATS] = ttest2(ymean_207(1:numEIM),ymean_207(numEIM+1:end));
[H,P8,CI,STATS] = ttest2(ymean_148(1:numEIM),ymean_148(numEIM+1:end));
[H,P9,CI,STATS] = ttest2(ymean_131(1:numEIM),ymean_131(numEIM+1:end));
[H,P10,CI,STATS] = ttest2(ymean_1602_co(1:numEIM),ymean_1602_co(numEIM+1:end));


text(1,21,['p=' num2str(round(P1,3)) ])
text(47,21,['p=' num2str(round(P2,3)) ])
text(95,21,['p=' num2str(round(P3,3)) ])
text(1,14,['p=' num2str(round(P4,3)) ])
text(47,14,['p=' num2str(round(P5,3)) ])
text(95,14,['p=' num2str(round(P6,3)) ])
text(1,8,['p=' num2str(round(P7,3)) ])
text(47,8,['p=' num2str(round(P8,3)) ])
text(95,8,['p=' num2str(round(P9,3)) ])
text(1,1,['p=' num2str(round(P10,3)) ])


g.export('file_name','gmv_noeim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/EIM/eim_corrected',...
    'file_type','pdf')

thisfilename = 'GMV no eim';
T = table(subjects(:), ymean_1602, ymean_1113,ymean_575, ymean_333, ymean_292, ymean_1602_co);
T.Properties.VariableNames = {'Subject','Left postcentral gyrus','Right precuneus',...
    'Right middle temporal gyrus','Left precuneus','Right mid-frontal gyrus',...
    'Left central opercular'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/eim/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)


%% GMV EIM

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/oct_2020_jg_eim_gmv/eim_gmv.mat');

%figure('Position',[100 100 1200 700])
figure
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_73);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','GMV Left precentral (cm3)')
g(1,1).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8)
g.set_color_options('map',mycamp)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_73(1:numEIM),ymean_73(numEIM+1:end));



text(1,1,['p=' num2str(round(P1,3)) ])

g.export('file_name','gmv_eim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/EIM/eim_corrected/',...
    'file_type','pdf')

%% wmv eim

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/oct_2020_jg_eim_wmv/eim_wmv.mat');

figure('Position',[100 100 800 600])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_542);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left lateral occipital cortex (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_249);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Left superior parietal lobule (cm3)')
g(1,2).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',ymean_245);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Left occipital pole (cm3)')
g(2,1).set_order_options('x',0)
% g(2,2) = gramm('x',myGroup,'y',ymean_144);
% g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
% g(2,2).set_text_options('Font','Helvetica','base_size',16)
% g(2,2).set_names('x',[],'y','WMV Left temporal pole sup (cm3)')
% g(2,2).set_order_options('x',0)

g.draw()

g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8)
% g(2,2).update('color',myGroupD)
% g(2,2).geom_jitter('alpha',0.8)


g.set_color_options('map',mycamp)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_542(1:numEIM),ymean_542(numEIM+1:end));
[H,P2,CI,STATS] = ttest2(ymean_249(1:numEIM),ymean_249(numEIM+1:end));
[H,P3,CI,STATS] = ttest2(ymean_245(1:numEIM),ymean_245(numEIM+1:end));
% [H,P4,CI,STATS] = ttest2(ymean_144(1:numEIM),ymean_144(numEIM+1:end));



text(1,9,['p=' num2str(round(P1,3)) ])
text(50,9,['p=' num2str(round(P2,3)) ])
text(1,1,['p=' num2str(round(P3,3)) ])
% text(1,1,['p=' num2str(round(P4,3)) ])


g.export('file_name','wmv_eim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/EIM/eim_corrected/',...
    'file_type','pdf')

thisfilename = 'WMV eim';
T = table(subjects(:), ymean_542, ymean_249,ymean_245 );
T.Properties.VariableNames = {'Subject','Left lateral occipital cortex','Left superior parietal lobule',...
    'Left occipital pole'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/eim/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)



%% CT eim
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/oct_2020_jg_eim_ct/eim_ct.gii'); % this is manually derived cluster mask from SPM
numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters
clusterMean = zeros(numClusters,length(subjects),1); % make space
mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';

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
figure
clear g

g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Right frontal pole (mm)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()

g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8)
g.set_color_options('map',mycamp)


g.draw()

[H,P1,CI,STATS] = ttest2(clusterMeanT(1:numEIM,1),clusterMeanT(numEIM+1:end,1));
text(1,1,['p=' num2str(round(P1,3)) ])
g.export('file_name','ct_eim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/EIM/eim_corrected/',...
    'file_type','pdf')

cl1 = clusterMeanT(:,1);

thisfilename = 'ct_eim';
T = table(subjects(:), cl1);
T.Properties.VariableNames = {'Subject','Right frontal pole',};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/eim/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)



%% CT NO eim
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/oct_2020_jg_eim_ct/noeim_ct.gii'); % this is manually derived cluster mask from SPM
numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters
clusterMean = zeros(numClusters,length(subjects),1); % make space
mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';

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
figure('Position',[100 100 1200 300])
clear g

g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left orbital frontal gyrus (mm)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',clusterMeanT(:,2));
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Right lateral occipital cortex (mm)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',clusterMeanT(:,3));
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Left parahippocampal gyrus (mm)')
g(1,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()

g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8)

g.set_color_options('map',mycamp)

g.draw()

[H,P1,CI,STATS] = ttest2(clusterMeanT(1:numEIM,1),clusterMeanT(numEIM+1:end,1));
[H,P2,CI,STATS] = ttest2(clusterMeanT(1:numEIM,2),clusterMeanT(numEIM+1:end,2));
[H,P3,CI,STATS] = ttest2(clusterMeanT(1:numEIM,3),clusterMeanT(numEIM+1:end,3));

text(-90,1,['p=' num2str(round(P1,3)) ])
text(-45,1,['p=' num2str(round(P2,3)) ])
text(1,1,['p=' num2str(round(P3,3)) ])

g.export('file_name','ct_noeim', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/EIM/eim_corrected/',...
    'file_type','pdf')

cl1 = clusterMeanT(:,1);
cl2 = clusterMeanT(:,2);
cl3 = clusterMeanT(:,3);
thisfilename = 'ct_noeim';
T = table(subjects(:), cl1, cl2, cl3);
T.Properties.VariableNames = {'Subject','Left orbital frontal gyrus','Right lateral occipital cortex',...
    'Left parahippocampal gyrus'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/eim/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)


