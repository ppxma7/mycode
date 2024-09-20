%script to extract active clusters from SPM maps for CAT12 surface data.
% because you can't use marsbar on surfaces
% so we have to save out the clusters
% order them by size
% then index into all the thickness values from the individual surface maps
% (smoothed by 15mm) in cat12 surf folder.
% output is cluster x subject matrix, means. Can then do stats on this.

cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/label/

% 
% mycamp = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0];
% mycamp = mycamp./256;

mycamp = [37,52,148; 44,127,184; 65,182,196; 161,218,180; 255,255,204];
mycamp = mycamp./256;


mycamp = [37,52,148; 44,127,184; 255, 255, 255; 161,218,180; 255,255,204];
mycamp = mycamp./256;


% subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
%     '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
%     '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
%     'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
%     'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034',...
%     '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
%     '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
%     '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
%     '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
%     '001_P45','004_P01',...
%     'sub-003','sub-005', 'sub-006', 'sub-008','sub-011', 'sub-012', 'sub-014',...
%     'sub-021', 'sub-024', 'sub-025', 'sub-033','sub-032','sub-038'};

subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
    '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
    '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
    'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
    'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034',...
    '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
    '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-012', 'sub-024', 'sub-038',...
    'sub-011', 'sub-014', 'sub-021', 'sub-025','sub-032','sub-033'};


m = gifti('CD_HV_cluster_mask.gii'); % this is manually derived cluster mask from SPM
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

%
%% now we want to plot all GMV values in this ROI
numHV_gita = 34;
numHV_jord = 8;
numPA_gita = 34;
numPA_jord = 13;
numFat = 7;
numNFat = 6;

numHV = 42;
numCD = 34;
numCDR = 13;

myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
myGroupC = [repmat({'HV_gita'},numHV_gita,1); repmat({'HV_jord'},numHV_jord,1); repmat({'Active'},numPA_gita,1); ...
    repmat({'Fatigued'},numFat,1); repmat({'Non-Fatigued'},numNFat,1);];
myGroupD = [repmat({'HV'},numHV,1); repmat({'Active'},numCD,1); repmat({'Remission'},numCDR,1)];

% myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
% myGroupC = [repmat({'HV'},numHV,1); repmat({'CD_Active'},numCD,1); repmat({'CD_Remission'},numCDR,1)];

% cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_CT/
% 
% load('CD_HV_mdata.mat');
%regionName = 'lcaudate';

clusterMeanT = transpose(clusterMean);

figure('Position',[100 100 1400 400])
clear g

g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left lingual gyrus (mm)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])c

g(1,2) = gramm('x',myGroup,'y',clusterMeanT(:,2));
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Left mid-temporal gyrus (mm)')
g(1,2).set_order_options('x',0)

g(1,3) = gramm('x',myGroup,'y',clusterMeanT(:,3));
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Left hippocampus (mm)')
g(1,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
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
% g(2,2).set_names('x',[],'y','CT Left fusiform mm')
% g(2,2).set_order_options('x',0)
% 
% g(2,3) = gramm('x',myGroup,'y',clusterMeanT(:,6));
% g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
% g(2,3).set_text_options('Font','Helvetica','base_size',16)
% g(2,3).set_names('x',[],'y','CT Left lingual gyrus mm')
% g(2,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8,'edgewidth',2)
% g(2,1).update('color',myGroupC)
% g(2,1).geom_jitter('alpha',0.8)
% g(2,2).update('color',myGroupC)
% g(2,2).geom_jitter('alpha',0.8)
% g(2,3).update('color',myGroupC)
% g(2,3).geom_jitter('alpha',0.8)
g.set_color_options('map',mycamp)

g.draw()


[H,P1,CI,STATS] = ttest2(clusterMeanT(1:42,1),clusterMeanT(43:end,1));
[H,P2,CI,STATS] = ttest2(clusterMeanT(1:42,2),clusterMeanT(43:end,2));
[H,P3,CI,STATS] = ttest2(clusterMeanT(1:42,3),clusterMeanT(43:end,3));
% [H,P4,CI,STATS] = ttest2(clusterMeanT(1:42,4),clusterMeanT(43:end,4));
% [H,P5,CI,STATS] = ttest2(clusterMeanT(1:42,5),clusterMeanT(43:end,5));
% [H,P6,CI,STATS] = ttest2(clusterMeanT(1:42,6),clusterMeanT(43:end,6));

text(-90,1,['p=' num2str(round(P1,3)) ])
text(-45,1,['p=' num2str(round(P2,3)) ])
text(1,1,['p=' num2str(round(P3,3)) ])
% text(-90,1,['p=' num2str(round(P4,3)) ])
% text(-45,1,['p=' num2str(round(P5,3)) ])
% text(1,1,['p=' num2str(round(P6,3)) ])

g.export('file_name','ct_cd_hv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')


cl1 = clusterMeanT(:,1);
cl2 = clusterMeanT(:,2);
cl3 = clusterMeanT(:,3);


thisfilename = 'ct_cd_hv';
T = table(subjects(:), cl1, cl2 ,cl3);
T.Properties.VariableNames = {'Subject','Left lingual gyrus','Left mid-temporal gyrus','Left hippocampus'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)




%% HV vs CD

cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/label/

% 
% subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
%     '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
%     '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
%     'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
%     'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034',...
%     '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
%     '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
%     '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
%     '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
%     '001_P45','004_P01',...
%     'sub-003','sub-005', 'sub-006', 'sub-008','sub-011', 'sub-012', 'sub-014',...
%     'sub-021', 'sub-024', 'sub-025', 'sub-033','sub-032','sub-038'};

subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
    '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
    '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
    'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
    'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034',...
    '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
    '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-012', 'sub-024', 'sub-038',...
    'sub-011', 'sub-014', 'sub-021', 'sub-025','sub-032','sub-033'};

m = gifti('HV_CD_cluster_mask.gii'); % this is manually derived cluster mask from SPM
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

%%
numHV_gita = 34;
numHV_jord = 8;
numPA_gita = 34;
numPA_jord = 13;
numFat = 7;
numNFat = 6;

numHV = 42;
numCD = 34;
numCDR = 13;

myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
myGroupC = [repmat({'HV_gita'},numHV_gita,1); repmat({'HV_jord'},numHV_jord,1); repmat({'Active'},numPA_gita,1); ...
    repmat({'Fatigued'},numFat,1); repmat({'Non-Fatigued'},numNFat,1);];

% mycamp = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0];
% mycamp = mycamp./256;
% 
% numHV = 42;
% numCD = 34;
% numCDR = 13;
% 
% myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
% myGroupC = [repmat({'HV'},numHV,1); repmat({'CD_Active'},numCD,1); repmat({'CD_Remission'},numCDR,1)];

% cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_CT/
% 
% load('CD_HV_mdata.mat');
%regionName = 'lcaudate';

clusterMeanT = transpose(clusterMean);
%
%figure('Position',[100 100 1400 800])
figure
clear g

g = gramm('x',myGroup,'y',clusterMeanT(:,1));
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','Left precentral gyrus (mm)')
g.set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])


g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g.set_color_options('map',mycamp)

g.draw()


[H,P1,CI,STATS] = ttest2(clusterMeanT(1:42,1),clusterMeanT(43:end,1));

text(1,1,['p=' num2str(round(P1,3)) ])


g.export('file_name','ct_hv_cd', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

cl1 = clusterMeanT(:,1);

thisfilename = 'ct_hv_cd';
T = table(subjects(:), cl1);
T.Properties.VariableNames = {'Subject','Left precentral gyrus',};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)















