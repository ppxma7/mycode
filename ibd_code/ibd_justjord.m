%% GMV
% HV vs CD
subjects = {'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034',...
    'sub-041','sub-043','sub-044','sub-045',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-012', 'sub-024', 'sub-038','sub-037','sub-040',...
    'sub-011', 'sub-014', 'sub-021', 'sub-025','sub-032','sub-033'};

fat_subs = {'sub-003','sub-005', 'sub-006', 'sub-008','sub-012', 'sub-024', 'sub-038','sub-037','sub-040',...
    'sub-011', 'sub-014', 'sub-021', 'sub-025','sub-032','sub-033'};


sex = [0 1 0 0 1 1 0 0 0 0 1 1 ...
    0 0 1 1 0 1 0 0 1 1 0 1 0 0 1];

age = [26 60 27 30 48 48 32 23 58 39 32 27 ...
    31 33 52 26 44 62 58 26 60 54 53 23 25 54 26];

% mycamp = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0];
% mycamp = mycamp./256;

mycamp = [37,52,148; 44,127,184; 65,182,196; 161,218,180; 255,255,204];
mycamp = mycamp./256;

mycamp = [37,52,148; 44,127,184; 255, 255, 255; 161,218,180; 255,255,204];
mycamp = mycamp./256;


mycamp2 = [99,99,99; 189,189,189];
mycamp2 = mycamp2./256;


numHV = 12;
numCD = 15;

numFat = 9;
numNFat = 6;

% myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
% myGroupC = [repmat({'HV'},numHV,1); repmat({'Active'},numCD,1); repmat({'Remission'},numCDR,1)];
myGroup = [repmat({'HC'},numHV,1); repmat({'CD'},numCD,1)];

myGroupD = [repmat({'HV'},numHV,1); ...
    repmat({'Fatigued CD'},numFat,1); repmat({'Non-Fatigued CD'},numNFat,1);];
%myGroupD = [repmat({'HC'},numHV,1); repmat({'Active'},numCD,1); repmat({'Remission'},numCDR,1)];
myFatGroup2 = [repmat({'Fatigued CD'},numFat,1); repmat({'Non-Fatigued CD'},numNFat,1)];

jord_ibdf_FCD = [13 15 14 13 12 15 10 10 11];
jord_ibdf_NFCD = [3 0 5 0 4 2];

ibdf = [ jord_ibdf_FCD(:); jord_ibdf_NFCD(:)];


