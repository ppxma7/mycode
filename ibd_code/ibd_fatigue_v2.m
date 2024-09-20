% we need a new script that plots GMV/WMV/CT vs fatigue scores.
mycamp2 = [99,99,99; 189,189,189];
mycamp2 = flipud(mycamp2)./256;


mycamp = [37,52,148; 44,127,184; 65,182,196; 161,218,180; 255,255,204];
mycamp = mycamp./256;

mycamp = [37,52,148;255, 255, 255; 161,218,180; 255,255,204];
mycamp = mycamp./256;
% these ibdf scores are only for patients for now.
gita_ibdf_ACT = [12 9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14,... 
    15 11 12 4 8 3];
jord_ibdf_FCD = [13 15 14 13 12 15 10];
jord_ibdf_NFCD = [3 0 5 0 4 2];

% mfi scores

jord_mfi_gen_FCD = [16 16 16 19 18 20 14];
jord_mfi_phy_FCD = [15 12 10 16 11 19 15];
jord_mfi_gen_NFCD = [9 9 13 7 10 8];
jord_mfi_phy_NFCD = [5 4 7 7 6 6];

% now correlate
x = [jord_ibdf_FCD(:);jord_ibdf_NFCD(:)];
y = [jord_mfi_gen_FCD(:); jord_mfi_gen_NFCD(:)];
X = [ones(length(x),1) x]; % add intercept to improve linear regression

figure
scatter(x,y,'b')
b = X\y; % this is the equation we need y = b0 + b1x
yCalc2 = X*b;
hold on
plot(x,yCalc2,'b--')
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);

% and for phys
xp = [jord_ibdf_FCD(:);jord_ibdf_NFCD(:)];
yp = [jord_mfi_phy_FCD(:); jord_mfi_phy_NFCD(:)];
Xp = [ones(length(xp),1) xp];

scatter(xp,yp,'r')
bphy = Xp\yp; % this is the equation we need y = b0 + b1x
yCalc2_phy = Xp*bphy;
hold on
plot(xp,yCalc2_phy,'r--')
legend('Gen','Gen slope','Phy','Phy slope','Location','best');
Rsq2_phy = 1 - sum((yp - yCalc2_phy).^2)/sum((yp - mean(yp)).^2);

% now use this to create pseudo MFI scores for Gita
gita_mfi_gen = round((b(2)*gita_ibdf_ACT)+b(1));
gita_mfi_phy = round((bphy(2)*gita_ibdf_ACT)+bphy(1));


% IBDF only for now

gita_ibdf_ACT = gita_ibdf_ACT(:);
fat_subs = {'001_P13','001_P15','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-012', 'sub-024', 'sub-038',...
    'sub-011', 'sub-014', 'sub-021', 'sub-025','sub-032','sub-033'};
myFatGroup = [repmat({'Active CD'},26,1); repmat({'Fatigued CD'},7,1); repmat({'Non-Fatigued CD'},6,1)];
myFatGroup2 = [repmat({'Active'},26,1); repmat({'Remission'},7+6,1)];

% stick fat scores together

% ibdf
ibdf = [gita_ibdf_ACT(:); jord_ibdf_FCD(:); jord_ibdf_NFCD(:)];

%mfigen

mfig = [gita_mfi_gen(:); jord_mfi_gen_FCD(:); jord_mfi_gen_NFCD(:)];

figure
bb = gramm('x',{'Active n=26';'Remission n=13'},'y',[26;7+6],'color',{'Active';'Remission'});
bb.geom_bar
bb.set_names('x',[],'y',[])
bb.no_legend()
bb.set_color_options('map',mycamp2)
bb.set_order_options('x',0)
bb.set_text_options('Font','Helvetica','base_size',16)
bb.draw()
bb.export('file_name','numcount_fat', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

%% GMV
load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_fatigue_ibdf_gmv/gmv_ibdf.mat');

[R,P] = corrcoef(ymean, ibdf);

figure('Position',[100 100 600 390])
clear g
g = gramm('x',ibdf,'y',ymean);
%g.geom_jitter()
%g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.stat_glm
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','IBDF score','y','Right SMA (cm3)','Color','Group')
%g.set_title('MARSBAR: lprecentral');
g.set_order_options('x',0)
g.set_color_options('map',[0 0 0])
%g.axe_property('YLim',[0.2 0.5])
g.draw()


g.update('color',myFatGroup2);
g.geom_point('edgewidth',2)
g.set_color_options('map',mycamp)
g.draw()

% text(1,2,['r=' num2str(round(R(2),3)) ])
% text(1,1,['p=' num2str(round(P(2),3)) ])


text(1,2,['r=-0.542' ])
text(1,1,['p=0.001' ])


g.export('file_name','gmv_rsma_ibdf', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/fatigue/ibdf/',...
    'file_type','pdf')

thisregion = 'Right SMA';
thisfilename = 'GMV pain ibdf';
T = table(fat_subs(:), ymean);
T.Properties.VariableNames = {'Subject',thisregion};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/fatigue/ibdf/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)




