%% GMV
% HV vs CD
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

sex = [1 1 0 0 1 0 1 0 0 0 1 0 0 1 1 0 1 1 0 0 1 1 1 1 1 0,...
    1 1 0 0 1 1 1 1 0 1 0 0 1 1 0 0,...
    0 1 1 0 1 1 1 1 1 1 1 1 1 0 1 1 0 0 1 1 0 1 1 0 0 1 0 0 0 0 0 0,...
    1 1 0 0 1 1 0 1 0 1 0 1 0 0 1];

age = [27 25 20 31 32 62 27 28 19 24 31 57 22 25 53 31 51 45 27 41,...
    37 24 35 25 26 20 35 48 42 65 64 23 27 25 26 60 27 30 48 48 32 23,...
    56 18 31 23 35 53 30 20 22 30 44 32 63 20 28 38 67 38 68 25 20 18,...
    41 19 28 25 24 62 32 22 31 24 41 18 31 33 52 26 44 62 58 54 53 23 25 54 26];

% mycamp = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0];
% mycamp = mycamp./256;

mycamp = [37,52,148; 44,127,184; 65,182,196; 161,218,180; 255,255,204];
mycamp = mycamp./256;

mycamp = [37,52,148; 44,127,184; 255, 255, 255; 161,218,180; 255,255,204];
mycamp = mycamp./256;


mycamp2 = [99,99,99; 189,189,189];
mycamp2 = mycamp2./256;


numHV = 42;
numCD = 34;
numCDR = 13;

numHV_gita = 34;
numHV_jord = 8;
numPA_gita = 34;
numPA_jord = 13;
numFat = 7;
numNFat = 6;

% myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
% myGroupC = [repmat({'HV'},numHV,1); repmat({'Active'},numCD,1); repmat({'Remission'},numCDR,1)];
myGroup = [repmat({'HC'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];

myGroupC = [repmat({'HC_gita'},numHV_gita,1); repmat({'HC_jord'},numHV_jord,1); repmat({'Active'},numPA_gita,1); ...
    repmat({'Fatigued'},numFat,1); repmat({'Non-Fatigued'},numNFat,1);];
myGroupD = [repmat({'HC'},numHV,1); repmat({'Active'},numCD,1); repmat({'Remission'},numCDR,1)];

figure
bb = gramm('x',{'HC n=42';'CD n=47'},'y',[numHV;numCD+numCDR],'color',{'HC';'CD'});
bb.geom_bar
bb.set_names('x',[],'y',[])
bb.no_legend()
bb.set_color_options('map',mycamp2)
bb.set_order_options('x',0)
bb.set_text_options('Font','Helvetica','base_size',16)
bb.draw()
bb.export('file_name','numcount_vbm', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

%% 
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg/

load('gmv_hv_cd.mat');

% correct?

y = ymean_56;
X = [age(:) sex(:)];
mld = fitlm(X,y);

x1 = mld.Coefficients.Estimate(1);
x2 = mld.Coefficients.Estimate(2); % estimate(1) is the intercept
x3 = mld.Coefficients.Estimate(3);

ymean_56 = x1 + x2.*X(:,1) +x3.*X(:,2); 


%regionName = 'lprecentral';

figure
clear g
g = gramm('x',myGroup,'y',ymean_56);
%g.geom_jitter()
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','Left precentral gyrus (cm3)','color','Group')
%g.set_title('MARSBAR: lprecentral');
g.set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()


g.update('color',myGroupD)
g.geom_jitter('alpha',0.8,'edgewidth',2)
g.set_color_options('map',mycamp)

%g.axe_property('PlotBoxAspectRatio',[1 1 1]);
g.draw()


[H,P,CI,STATS] = ttest2(ymean_56(1:42),ymean_56(43:end));

text(1,1,['p=' num2str(round(P,3)) ])

g.export('file_name','gmv_lprecentral', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

thisregion = 'Left precentral gyrus';
thisfilename = 'GMV hv_cd';
T = table(subjects(:), ymean_56);
T.Properties.VariableNames = {'Subject',thisregion};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)


%% look at removing jordans healthies for GMV

numHV = 34;
numCD = 34;
numCDR = 13;

myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
myGroupC = [repmat({'HV'},numHV,1); repmat({'CD_Active'},numCD,1); repmat({'CD_Remission'},numCDR,1)];

load('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_gmv_takeoutjordanshealthies/takeoutjordhv_gmv.mat');
figure
clear g
g = gramm('x',myGroup,'y',ymean);
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','GMV left postcentral gyrus (cm3)')
g.set_order_options('x',0)
g.draw()
g.update('color',myGroupC)
g.geom_jitter('alpha',0.8)
g.draw()
[H,P,CI,STATS] = ttest2(ymean(1:34),ymean(35:end));
text(1,1,['p=' num2str(round(P,3)) ])
g.export('file_name','gmv_removejordhv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/investigations',...
    'file_type','pdf')



%% GMV CD vs HV
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg/

%load('CD_HV_mdata.mat');
load('CD_HV_mdata_feb2021.mat');
%regionName = 'lcaudate';

figure('Position',[100 100 1000 800])
clear g

g(1,1) = gramm('x',myGroup,'y',ymean_129);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Parietal operculum cortex (cm^3)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(1,2) = gramm('x',myGroup,'y',ymean_444);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Left cingulate gyrus (cm3)')
g(1,2).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(2,1) = gramm('x',myGroup,'y',ymean_799);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Superior frontal gyrus (cm3)')
g(2,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(2,2) = gramm('x',myGroup,'y',ymean_829);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Lateral occipital cortex (cm3)')
g(2,2).set_order_options('x',0)

g(3,1) = gramm('x',myGroup,'y',ymean_2237);
g(3,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,1).set_point_options('markers', {'o'} ,'base_size',10)
g(3,1).set_text_options('Font','Helvetica','base_size',16)
g(3,1).set_names('x',[],'y','Left planum polare (cm3)')
g(3,1).set_order_options('x',0)

g(3,2) = gramm('x',myGroup,'y',ymean_5782);
g(3,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(3,2).set_point_options('markers', {'o'} ,'base_size',10)
g(3,2).set_text_options('Font','Helvetica','base_size',16)
g(3,2).set_names('x',[],'y','Right orbital frontal cortex (cm3)')
g(3,2).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,2).update('color',myGroupD)
g(2,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,1).update('color',myGroupD)
g(3,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(3,2).update('color',myGroupD)
g(3,2).geom_jitter('alpha',0.8,'edgewidth',2)

g.set_color_options('map',mycamp)
g.axe_property('PlotBoxAspectRatio',[1 1 1]);
g.draw()

[H,P1,CI,STATS] = ttest2(ymean_230(1:42), ymean_230(43:end));
[H,P2,CI,STATS] = ttest2(ymean_444(1:42), ymean_444(43:end));
[H,P3,CI,STATS] = ttest2(ymean_799(1:42), ymean_799(43:end));
[H,P4,CI,STATS] = ttest2(ymean_829(1:42), ymean_829(43:end));
[H,P5,CI,STATS] = ttest2(ymean_2237(1:42), ymean_2237(43:end));
[H,P6,CI,STATS] = ttest2(ymean_5782(1:42), ymean_5782(43:end));


text(-45,17,['p=' num2str(round(P1,3)) ])
text(1,17,['p=' num2str(round(P2,3)) ])
text(-45,9,['p=' num2str(round(P3,3)) ])
text(1,9,['p=' num2str(round(P4,3)) ])
text(-45,1,['p=' num2str(round(P5,3)) ])
text(1,1,['p=' num2str(round(P6,3)) ])

g.export('file_name','gmv_cd_hv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')
% 
% thisregion = {'Parietal operculum cortex','Left cingulate gyrus','Superior frontal gyrus',...
%     'Lateral occipital cortex','Left planum polare','Right orbital frontal cortex'};
thisfilename = 'GMV cd_hv';
T = table(subjects(:), ymean_230, ymean_444, ymean_799, ymean_829, ymean_2237, ymean_5782);
T.Properties.VariableNames = {'Subject','Parietal operculum cortex','Left cingulate gyrus','Superior frontal gyrus',...
    'Lateral occipital cortex','Left planum polare','Right orbital frontal cortex'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)



%% GMV CD>HC TFCE ONLY MARCH 2021
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg/

%load('CD_HV_mdata.mat');
load('CD_HC_mdata_TFCE_march2021.mat');
%regionName = 'lcaudate';

figure('Position',[100 100 1000 900])
clear g

g(1,1) = gramm('x',myGroup,'y',ymean_34316);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Right orbital frontal cortex (cm3)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(1,2) = gramm('x',myGroup,'y',ymean_1012);
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Left superior frontal gyrus (cm3)')
g(1,2).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(2,1) = gramm('x',myGroup,'y',ymean_196);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x',[],'y','Lateral occipital cortex (cm3)')
g(2,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(2,2) = gramm('x',myGroup,'y',ymean_10);
g(2,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(2,2).set_point_options('markers', {'o'} ,'base_size',10)
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_names('x',[],'y','Left planum temporale (cm3)')
g(2,2).set_order_options('x',0)

g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,1).update('color',myGroupD)
g(2,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(2,2).update('color',myGroupD)
g(2,2).geom_jitter('alpha',0.8,'edgewidth',2)


g.set_color_options('map',mycamp)
g.axe_property('PlotBoxAspectRatio',[1 1 1]);
g.draw()

[H,P1,CI,STATS] = ttest2(ymean_34316(1:42), ymean_34316(43:end));
[H,P2,CI,STATS] = ttest2(ymean_1012(1:42), ymean_1012(43:end));
[H,P3,CI,STATS] = ttest2(ymean_196(1:42), ymean_196(43:end));
[H,P4,CI,STATS] = ttest2(ymean_10(1:42), ymean_10(43:end));



% text(-45,10,['p=' num2str(round(P1,3)) ])
% text(1,10,['p=' num2str(round(P2,3)) ])
% text(-45,1,['p=' num2str(round(P3,3)) ])
% text(1,1,['p=' num2str(round(P4,3)) ])


g.export('file_name','gmv_cd_hv_TFCE', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

thisfilename = 'GMV cd_hv tfce';
T = table(subjects(:), ymean_34316, ymean_1012, ymean_196, ymean_10);
T.Properties.VariableNames = {'Subject','Right orbital frontal cortex','Left superior frontal gyrus','Lateral occipital cortex',...
    'Left planum temporale'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)



%% WMV
% HV


cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_WM/

load('HV_mdata.mat');

%regionName = 'lprecentral';

figure
clear g
g = gramm('x',myGroup,'y',Y);
%g.geom_jitter()
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','Left precentral gyrus (cm3)')
%g.set_title('MARSBAR: lprecentral');
g.set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()


g.update('color',myGroupD)
g.geom_jitter('alpha',0.8,'edgewidth',2)
g.set_color_options('map',mycamp)
%g.axe_property('PlotBoxAspectRatio',[1 1 1]);
g.draw()


[H,P,CI,STATS] = ttest2(Y(1:42),Y(43:end));

text(1,1,['p=' num2str(round(P,4)) ])

g.export('file_name','wmv_lprecentral', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

thisfilename = 'WMV hv_cd';
T = table(subjects(:), Y);
T.Properties.VariableNames = {'Subject','Left precentral gyrus'};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)





%% WMV CD


load('cd_mdata.mat');
%regionName = 'lcaudate';

figure('Position',[100 100 1400 500])
clear g

g(1,1) = gramm('x',myGroup,'y',Y(:,1));
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x',[],'y','Left lateral occipital cortex (cm3)')
g(1,1).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])

g(1,2) = gramm('x',myGroup,'y',Y(:,2));
g(1,2).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x',[],'y','Right frontal medial cortex (cm3)')
g(1,2).set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g(1,3) = gramm('x',myGroup,'y',Y(:,3));
g(1,3).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x',[],'y','WMV right rectus (cm3)')
g(1,3).set_order_options('x',0)

%g.axe_property('YLim',[0.2 0.5])
g.draw()


g(1,1).update('color',myGroupD)
g(1,1).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,2).update('color',myGroupD)
g(1,2).geom_jitter('alpha',0.8,'edgewidth',2)
g(1,3).update('color',myGroupD)
g(1,3).geom_jitter('alpha',0.8,'edgewidth',2)

g.set_color_options('map',mycamp)
g.axe_property('PlotBoxAspectRatio',[1 1 1]);

g.draw()


[H,P1,CI,STATS] = ttest2(Y(1:42,1),Y(43:end,1));
[H,P2,CI,STATS] = ttest2(Y(1:42,2),Y(43:end,2));
[H,P3,CI,STATS] = ttest2(Y(1:42,3),Y(43:end,3));


text(-90,1,['p=' num2str(round(P1,3)) ])
text(-45,1,['p=' num2str(round(P2,3)) ])
text(1,1,['p=' num2str(round(P3,3)) ])


g.export('file_name','wmv_cd_hv', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')

Y1 = Y(:,1);
Y2 = Y(:,2);

thisfilename = 'WMV cd_hv';
T = table(subjects(:), Y1, Y2);
T.Properties.VariableNames = {'Subject','Left lateral occipital cortex','Right frontal medial cortex',};
writetable(T,['/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/grab_ROI_values/vbm/' thisfilename '.xlsx'],'FileType','spreadsheet','WriteRowNames',1)




%% %%%% TRY WITHOUT SEX

numHV = 42;
numCD = 34;
numCDR = 13;

myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD'},numCDR,1)];
myGroupC = [repmat({'HV'},numHV,1); repmat({'CD_Active'},numCD,1); repmat({'CD_Remission'},numCDR,1)];



%%



cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_nosex/

load('hvcd_gmv.mat');

%regionName = 'lprecentral';

figure
clear g
g = gramm('x',myGroup,'y',ymean);
%g.geom_jitter()
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','GMV left postcentral gyrus (cm3)')
%g.set_title('MARSBAR: lprecentral');
g.set_order_options('x',0)
%g.axe_property('YLim',[0.2 0.5])
g.draw()


g.update('color',myGroupC)
g.geom_jitter('alpha',0.8)
g.draw()


[H,P,CI,STATS] = ttest2(ymean(1:42),ymean(43:end));

text(1,1,['p=' num2str(round(P,3)) ])

g.export('file_name','gmv_lpostcentral_nosex', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')