%%
figure
bb = gramm('x',{'HC n=12';'CD n=15'},'y',[numHV;numCD],'color',{'HC';'CD'});
bb.geom_bar
bb.set_names('x',[],'y',[])
bb.no_legend()
bb.set_color_options('map',mycamp2)
bb.set_order_options('x',0)
bb.set_text_options('Font','Helvetica','base_size',16)
bb.draw()
bb.export('file_name','numcount_vbm', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')

%% GMV CD > HV
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_gmv/

load('cdgmv.mat');

figure('Position',[100 100 1000 800])
clear g

g(1,1) = gramm('x',myGroup,'y',ymean_1056);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Right precuneus (cm^3)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(1,2) = gramm('x',myGroup,'y',ymean_136);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Brain stem (cm3)')
g(1,2).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(1,3) = gramm('x',myGroup,'y',ymean_2094);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Left angular gyrus (cm3)')
g(1,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(2,1) = gramm('x',myGroup,'y',ymean_2802);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Left cerebral WM (cm3)')
g(2,1).set_order_options('x',0)

g(2,2) = gramm('x',myGroup,'y',ymean_326);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Right cerebral WM (cm3)')
g(2,2).set_order_options('x',0)

g(2,3) = gramm('x',myGroup,'y',ymean_386);
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','Left cerebral WM (subcluster) (cm3)')
g(2,3).set_order_options('x',0)

g(3,1) = gramm('x',myGroup,'y',ymean_509);
g(3,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,1).set_point_options('markers', {'o'} ,'base_size',10)
g(3,1).set_text_options('Font','Helvetica','base_size',16)
g(3,1).set_names('x',[],'y','Left cerebral WM (cm3)')
g(3,1).set_order_options('x',0)

g(3,2) = gramm('x',myGroup,'y',ymean_687);
g(3,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,2).set_point_options('markers', {'o'} ,'base_size',10)
g(3,2).set_text_options('Font','Helvetica','base_size',16)
g(3,2).set_names('x',[],'y','Left Lat. Occ. Cortex (cm3)')
g(3,2).set_order_options('x',0)

g(3,3) = gramm('x',myGroup,'y',ymean_915);
g(3,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,3).set_point_options('markers', {'o'} ,'base_size',10)
g(3,3).set_text_options('Font','Helvetica','base_size',16)
g(3,3).set_names('x',[],'y','Right cerebral WM (subcluster) (cm3)')
g(3,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,2).update('color',myGroupD)
g(2,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,3).update('color',myGroupD)
g(2,3).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,1).update('color',myGroupD)
g(3,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,2).update('color',myGroupD)
g(3,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,3).update('color',myGroupD)
g(3,3).geom_jitter('alpha',0.8,'edgewidth',2)

g.set_color_options('map',mycamp)
%g.set_order_options('color',-1)
g.axe_property('PlotBoxAspectRatio',[1 1 1]);
g.draw()

[H,P1,CI,STATS] = ttest2(ymean_1056(1:numHV), ymean_1056(numHV+1:end));
[H,P2,CI,STATS] = ttest2(ymean_136(1:numHV), ymean_136(numHV+1:end));
[H,P3,CI,STATS] = ttest2(ymean_2094(1:numHV), ymean_2094(numHV+1:end));
[H,P4,CI,STATS] = ttest2(ymean_2802(1:numHV), ymean_2802(numHV+1:end));
[H,P5,CI,STATS] = ttest2(ymean_326(1:numHV), ymean_326(numHV+1:end));
[H,P6,CI,STATS] = ttest2(ymean_386(1:numHV), ymean_386(numHV+1:end));
[H,P7,CI,STATS] = ttest2(ymean_509(1:numHV), ymean_509(numHV+1:end));
[H,P8,CI,STATS] = ttest2(ymean_687(1:numHV), ymean_687(numHV+1:end));
[H,P9,CI,STATS] = ttest2(ymean_915(1:numHV), ymean_915(numHV+1:end));


text(-90,17,['p=' num2str(round(P1,3)) ])
text(-45,17,['p=' num2str(round(P2,3)) ])
text(1,17,['p=' num2str(round(P3,3)) ])
text(-90,9,['p=' num2str(round(P4,3)) ])
text(-45,9,['p=' num2str(round(P5,3)) ])
text(1,9,['p=' num2str(round(P6,3)) ])
text(-90,1,['p=' num2str(round(P7,3)) ])
text(-45,1,['p=' num2str(round(P8,3)) ])
text(1,1,['p=' num2str(round(P9,3)) ])

g.export('file_name','gmv_cd_hv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')
% 
% thisregion = {'Parietal operculum cortex','Left cingulate gyrus','Superior frontal gyrus',...
%     'Lateral occipital cortex','Left planum polare','Right orbital frontal cortex'};
% thisfilename = 'GMV cd_hv';
% T = table(subjects(:), ymean_230, ymean_444, ymean_799, ymean_829, ymean_2237, ymean_5782);
% T.Properties.VariableNames = {'Subject','Parietal operculum cortex','Left cingulate gyrus','Superior frontal gyrus',...
%     'Lateral occipital cortex','Left planum polare','Right orbital frontal cortex'};
% writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)
% 

%% WMV CD>HV
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_wmv/

load('cdwmv.mat');

figure('Position',[100 100 1000 800])
clear g

g(1,1) = gramm('x',myGroup,'y',ymean_130);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left postcentral gyrus (cm^3)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(1,2) = gramm('x',myGroup,'y',ymean_1380);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Subcallosal cortex (cm3)')
g(1,2).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(1,3) = gramm('x',myGroup,'y',ymean_139);
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Left angular gyrus (cm3)')
g(1,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])



g(2,1) = gramm('x',myGroup,'y',ymean_140);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Left temporal pole (cm3)')
g(2,1).set_order_options('x',0)

g(2,2) = gramm('x',myGroup,'y',ymean_145);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Left Sup. Parietal lobule (cm3)')
g(2,2).set_order_options('x',0)

g(2,3) = gramm('x',myGroup,'y',ymean_155);
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','Left superior frontal gyrus (cm3)')
g(2,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])