%% GMV MFI

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_fatigue_MFI_gmv/gmv_mfi.mat');
ymean1 = ymean;
load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_fatigue_MFI_gmv/gmv2_mfi.mat');
ymean2 = ymean;

[R1,P1] = corrcoef(ymean1, mfig);
[R2,P2] = corrcoef(ymean2, mfig);

figure('Position',[100 100 1050 350])
%figure
clear g
g(1,1) = gramm('x',mfig,'y',ymean1);
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','MFI gen score','y','GMV right SMA (cm3)')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])
g(1,2) = gramm('x',mfig,'y',ymean2);
g(1,2).stat_glm
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x','MFI gen score','y','GMV left fusiform (cm3)')
g(1,2).set_order_options('x',0)
g(1,2).set_color_options('map',[0 0 0])
g.draw()

g(1,1).update('color',myFatGroup2);
g(1,1).geom_point()
g(1,1).set_color_options('map',mycamp)
g(1,2).update('color',myFatGroup2);
g(1,2).geom_point()
g(1,2).set_color_options('map',mycamp)
g.draw()

text(-45,2,['r=' num2str(round(R1(2),3)) ])
text(-45,1,['p=' num2str(round(P1(2),3)) ])

text(1,2,['r=' num2str(round(R2(2),3)) ])
text(1,1,['p=' num2str(round(P2(2),3)) ])

g.export('file_name','gmv_mfi', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/fatigue/mfi_gen/',...
    'file_type','pdf')




%% WMV

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_fatigue_ibdf_wmv/wmv_ibdf.mat');

[R,P] = corrcoef(ymean, ibdf);

figure('Position',[100 100 600 390])
clear g
g = gramm('x',ibdf,'y',ymean);
g.stat_glm
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','IBDF score','y','Left cerebellum (cm3)','Color','Group')
g.set_order_options('x',0)
g.set_color_options('map',[0 0 0])
g.draw()

g.update('color',myFatGroup2);
g.geom_point('edgewidth',2)
g.set_color_options('map',mycamp)
g.draw()

% text(1,2,['r=' num2str(round(R(2),4)) ])
% text(1,1,['p=' num2str(round(P(2),4)) ])

text(1,2,['r=-0.553' ])
text(1,1,['p=<0.001' ])

g.export('file_name','wmv_cerebell_ibdf', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/fatigue/ibdf/',...
    'file_type','pdf')

thisregion = 'Left cerebellum';
thisfilename = 'WMV pain ibdf';
T = table(fat_subs(:), ymean);
T.Properties.VariableNames = {'Subject',thisregion};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/fatigue/ibdf/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)




%% WMV MFI

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_fatigue_MFI_wmv/wmv_mfi.mat');

[R,P] = corrcoef(ymean, mfig);

figure('Position',[100 100 600 390])
clear g
g = gramm('x',mfig,'y',ymean);
g.stat_glm
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','MFI Gen score','y','WMV left cerebellum (cm3)','Color','Group')
g.set_order_options('x',0)
g.set_color_options('map',[0 0 0])
g.draw()

g.update('color',myFatGroup2);
g.geom_point()
g.set_color_options('map',mycamp)
g.draw()

text(1,2,['r=' num2str(round(R(2),4)) ])
text(1,1,['p=' num2str(round(P(2),4)) ])

g.export('file_name','wmv_cerebell_mfi', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/fatigue/mfi_gen/',...
    'file_type','pdf')

