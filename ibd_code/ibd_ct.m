cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/label/
% 
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
    'sub-021', 'sub-024', 'sub-025', 'sub-033', 'sub-005', 'sub-006', 'sub-008', ...
    'sub-011', 'sub-012', 'sub-014', 'sub-003','sub-032','sub-038'};

ibdf_fat_scores = [12 9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14,... 
    15 11 12 4 8 3 13 15 14 13 3 12 0 5 15 0 2 4 10];
fat_subs = {'001_P13','001_P15','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-011', 'sub-012', 'sub-014',...
    'sub-021', 'sub-024', 'sub-025', 'sub-033','sub-032','sub-038'};
myFatGroup = [repmat({'Gita CD'},26,1); repmat({'Jordan CD'},13,1)];

for ii = 1:length(subjects)
    for jj = 1:length(fat_subs)
        tmp = strcmpi(subjects{ii},fat_subs{jj});
        if tmp == 1
            thisIdx(ii) = tmp;
        end
    end
end
thisIdx = thisIdx(:);

numHV = 42;
numCD = 34;
numCDR = 13;
regionName = 'lprecentral';
%mystr = 'lcaudalmiddlefrontal';
%mystr = 'lcaudalmiddlefrontal';
% first thickness values from CAT12
mRegion = zeros(length(subjects),1);
for ii = 1:length(subjects)
    load(['catROIs_m' subjects{ii} '.mat'],'S');
    myidx = find(strcmpi(S.aparc_DK40.names,regionName));
    mRegion(ii) = S.aparc_DK40.data.thickness(myidx);
end

fatThic = mRegion(thisIdx);
ibdf_fat_scores = ibdf_fat_scores(:);


close all
figure
clear g
g = gramm('x',ibdf_fat_scores,'y',fatThic,'color',myFatGroup);
g.geom_point
g.set_point_options('markers', {'o'} ,'base_size',15)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','IBDF scale', 'y','Cortical thickness (mm^2)','color','Group')
g.set_title(regionName)
g.draw()
g.update('y',fatThic)
g.stat_glm('geom','area','disp_fit',false)
g.set_layout_options('legend',false)
g.draw()
% g.export('file_name',[mystr '_ct_ibd_FAT'], ...
%     'export_path',...
%     '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
%     'file_type','pdf')
clc
[Rgita,PgitaR]=corrcoef(ibdf_fat_scores(1:26),fatThic(1:26));
[Rjord,PjordR]=corrcoef(ibdf_fat_scores(27:end),fatThic(27:end));
%
fprintf('\n\n Gita r: %.3f',Rgita(2))
fprintf('\n Gita p: %.3f',PgitaR(2))
fprintf('\n Jord r: %.3f',Rjord(2))
fprintf('\n Jord p: %.3f',PjordR(2))

T = table('Size',[2 2],'VariableType',{'double','double'},'RowNames',{'R','P-val'},'VariableNames',{'Gita','Jordan'});
T(1,1) = {Rgita(2)};
T(1,2) = {Rjord(2)};
T(2,1) = {PgitaR(2)};
T(2,2) = {PjordR(2)};

% writetable(T,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' mystr '_table.csv'],'FileType','text','WriteRowNames',1)

%

myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD_r'},numCDR,1)];
%
% g.export('file_name',[mystr '_ct_ibd'], ...
%     'export_path',...
%     '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
%     'file_type','pdf')

close all
clear g
figure('Position', [100 100 1200 600])
g(1,1) = gramm('x',myGroup,'y',mRegion);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'notch',false)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_title(['CAT12 ' regionName ' Median+IQR'])

% mean and std too please 
g(1,2) = gramm('x',myGroup,'y',mRegion);
g(1,2).stat_summary('type','std','geom',{'area','black_errorbar'});
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_title(['CAT12 ' regionName ' Mean+STD'])


g.set_names('x','Group', 'y','Cortical thickness mm^2')

g.draw()

g(1,1).update('y',mRegion);
g(1,1).geom_jitter('alpha',0.5)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)

g.draw()



%% GMV
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/mwp1_all_anova/

load('mwp1_lprecentral_mdata.mat');

regionName = 'lprecentral';

figure
clear g
g = gramm('x',myGroup,'y',Y);
%g.geom_jitter()
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3)
g.set_point_options('markers', {'o'} ,'base_size',15)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','Group', 'y','GMV')
g.set_title('MARSBAR: lprecentral');
g.draw()
% g.export('file_name',[mystr '_gmv_ibd'], ...
%     'export_path',...
%     '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
%     'file_type','pdf')

%% WMV
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/mwp2_all_anova/

load('mwp2_lprecentral_mdata_cd.mat');

regionName = 'lprecentral';

figure
clear g
g = gramm('x',myGroup,'y',Y);
%g.geom_jitter()
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3)
g.set_point_options('markers', {'o'} ,'base_size',15)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','Group', 'y','WMV')
g.set_title(['MARSBAR: ' regionName]);
g.draw()
% g.export('file_name',[mystr '_wmv_ibd'], ...
%     'export_path',...
%     '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
%     'file_type','pdf')
% 