g(3,1) = gramm('x',myGroup,'y',ymean_156);
g(3,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,1).set_point_options('markers', {'o'} ,'base_size',10)
g(3,1).set_text_options('Font','Helvetica','base_size',16)
g(3,1).set_names('x',[],'y','Right lingual gyrus (cm3)')
g(3,1).set_order_options('x',0)

g(3,2) = gramm('x',myGroup,'y',ymean_181);
g(3,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,2).set_point_options('markers', {'o'} ,'base_size',10)
g(3,2).set_text_options('Font','Helvetica','base_size',16)
g(3,2).set_names('x',[],'y','Left precentral gyrus (subcluster) (cm3)')
g(3,2).set_order_options('x',0)

g(3,3) = gramm('x',myGroup,'y',ymean_518);
g(3,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,3).set_point_options('markers', {'o'} ,'base_size',10)
g(3,3).set_text_options('Font','Helvetica','base_size',16)
g(3,3).set_names('x',[],'y','Right precuneus (cm3)')
g(3,3).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])


g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8,'edgewidth',2)
% g(1,4).update('color',myGroupD)
% g(1,4).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,2).update('color',myGroupD)
g(2,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,3).update('color',myGroupD)
g(2,3).geom_jitter('alpha',0.8,'edgewidth',2)
% g(2,4).update('color',myGroupD)
% g(2,4).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,1).update('color',myGroupD)
g(3,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,2).update('color',myGroupD)
g(3,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,3).update('color',myGroupD)
g(3,3).geom_jitter('alpha',0.8,'edgewidth',2)
% g(3,4).update('color',myGroupD)
% g(3,4).geom_jitter('alpha',0.8,'edgewidth',2)
% g(4,1).update('color',myGroupD)
% g(4,1).geom_jitter('alpha',0.8,'edgewidth',2)

g.set_color_options('map',mycamp)
%g.set_order_options('color',-1)
g.axe_property('PlotBoxAspectRatio',[1 1 1]);
g.draw()

[H,P1,CI,STATS] = ttest2(ymean_130(1:numHV), ymean_130(numHV+1:end));
[H,P2,CI,STATS] = ttest2(ymean_1380(1:numHV), ymean_1380(numHV+1:end));
[H,P3,CI,STATS] = ttest2(ymean_139(1:numHV), ymean_139(numHV+1:end));
[H,P4,CI,STATS] = ttest2(ymean_140(1:numHV), ymean_140(numHV+1:end));
[H,P5,CI,STATS] = ttest2(ymean_145(1:numHV), ymean_145(numHV+1:end));
[H,P6,CI,STATS] = ttest2(ymean_155(1:numHV), ymean_155(numHV+1:end));
[H,P7,CI,STATS] = ttest2(ymean_156(1:numHV), ymean_156(numHV+1:end));
[H,P8,CI,STATS] = ttest2(ymean_181(1:numHV), ymean_181(numHV+1:end));
[H,P9,CI,STATS] = ttest2(ymean_518(1:numHV), ymean_518(numHV+1:end));


text(-90,17,['p=' num2str(round(P1,3)) ])
text(-45,17,['p=' num2str(round(P2,3)) ])
text(1,17,['p=' num2str(round(P3,3)) ])
text(-90,9,['p=' num2str(round(P4,3)) ])
text(-45,9,['p=' num2str(round(P5,3)) ])
text(1,9,['p=' num2str(round(P6,3)) ])
text(-90,1,['p=' num2str(round(P7,3)) ])
text(-45,1,['p=' num2str(round(P8,3)) ])
text(1,1,['p=' num2str(round(P9,3)) ])


g.export('file_name','wmv_cd_hv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')
% 
%% CT (CD vs HV)


cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_ct/

m = gifti('CDdec.gii'); % this is manually derived cluster mask from SPM
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

figure('Position',[100 100 1000 800])
clear g

g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Right supramarginal gyrus (mm)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])c

g(1,2) = gramm('x',myGroup,'y',clusterMeanT(:,2));
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Left lingual gyrus (mm)')
g(1,2).set_order_options('x',0)

g(1,3) = gramm('x',myGroup,'y',clusterMeanT(:,3));
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','Left precuneus (mm)')
g(1,3).set_order_options('x',0)

