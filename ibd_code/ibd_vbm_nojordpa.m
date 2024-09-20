%% GMV
% HV vs CD
% no jord pas
subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
    '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
    '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
    'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
    'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034',...
    '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
    '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01'};

numHV = 42;
numCD = 34;
%numCDR = 13;

numHV_gita = 34;
numHV_jord = 8;
numPA_gita = 34;
numPA_jord = 13;
numFat = 7;
numNFat = 6;

myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1)];
myGroupC = [repmat({'HV_Gita'},numHV_gita,1);repmat({'HV_Jord'},numHV_jord,1); repmat({'CD_Active'},numCD,1)];




%% GMV CD vs HV nothing in HVvsCDD

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_gmv_takeoutjordanspatients/nojordpa_gmv.mat');
figure('Position',[100 100 1400 600])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_6461);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','GMV Right caudate (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_1839);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','GMV Left cerebellum (cm3)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',ymean_1535);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','GMV Left SMA (cm3)')
g(1,3).set_order_options('x',0)
g(1,4) = gramm('x',myGroup,'y',ymean_533);
g(1,4).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,4).set_point_options('markers', {'o'} ,'base_size',10)
g(1,4).set_text_options('Font','Helvetica','base_size',16)
g(1,4).set_names('x',[],'y','GMV Right mid cingulum (cm3)')
g(1,4).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',ymean_185);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','GMV Right frontal mid (cm3)')
g(2,1).set_order_options('x',0)
g(2,2) = gramm('x',myGroup,'y',ymean_184);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','GMV Left insula (cm3)')
g(2,2).set_order_options('x',0)
g(2,3) = gramm('x',myGroup,'y',ymean_69);
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','GMV Left frontal mid (cm3)')
g(2,3).set_order_options('x',0)
g.draw()


g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupC)
g(1,3).geom_jitter('alpha',0.8)
g(1,4).update('color',myGroupC)
g(1,4).geom_jitter('alpha',0.8)
g(2,1).update('color',myGroupC)
g(2,1).geom_jitter('alpha',0.8)
g(2,2).update('color',myGroupC)
g(2,2).geom_jitter('alpha',0.8)
g(2,3).update('color',myGroupC)
g(2,3).geom_jitter('alpha',0.8)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_6461(1:42),ymean_6461(42:end));
[H,P2,CI,STATS] = ttest2(ymean_1839(1:42),ymean_1839(42:end));
[H,P3,CI,STATS] = ttest2(ymean_1535(1:42),ymean_1535(42:end));
[H,P4,CI,STATS] = ttest2(ymean_533(1:42),ymean_533(42:end));
[H,P5,CI,STATS] = ttest2(ymean_185(1:42),ymean_185(42:end));
[H,P6,CI,STATS] = ttest2(ymean_184(1:42),ymean_184(42:end));
[H,P7,CI,STATS] = ttest2(ymean_69(1:42),ymean_69(42:end));


text(-90,10,['p=' num2str(round(P1,3)) ])
text(-45,10,['p=' num2str(round(P2,3)) ])
text(1,10,['p=' num2str(round(P3,3)) ])
text(45,10,['p=' num2str(round(P4,3)) ])
text(-90,1,['p=' num2str(round(P5,3)) ])
text(-45,1,['p=' num2str(round(P6,3)) ])
text(1,1,['p=' num2str(round(P7,3)) ])


g.export('file_name','cd_vs_hv_gmv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/GMV_nojordpa',...
    'file_type','pdf')



%% WMV
% HV vs CD

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_wmv_takeoutjordanspatients/nojordpa_wmv.mat');
%

figure('Position',[100 100 1000 400])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_652);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','WMV Left cerebellum (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_213);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','WMV Left precentral (cm3)')
g(1,2).set_order_options('x',0)
g.draw()
g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g.draw()

[H,P1,CI,STATS] = ttest2(ymean_652(1:42),ymean_652(42:end));
[H,P2,CI,STATS] = ttest2(ymean_213(1:42),ymean_213(42:end));