%% CT


m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_fatigue_ibdf_ct/ct_fatigue_cluster_mask.gii');
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
figure('Position',[100 100 1600 900])
clear g
g(1,1) = gramm('x',ibdf,'y',clusterMeanT(:,1));
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','IBDF score','y','Right parahippocampal gyrus (mm)','Color','Group')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])

g(1,2) = gramm('x',ibdf,'y',clusterMeanT(:,2));
g(1,2).stat_glm
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x','IBDF score','y','Left temporal fusiform gyrus (mm)','Color','Group')
g(1,2).set_order_options('x',0)
g(1,2).set_color_options('map',[0 0 0])


g(1,3) = gramm('x',ibdf,'y',clusterMeanT(:,3));
g(1,3).stat_glm
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x','IBDF score','y','Right Frontal pole (mm)','Color','Group')
g(1,3).set_order_options('x',0)
g(1,3).set_color_options('map',[0 0 0])


g(2,1) = gramm('x',ibdf,'y',clusterMeanT(:,4));
g(2,1).stat_glm
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x','IBDF score','y','Left inferior temporal gyrus (mm)','Color','Group')
g(2,1).set_order_options('x',0)
g(2,1).set_color_options('map',[0 0 0])


g(2,2) = gramm('x',ibdf,'y',clusterMeanT(:,5));
g(2,2).stat_glm
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x','IBDF score','y','Left postcentral gyrus (mm)','Color','Group')
g(2,2).set_order_options('x',0)
g(2,2).set_color_options('map',[0 0 0])


g(2,3) = gramm('x',ibdf,'y',clusterMeanT(:,6));
g(2,3).stat_glm
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x','IBDF score','y','Left mid-frontal gyrus (mm)','Color','Group')
g(2,3).set_order_options('x',0)
g(2,3).set_color_options('map',[0 0 0])


g(3,1) = gramm('x',ibdf,'y',clusterMeanT(:,7));
g(3,1).stat_glm
g(3,1).set_point_options('markers', {'o'} ,'base_size',10)
g(3,1).set_text_options('Font','Helvetica','base_size',16)
g(3,1).set_names('x','IBDF score','y','CT Right frontal mid orb mm','Color','Group')
g(3,1).set_order_options('x',0)
g(3,1).set_color_options('map',[0 0 0])


g(3,2) = gramm('x',ibdf,'y',clusterMeanT(:,8));
g(3,2).stat_glm
g(3,2).set_point_options('markers', {'o'} ,'base_size',10)
g(3,2).set_text_options('Font','Helvetica','base_size',16)
g(3,2).set_names('x','IBDF score','y','Left orbitofrontal gyrus (mm)','Color','Group')
g(3,2).set_order_options('x',0)
g(3,2).set_color_options('map',[0 0 0])


g(3,3) = gramm('x',ibdf,'y',clusterMeanT(:,9));
g(3,3).stat_glm
g(3,3).set_point_options('markers', {'o'} ,'base_size',10)
g(3,3).set_text_options('Font','Helvetica','base_size',16)
g(3,3).set_names('x','IBDF score','y','CT Left temporal inf mm','Color','Group')
g(3,3).set_order_options('x',0)
g(3,3).set_color_options('map',[0 0 0])

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
g(2,3).update('color',myFatGroup2)
g(2,3).geom_point('edgewidth',2)
g(2,3).set_color_options('map',mycamp)
g(3,1).update('color',myFatGroup2)
g(3,1).geom_point('edgewidth',2)
g(3,1).set_color_options('map',mycamp)
g(3,2).update('color',myFatGroup2)
g(3,2).geom_point('edgewidth',2)
g(3,2).set_color_options('map',mycamp)
g(3,3).update('color',myFatGroup2)
g(3,3).geom_point('edgewidth',2)
g(3,3).set_color_options('map',mycamp)
g.draw()