g(2,1) = gramm('x',myGroup,'y',clusterMeanT(:,4));
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Left precuneus (subcluster) (mm)')
g(2,1).set_order_options('x',0)

g(2,2) = gramm('x',myGroup,'y',clusterMeanT(:,5));
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Left cingulate (mm)')
g(2,2).set_order_options('x',0)

g(2,3) = gramm('x',myGroup,'y',clusterMeanT(:,6));
g(2,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x',[],'y','Left Sup. Parietal lobule (mm)')
g(2,3).set_order_options('x',0)

g(3,1) = gramm('x',myGroup,'y',clusterMeanT(:,7));
g(3,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,1).set_point_options('markers', {'o'} ,'base_size',10)
g(3,1).set_text_options('Font','Helvetica','base_size',16)
g(3,1).set_names('x',[],'y','Right frontal orbital cortex (mm)')
g(3,1).set_order_options('x',0)

g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8)
g(2,2).update('color',myGroupD)
g(2,2).geom_jitter('alpha',0.8)
g(2,3).update('color',myGroupD)
g(2,3).geom_jitter('alpha',0.8)
g(3,1).update('color',myGroupD)
g(3,1).geom_jitter('alpha',0.8)
% g(2,3).update('color',myGroupC)
% g(2,3).geom_jitter('alpha',0.8)
g.set_color_options('map',mycamp)

g.draw()

[H,P1,CI,STATS] = ttest2(clusterMeanT(1:numHV,1), clusterMeanT(numHV:end,1));
[H,P2,CI,STATS] = ttest2(clusterMeanT(1:numHV,2), clusterMeanT(numHV:end,2));
[H,P3,CI,STATS] = ttest2(clusterMeanT(1:numHV,3), clusterMeanT(numHV:end,3));
[H,P4,CI,STATS] = ttest2(clusterMeanT(1:numHV,4), clusterMeanT(numHV:end,4));
[H,P5,CI,STATS] = ttest2(clusterMeanT(1:numHV,5), clusterMeanT(numHV:end,5));
[H,P6,CI,STATS] = ttest2(clusterMeanT(1:numHV,6), clusterMeanT(numHV:end,6));
[H,P7,CI,STATS] = ttest2(clusterMeanT(1:numHV,7), clusterMeanT(numHV:end,7));



text(1,17,['p=' num2str(round(P1,3)) ])
text(50,17,['p=' num2str(round(P2,3)) ])
text(100,17,['p=' num2str(round(P3,3)) ])
text(1,9,['p=' num2str(round(P4,3)) ])
text(50,9,['p=' num2str(round(P5,3)) ])
text(100,9,['p=' num2str(round(P6,3)) ])
text(1,1,['p=' num2str(round(P7,3)) ])



g.export('file_name','ct_cd_hv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')


% cl1 = clusterMeanT(:,1);
% cl2 = clusterMeanT(:,2);
% 
% thisfilename = 'ct_cd_hv';
% T = table(subjects(:), cl1, cl2);
% T.Properties.VariableNames = {'Subject','Left lingual gyrus','Left mid-temporal gyrus',};
% writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)
% 
% 
% 
%%%% 
%% CT (HV vs CD)
% 
% 
% cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_ct/
% 
% m = gifti('hvtest.gii'); % this is manually derived cluster mask from SPM
% numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
% sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters
% 
% clusterMean = zeros(numClusters,length(subjects),1); % make space
% mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';
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
% 
% %figure('Position',[100 100 1400 800])
% figure
% clear g
% 
% g(1,1) = gramm('x',myGroup,'y',clusterMeanT(:,1));
% g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
% g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
% g(1,1).set_text_options('Font','Helvetica','base_size',16)
% g(1,1).set_names('x',[],'y','Subcallosal cortex (mm)')
% g(1,1).set_order_options('x',0)
% %g.axe_property('YLim',[0.2 0.5])c
% 
% 
% g.draw()
% 
% 
% g(1,1).update('color',myGroupD)
% g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
% 
% % g(2,3).update('color',myGroupC)
% % g(2,3).geom_jitter('alpha',0.8)
% g.set_color_options('map',mycamp)
% 
% g.draw()
% 
% g.export('file_name','ct_hv_cd', ...
%     'export_path',...
%     '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
%     'file_type','pdf')


