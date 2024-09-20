%% GMV
% HV vs CD
% no jord hcs
subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
    '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
    '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
    'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
    '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
    '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-011', 'sub-012', 'sub-014',...
    'sub-021', 'sub-024', 'sub-025', 'sub-033','sub-032','sub-038'};

numHV = 34;
numCD = 34;
numCDR = 13;

% myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
% myGroupC = [repmat({'HV'},numHV,1); repmat({'CD_Active'},numCD,1); repmat({'CD_Remission'},numCDR,1)];

myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
myGroupC = [repmat({'HV'},numHV,1); repmat({'Active'},numCD,1); repmat({'Fatigued'},4,1); repmat({'Non-Fatigued'},1,1);...
    repmat({'Fatigued'},1,1); repmat({'Non-Fatigued'},2,1); repmat({'Fatigued'},1,1);repmat({'Non-Fatigued'},3,1);repmat({'Fatigued'},1,1);];


%% look at removing jordans healthies for GMV
% HV
load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_vbm_gmv_nojordhcs/nojordhc_gmv.mat');
figure
clear g
g = gramm('x',myGroup,'y',ymean_427);
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','GMV left postcentral gyrus (cm3)')
g.set_order_options('x',0)
g.draw()
g.update('color',myGroupC)
g.geom_jitter('alpha',0.8)
g.draw()
[H,P,CI,STATS] = ttest2(ymean_427(1:34),ymean_427(35:end));
text(1,1,['p=' num2str(round(P,3)) ])
g.export('file_name','hv_vs_cd_gmv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/GMV_nojordhc',...
    'file_type','pdf')



%% GMV CD vs HV
load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_vbm_gmv_nojordhcs/nojordhc_cdvshc_gmv.mat');
figure('Position',[100 100 1400 400])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_1955);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','GMV Right amygdala (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_251);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','GMV Left inf parietal (cm3)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',ymean_62);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','GMV Left SMA (cm3)')
g(1,3).set_order_options('x',0)
g.draw()


g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupC)
g(1,3).geom_jitter('alpha',0.8)
g.draw()


[H,P1,CI,STATS] = ttest2(ymean_1955(1:34),ymean_1955(34:end));
[H,P2,CI,STATS] = ttest2(ymean_251(1:34),ymean_251(34:end));
[H,P3,CI,STATS] = ttest2(ymean_62(1:34),ymean_62(34:end));


text(-90,1,['p=' num2str(round(P1,3)) ])
text(-45,1,['p=' num2str(round(P2,3)) ])
text(1,1,['p=' num2str(round(P3,3)) ])


g.export('file_name','cd_vs_hv_gmv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/GMV_nojordhc',...
    'file_type','pdf')



%% WMV
% HV vs

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_vbm_wmv_nojordhcs/nojordhc_hcvscd_wmv.mat');
figure('Position',[100 100 1000 400])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_890);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','WMV Left precentral (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_345);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','WMV cerebellum (cm3)')
g(1,2).set_order_options('x',0)
g.draw()
g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g.draw()

[H,P1,CI,STATS] = ttest2(ymean_890(1:34),ymean_890(34:end));
[H,P2,CI,STATS] = ttest2(ymean_345(1:34),ymean_345(34:end));

text(-45,1,['p=' num2str(round(P1,3)) ])
text(1,1,['p=' num2str(round(P2,3)) ])

g.export('file_name','hv_vs_cd_wmv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/WMV_nojordhc',...
    'file_type','pdf')




%% WMV CD

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_vbm_wmv_nojordhcs/nojordhc_cdvshv_wmv.mat');
figure('Position',[100 100 1400 500])
clear g
g(1,1) = gramm('x',myGroup,'y',ymean_581);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','WMV Left inf parietal (cm3)')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',ymean_255);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','WMV Right rectus (cm3)')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',ymean_181);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','WMV Left inf occiptal (cm3)')
g(1,3).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupC)
g(1,3).geom_jitter('alpha',0.8)

g.draw()

[H,P1,CI,STATS] = ttest2(ymean_581(1:34),ymean_581(34:end));
[H,P2,CI,STATS] = ttest2(ymean_255(1:34),ymean_255(34:end));
[H,P3,CI,STATS] = ttest2(ymean_181(1:34),ymean_181(34:end));

text(-90,1,['p=' num2str(round(P1,3)) ])
text(-45,1,['p=' num2str(round(P2,3)) ])
text(1,1,['p=' num2str(round(P3,3)) ])

g.export('file_name','cd_vs_hv_wmv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/WMV_nojordhc',...
    'file_type','pdf')


%% CT


%
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_vbm_ct_nojordhcs/clustermask_hv.gii'); % this is manually derived cluster mask from SPM
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
figure
clear g
g = gramm('x',myGroup,'y',clusterMeanT);
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','CT Left precentral mm')
g.set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)

g.draw()

[H,P1,CI,STATS] = ttest2(clusterMeanT(1:34,1),clusterMeanT(34:end,1));

text(1,1,['p=' num2str(round(P1,3)) ])

g.export('file_name','hv_vs_cd_ct', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/CT_nojordhc',...
    'file_type','pdf')

%% CT CD vs HC
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_vbm_ct_nojordhcs/clustermaskcd.gii'); % this is manually derived cluster mask from SPM
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
figure('Position',[100 100 1200 400])
clear g
g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','CT Left lingual mm')
g(1,1).set_order_options('x',0)
g(1,2) = gramm('x',myGroup,'y',clusterMeanT(:,2));
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','CT Left temporal inf mm')
g(1,2).set_order_options('x',0)
g(1,3) = gramm('x',myGroup,'y',clusterMeanT(:,3));
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','CT Left lingual mm')
g(1,3).set_order_options('x',0)
g.draw()

g(1,1).update('color',myGroupC)
g(1,1).geom_jitter('alpha',0.8)
g(1,2).update('color',myGroupC)
g(1,2).geom_jitter('alpha',0.8)
g(1,3).update('color',myGroupC)
g(1,3).geom_jitter('alpha',0.8)
g.draw()

[H,P1,CI,STATS] = ttest2(clusterMeanT(1:34,1),clusterMeanT(34:end,1));
[H,P2,CI,STATS] = ttest2(clusterMeanT(1:34,2),clusterMeanT(34:end,2));
[H,P3,CI,STATS] = ttest2(clusterMeanT(1:34,3),clusterMeanT(34:end,3));

text(-90,1,['p=' num2str(round(P1,3)) ])
text(-45,1,['p=' num2str(round(P2,3)) ])
text(1,1,['p=' num2str(round(P3,3)) ])

g.export('file_name','cd_vs_hv_ct', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/CT_nojordhc',...
    'file_type','pdf')



