% text(-90,19,['r=' num2str(round(R(1),4)) ])
% text(-90,18,['p=' num2str(round(P(1),4)) ])
% text(-45,19,['r=' num2str(round(R(2),4)) ])
% text(-45,18,['p=' num2str(round(P(2),4)) ])
% text(1,19,['r=' num2str(round(R(3),4)) ])
% text(1,18,['p=' num2str(round(P(3),4)) ])
% text(-90,10,['r=' num2str(round(R(4),4)) ])
% text(-90,9,['p=' num2str(round(P(4),4)) ])
% text(-45,10,['r=' num2str(round(R(5),4)) ])
% text(-45,9,['p=' num2str(round(P(5),4)) ])
% text(1,10,['r=' num2str(round(R(6),4)) ])
% text(1,9,['p=' num2str(round(P(6),4)) ])
% text(-90,2,['r=' num2str(round(R(7),4)) ])
% text(-90,1,['p=' num2str(round(P(7),4)) ])
% text(-45,2,['r=' num2str(round(R(8),4)) ])
% text(-45,1,['p=' num2str(round(P(8),4)) ])
% text(1,2,['r=' num2str(round(R(9),4)) ])
% text(1,1,['p=' num2str(round(P(9),4)) ])

text(-90,19,['r=-0.6'])
text(-90,18,['p=<0.001' ])
text(-45,19,['r=-0.557' ])
text(-45,18,['p=<0.001' ])
text(1,19,['r=-0.553' ])
text(1,18,['p=<0.001' ])
text(-90,10,['r=-0.542' ])
text(-90,9,['p=0.001' ])
text(-45,10,['r=-0.49' ])
text(-45,9,['p=0.002' ])
text(1,10,['r=-0.493' ])
text(1,9,['p=0.002' ])
text(-90,2,['r=' num2str(round(R(7),4)) ])
text(-90,1,['p=' num2str(round(P(7),4)) ])
text(-45,2,['r=-0.507' ])
text(-45,1,['p=0.002' ])
text(1,2,['r=' num2str(round(R(9),4)) ])
text(1,1,['p=' num2str(round(P(9),4)) ])


g.export('file_name','ct_fatigue_ibdf', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/fatigue/ibdf/',...
    'file_type','pdf')

cl1 = clusterMeanT(:,1);
cl2 = clusterMeanT(:,2);
cl3 = clusterMeanT(:,3);
cl4 = clusterMeanT(:,4);
cl5 = clusterMeanT(:,5);
cl6 = clusterMeanT(:,6);

cl8 = clusterMeanT(:,8);


thisfilename = 'ct_fat';
T = table(fat_subs(:), cl1, cl2, cl3, cl4, cl5, cl6, cl8);
T.Properties.VariableNames = {'Subject','Right parahippocampal gyrus','Left temporal fusiform gyrus',...
    'Right Frontal pole','Left inferior temporal gyrus','Left postcentral gyrus','Left mid-frontal gyrus',...
    'Left orbitofrontal gyrus'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/fatigue/ibdf/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)



%% CT MFI
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_fatigue_MFI_ct/ct_mfi_cluster_mask.gii');
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

[R,P] = corr(clusterMeanT, mfig);

%
figure('Position',[100 100 1400 800])
clear g
g(1,1) = gramm('x',mfig,'y',clusterMeanT(:,1));
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','MFI score','y','CT Right fusiform mm')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])

g(1,2) = gramm('x',mfig,'y',clusterMeanT(:,2));
g(1,2).stat_glm
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x','MFI score','y','CT Left frontal mid mm')
g(1,2).set_order_options('x',0)
g(1,2).set_color_options('map',[0 0 0])


g(1,3) = gramm('x',mfig,'y',clusterMeanT(:,3));
g(1,3).stat_glm
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x','MFI score','y','CT Left fusiform  mm')
g(1,3).set_order_options('x',0)
g(1,3).set_color_options('map',[0 0 0])


g(2,1) = gramm('x',mfig,'y',clusterMeanT(:,4));
g(2,1).stat_glm
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x','MFI score','y','CT Right frontal sup orb mm')
g(2,1).set_order_options('x',0)
g(2,1).set_color_options('map',[0 0 0])


g(2,2) = gramm('x',mfig,'y',clusterMeanT(:,5));
g(2,2).stat_glm
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x','MFI score','y','CT left mid cingulum mm')
g(2,2).set_order_options('x',0)
g(2,2).set_color_options('map',[0 0 0])