%% NOW TRY FATIGUE?

%
load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_fatigue_gmv/gmv_neg_fat.mat');

%[R,P] = corrcoef(ymean_340, ibdf);
% [R2,P2] = corrcoef(ymean_13, ibdf);
% [R3,P3] = corrcoef(ymean_26, ibdf);
% [R4,P4] = corrcoef(ymean_36, ibdf);
% [R5,P5] = corrcoef(ymean_37, ibdf);

%figure('Position',[100 100 1400 600])
%
figure
clear g
g(1,1) = gramm('x',ibdf,'y',ymean_340);
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','IBDF score','y','Right cuneal cortex (cm3)','Color','Group')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])

 
g.draw()


g(1,1).update('color',myFatGroup2)
g(1,1).geom_point('edgewidth',2)
g(1,1).set_color_options('map',mycamp)


g.draw()
[R,P] = corrcoef(ymean_340, ibdf);
text(1,2,['r=' num2str(round(R(2),3)) ])
text(1,1,['p=' num2str(round(P(2),3)) ])
% 
% text(1,1,['r=' num2str(round(R1(2),4)) ])
% text(1,2,['p=' num2str(round(P1(2),4)) ])





g.export('file_name','gmv_ibdf', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')

% thisregion = 'Right SMA';
% thisfilename = 'GMV pain ibdf';
% T = table(fat_subs(:), ymean);
% T.Properties.VariableNames = {'Subject',thisregion};
% writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/fatigue/ibdf/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)


%% WMV FATIGUE
load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_fatigue_wmv/wmv_neg_fat.mat');



%figure('Position',[100 100 1400 600])
figure 
clear g
g(1,1) = gramm('x',ibdf,'y',ymean_40);
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','IBDF score','y','Left cerebellum  (cm3)','Color','Group')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])

g.draw()


g(1,1).update('color',myFatGroup2)
g(1,1).geom_point('edgewidth',2)
g(1,1).set_color_options('map',mycamp)

g.draw() 

[R,P] = corrcoef(ymean_40, ibdf);

text(1,2,['r=' num2str(round(R(2),3)) ])
text(1,1,['p=' num2str(round(P(2),3)) ])