text(-45,1,['p=' num2str(round(P1,4)) ])
text(1,1,['p=' num2str(round(P2,4)) ])

g.export('file_name','hvvscd', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/WMV_nojordpa',...
    'file_type','pdf')




%% WMV CD vs HV

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_wmv_takeoutjordanspatients/nojordpa_wmv_cd.mat');
figure('Position',[100 100 1000 600])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_274);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','WMV Right rectus (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_126);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','WMV Left inf parietal (cm3)')
g(1,2).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',ymean_77);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','WMV Right temporal inf (cm3)')
g(2,1).set_order_options('x',0)
g(2,2) = gramm('x',myGroup,'y',ymean_66);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','WMV Left inf occiptal (cm3)')
g(2,2).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g(2,1).update('color',myGroupC)
g(2,1).geom_jitter('alpha',0.8)
g(2,2).update('color',myGroupC)
g(2,2).geom_jitter('alpha',0.8)

g.draw()

[H,P1,CI,STATS] = ttest2(ymean_274(1:42),ymean_274(42:end));
[H,P2,CI,STATS] = ttest2(ymean_126(1:42),ymean_126(42:end));
[H,P3,CI,STATS] = ttest2(ymean_77(1:42),ymean_77(42:end));
[H,P4,CI,STATS] = ttest2(ymean_66(1:42),ymean_66(42:end));

text(-45,10,['p=' num2str(round(P1,3)) ])
text(1,10,['p=' num2str(round(P2,3)) ])
text(-45,1,['p=' num2str(round(P3,3)) ])
text(1,1,['p=' num2str(round(P4,3)) ])

g.export('file_name','cdvshv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/WMV_nojordpa',...
    'file_type','pdf')


%% CT HV vs CD only, nothing in CD vs HV
%
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_ct_takeoutjordanspatients/cluster_mask_ct_nojordpat.gii'); % this is manually derived cluster mask from SPM
%numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters

% I only believe the first 5 here, so magic numClusters to 5
numClusters = 5;


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
figure('Position',[100 100 1200 600])
clear g
g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','CT Left precentral mm')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',clusterMeanT(:,2));
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','CT Left temporal sup mm')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',clusterMeanT(:,3));
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','CT Left postcentral mm')
g(1,3).set_order_options('x',0)
g(2,1) = gramm('x',myGroup,'y',clusterMeanT(:,4));
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','CT Left frontal sup orb mm')
g(2,1).set_order_options('x',0)
g(2,2) = gramm('x',myGroup,'y',clusterMeanT(:,5));
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','CT Left frontal mid mm')
g(2,2).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupC)
g(1,3).geom_jitter('alpha',0.8)
g(2,1).update('color',myGroupC)
g(2,1).geom_jitter('alpha',0.8)
g(2,2).update('color',myGroupC)
g(2,2).geom_jitter('alpha',0.8)

g.draw()

[H,P1,CI,STATS] = ttest2(clusterMeanT(1:42,1),clusterMeanT(42:end,1));
[H,P2,CI,STATS] = ttest2(clusterMeanT(1:42,2),clusterMeanT(42:end,2));
[H,P3,CI,STATS] = ttest2(clusterMeanT(1:42,3),clusterMeanT(42:end,3));
[H,P4,CI,STATS] = ttest2(clusterMeanT(1:42,4),clusterMeanT(42:end,4));
[H,P5,CI,STATS] = ttest2(clusterMeanT(1:42,5),clusterMeanT(42:end,5));

text(-45,10,['p=' num2str(round(P1,3)) ])
text(1,10,['p=' num2str(round(P2,3)) ])
text(45,10,['p=' num2str(round(P3,3)) ])
text(-45,1,['p=' num2str(round(P4,3)) ])
text(1,1,['p=' num2str(round(P5,3)) ])

g.export('file_name','hv_vs_cd_ct', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/CT_nojordpa',...
    'file_type','pdf')

