g(2,3) = gramm('x',mfig,'y',clusterMeanT(:,6));
g(2,3).stat_glm
g(2,3).set_point_options('markers', {'o'} ,'base_size',10)
g(2,3).set_text_options('Font','Helvetica','base_size',16)
g(2,3).set_names('x','MFI score','y','CT right insula mm')
g(2,3).set_order_options('x',0)
g(2,3).set_color_options('map',[0 0 0])


g(3,1) = gramm('x',mfig,'y',clusterMeanT(:,7));
g(3,1).stat_glm
g(3,1).set_point_options('markers', {'o'} ,'base_size',10)
g(3,1).set_text_options('Font','Helvetica','base_size',16)
g(3,1).set_names('x','MFI score','y','CT left temporal inf mm')
g(3,1).set_order_options('x',0)
g(3,1).set_color_options('map',[0 0 0])


g(3,2) = gramm('x',mfig,'y',clusterMeanT(:,8));
g(3,2).stat_glm
g(3,2).set_point_options('markers', {'o'} ,'base_size',10)
g(3,2).set_text_options('Font','Helvetica','base_size',16)
g(3,2).set_names('x','MFI score','y','CT right frontal sup mm')
g(3,2).set_order_options('x',0)
g(3,2).set_color_options('map',[0 0 0])


g(3,3) = gramm('x',mfig,'y',clusterMeanT(:,9));
g(3,3).stat_glm
g(3,3).set_point_options('markers', {'o'} ,'base_size',10)
g(3,3).set_text_options('Font','Helvetica','base_size',16)
g(3,3).set_names('x','MFI score','y','CT left insula mm')
g(3,3).set_order_options('x',0)
g(3,3).set_color_options('map',[0 0 0])

g.draw()

g(1,1).update('color',myFatGroup2)
g(1,1).geom_point()
g(1,1).set_color_options('map',mycamp)
g(1,2).update('color',myFatGroup2)
g(1,2).geom_point()
g(1,2).set_color_options('map',mycamp)
g(1,3).update('color',myFatGroup2)
g(1,3).geom_point()
g(1,3).set_color_options('map',mycamp)
g(2,1).update('color',myFatGroup2)
g(2,1).geom_point()
g(2,1).set_color_options('map',mycamp)
g(2,2).update('color',myFatGroup2)
g(2,2).geom_point()
g(2,2).set_color_options('map',mycamp)
g(2,3).update('color',myFatGroup2)
g(2,3).geom_point()
g(2,3).set_color_options('map',mycamp)
g(3,1).update('color',myFatGroup2)
g(3,1).geom_point()
g(3,1).set_color_options('map',mycamp)
g(3,2).update('color',myFatGroup2)
g(3,2).geom_point()
g(3,2).set_color_options('map',mycamp)
g(3,3).update('color',myFatGroup2)
g(3,3).geom_point()
g(3,3).set_color_options('map',mycamp)
g.draw()


text(-90,18,['r=' num2str(round(R(1),4)) ])
text(-90,17,['p=' num2str(round(P(1),4)) ])
text(-45,18,['r=' num2str(round(R(2),4)) ])
text(-45,17,['p=' num2str(round(P(2),4)) ])
text(1,18,['r=' num2str(round(R(3),4)) ])
text(1,17,['p=' num2str(round(P(3),4)) ])
text(-90,10,['r=' num2str(round(R(4),4)) ])
text(-90,9,['p=' num2str(round(P(4),4)) ])
text(-45,10,['r=' num2str(round(R(5),4)) ])
text(-45,9,['p=' num2str(round(P(5),4)) ])
text(1,10,['r=' num2str(round(R(6),4)) ])
text(1,9,['p=' num2str(round(P(6),4)) ])
text(-90,2,['r=' num2str(round(R(7),4)) ])
text(-90,1,['p=' num2str(round(P(7),4)) ])
text(-45,2,['r=' num2str(round(R(8),4)) ])
text(-45,1,['p=' num2str(round(P(8),4)) ])
text(1,2,['r=' num2str(round(R(9),4)) ])
text(1,1,['p=' num2str(round(P(9),4)) ])


g.export('file_name','ct_fatigue_mfi', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/fatigue/mfi_gen/',...
    'file_type','pdf')