g.export('file_name','wmv_ibdf', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')

%% CT FAT

m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_fatigue_ct/negfat.gii');
%m = gifti('ct_fatigue_cluster_mask.gii'); % this is manually derived cluster mask from SPM
numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters

clusterMean = zeros(numClusters,length(fat_subs),1); % make space
mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';


% takes about a minute for 6 clusters.
tic
for ii = 1:length(fat_subs)
    
    thicBoy = gifti([mypath 's15.mesh.thickness.resampled.m' fat_subs{ii} '.gii']); % all thickness 
    
    for jj = 1:numClusters
        clusterMean(jj,ii) = mean(thicBoy.cdata(find(m.cdata==jj))); % condensed! take the mean thick val in that cluster, loop over subs
    end
end
toc

% cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_CT/
% 
% load('CD_HV_mdata.mat');
%regionName = 'lcaudate';

clusterMeanT = transpose(clusterMean);

[R,P] = corr(clusterMeanT, ibdf);

%%

figure('Position',[100 100 1200 600])
%figure
clear g
g(1,1) = gramm('x',ibdf,'y',clusterMeanT(:,1));
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','IBDF score','y','Right lat. occ. cortex (mm)','Color','Group')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])

g(1,2) = gramm('x',ibdf,'y',clusterMeanT(:,2));
g(1,2).stat_glm
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x','IBDF score','y','Left occ. pole (mm)','Color','Group')
g(1,2).set_order_options('x',0)
g(1,2).set_color_options('map',[0 0 0])


g(1,3) = gramm('x',ibdf,'y',clusterMeanT(:,3));
g(1,3).stat_glm
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x','IBDF score','y','Right Front. orbital cortex (mm)','Color','Group')
g(1,3).set_order_options('x',0)
g(1,3).set_color_options('map',[0 0 0])


g(2,1) = gramm('x',ibdf,'y',clusterMeanT(:,4));
g(2,1).stat_glm
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x','IBDF score','y','Right Front. orbital cortex (mm)','Color','Group')
g(2,1).set_order_options('x',0)
g(2,1).set_color_options('map',[0 0 0])


g(2,2) = gramm('x',ibdf,'y',clusterMeanT(:,5));
g(2,2).stat_glm
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x','IBDF score','y','Right temporal fusiform (mm)','Color','Group')
g(2,2).set_order_options('x',0)
g(2,2).set_color_options('map',[0 0 0])




g.draw()

g(1,1).update('color',myFatGroup2)
g(1,1).geom_point('edgewidth',2)
g(1,1).set_color_options('map',mycamp)
g(1,2).update('color',myFatGroup2)
g(1,2).geom_point('edgewidth',2)
g(1,2).set_color_options('map',mycamp)
g(1,3).update('color',myFatGroup2)
g(1,3).geom_point('edgewidth',2)
g(1,3).set_color_options('map',mycamp)
g(2,1).update('color',myFatGroup2)
g(2,1).geom_point('edgewidth',2)
g(2,1).set_color_options('map',mycamp)
g(2,2).update('color',myFatGroup2)
g(2,2).geom_point('edgewidth',2)
g(2,2).set_color_options('map',mycamp)

g.draw()


text(-45,11,['r=' num2str(round(R(1),3)) ])
text(-45,10,['p=' num2str(round(P(1),3)) ])
text(0,11,['r=' num2str(round(R(2),3)) ])
text(0,10,['p=' num2str(round(P(2),3)) ])
text(50,11,['r=' num2str(round(R(3),3)) ])
text(50,10,['p=' num2str(round(P(3),3)) ])
text(-45,2,['r=' num2str(round(R(4),3)) ])
text(-45,1,['p=' num2str(round(P(4),3)) ])
text(0,2,['r=' num2str(round(R(5),3)) ])
text(0,1,['p=' num2str(round(P(5),3)) ])




g.export('file_name','ct_fatigue_ibdf', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')

% cl1 = clusterMeanT(:,1);
% cl2 = clusterMeanT(:,2);
% cl3 = clusterMeanT(:,3);
% cl4 = clusterMeanT(:,4);
% cl5 = clusterMeanT(:,5);
% cl6 = clusterMeanT(:,6);
% 
% cl8 = clusterMeanT(:,8);

% 
% thisfilename = 'ct_fat';
% T = table(fat_subs(:), cl1, cl2, cl3, cl4, cl5, cl6, cl8);
% T.Properties.VariableNames = {'Subject','Right parahippocampal gyrus','Left temporal fusiform gyrus',...
%     'Right Frontal pole','Left inferior temporal gyrus','Left postcentral gyrus','Left mid-frontal gyrus',...
%     'Left orbitofrontal gyrus'};
% writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/fatigue/ibdf/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)


%%

m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/dec_2021_justjord_fatigue_ct/posfat.gii');
%m = gifti('ct_fatigue_cluster_mask.gii'); % this is manually derived cluster mask from SPM
numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters

clusterMean = zeros(numClusters,length(fat_subs),1); % make space
mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';


% takes about a minute for 6 clusters.
tic
for ii = 1:length(fat_subs)
    
    thicBoy = gifti([mypath 's15.mesh.thickness.resampled.m' fat_subs{ii} '.gii']); % all thickness 
    
    for jj = 1:numClusters
        clusterMean(jj,ii) = mean(thicBoy.cdata(find(m.cdata==jj))); % condensed! take the mean thick val in that cluster, loop over subs
    end
end
toc

% cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_CT/
% 
% load('CD_HV_mdata.mat');
%regionName = 'lcaudate';

clusterMeanT = transpose(clusterMean);

[R,P] = corr(clusterMeanT, ibdf);

%%

%figure('Position',[100 100 1300 600])
figure
clear g
g(1,1) = gramm('x',ibdf,'y',clusterMeanT(:,1));
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','IBDF score','y','Left lingual gyrus (mm)','Color','Group')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])
%g(2,2).set_color_options('map',[0 0 0])




g.draw()

g(1,1).update('color',myFatGroup2)
g(1,1).geom_point('edgewidth',2)
g(1,1).set_color_options('map',mycamp)


g.draw()


text(1,2,['r=' num2str(round(R(1),3)) ])
text(1,1,['p=' num2str(round(P(1),3)) ])


g.export('file_name','ct_fatiguepos_ibdf', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/justjord/',...
    'file_type','pdf')



