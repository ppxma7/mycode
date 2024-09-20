% want to replicate the graph at bottom of ibd_atlas_label but with a
% couple of clusters from GMV/WMV marsbar outputs from spm12
% only in j+g [atients for now with MFI scores.
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
numHV = 42;
numCD = 34;
numCDR = 13;
myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD_r'},numCDR,1)];
myGroup = myGroup(:);

%ylims
a = 2;
b = 3;

% these ibdf scores are only for patients for now.
ibdf_fat_scores = [9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14,... 
    15 11 12 4 8 3 13 15 14 13 3 12 0 5 15 0 2 4 10];
ibdf_fat_scores = ibdf_fat_scores(:);
fat_subs = {'001_P15','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-011', 'sub-012', 'sub-014',...
    'sub-021', 'sub-024', 'sub-025', 'sub-033','sub-032','sub-038'};
myFatGroup = [repmat({'Gita CD'},25,1); repmat({'Jordan CD'},13,1)];

for ii = 1:length(subjects)
    for jj = 1:length(fat_subs)
        tmp = strcmpi(subjects{ii},fat_subs{jj});
        if tmp == 1
            thisIdx(ii) = tmp;
        end
    end
end
thisIdx = thisIdx(:);
% grab index of which patients have fat scores


% if nargin == 0
%     hemi = 'l';
%     regionName = 'precentral';
% elseif nargin == 1
%     hemi = 'l';
% end

cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/mwp1_jordgita_combo_MFIfatigue/
mwp1_data = load('mfi_phy_-8_-70_3_roi_mdata.mat','Y');
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/mwp2_jordgita_combo_MFIfatigue/
mwp2_data = load('mfiphy_2clusters_mdata.mat','Y');



%regionNameC = [hemi regionName];


% mRegionC = zeros(length(subjects),1);
% for ii = 1:length(subjects)
%     load(['catROIs_m' subjects{ii} '.mat'],'S');
%     myidx = find(strcmpi(S.aparc_DK40.names,regionNameC));
%     mRegionC(ii) = S.aparc_DK40.data.thickness(myidx);
% end


% fatThicF = mRegion(thisIdx);
% fatThic = mRegionC(thisIdx);

m = 0.70884;
c = 7.6819;
m2 = 0.69797;
c2 = 4.5396;
gita_CD = [9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14,15 11 12 4 8 3];
gita_CD_general = round((m*gita_CD)+c);
gita_CD_physical = round((m2*gita_CD)+c2);
jord_MFI_gen =  [16 5 16 16 19 9 18 9 4 13 10 20 7 12 4 9 8 9 10 9 14]';
jord_MFI_phy = [15 5 12 10 16 5 11 4 6 7  7  19 7 9  5 9 6 8 6 10 15]';

jord_group = {'FCD','HV','FCD','FCD','FCD','NFCD','FCD','NFCD','HV','NFCD','HV','FCD','NFCD',...
    'HV','HV','HV','NFCD','HV','NFCD','HV','FCD'}';

% kill hvs
idx = ~strcmpi('HV',jord_group);
jord_MFI_gen_pa = jord_MFI_gen(idx);
jord_MFI_phy_pa = jord_MFI_phy(idx);

myFatGroup3 = [repmat({'Active CD'},25,1); jord_group(idx)];

MFI_scores_g = [gita_CD_general(:); jord_MFI_gen_pa(:)];
MFI_scores_p = [gita_CD_physical(:); jord_MFI_phy_pa(:)];

%% gramm now
% everything should be in the correct form now, assuming the subject ordering from
% spm12 is as above, when you run the batch file
Y = zeros(length(MFI_scores_g),1);
Y(:,1) = mwp1_data.Y(:,1);
Y(:,2) = mwp2_data.Y(:,1);
Y(:,3) = mwp2_data.Y(:,2);

figure('Position',[100 100 1800 800])
clear gr
gr(1,1) = gramm('x',MFI_scores_p,'y',Y(:,1));%,'color',myFatGroup);
gr(1,1).geom_point
gr(1,1).set_point_options('markers', {'o'} ,'base_size',15)
gr(1,1).set_text_options('Font','Helvetica','base_size',16)
gr(1,1).set_names('x','MFI phys scale', 'y','GMV','color','Group')
gr(1,1).set_title('MARSBAR GMV: Lingual L')
%gr(1,1).axe_property('YLim',[a b])

gr(1,2) = gramm('x',MFI_scores_p,'y',Y(:,2));%,'color',myFatGroup);
gr(1,2).geom_point
gr(1,2).set_point_options('markers', {'o'} ,'base_size',15)
gr(1,2).set_text_options('Font','Helvetica','base_size',16)
gr(1,2).set_names('x','MFI phys scale', 'y','WMV','color','Group')
gr(1,2).set_title('MARSBAR WMV: Parietal sup L')
%gr(1,2).axe_property('YLim',[a b])

gr(1,3) = gramm('x',MFI_scores_p,'y',Y(:,3));%,'color',myFatGroup);
gr(1,3).geom_point
gr(1,3).set_point_options('markers', {'o'} ,'base_size',15)
gr(1,3).set_text_options('Font','Helvetica','base_size',16)
gr(1,3).set_names('x','MFI phys scale', 'y','WMV','color','Group')
gr(1,3).set_title('MARSBAR WMV: Fusiform L')
%gr(1,3).axe_property('YLim',[a b])
gr.draw()

gr(1,1).update('y',Y(:,1))
gr(1,1).stat_glm('geom','area','disp_fit',false)
gr(1,1).set_layout_options('legend',false)

gr(1,2).update('y',Y(:,2))
gr(1,2).stat_glm('geom','area','disp_fit',false)
gr(1,2).set_layout_options('legend',false)

gr(1,3).update('y',Y(:,3))
gr(1,3).stat_glm('geom','area','disp_fit',false)
gr(1,3).set_layout_options('legend',false)


gr.draw()

gr(1,1).update('color',myFatGroup3)
gr(1,1).geom_point
gr(1,2).update('color',myFatGroup3)
gr(1,2).geom_point
gr(1,3).update('color',myFatGroup3)
gr(1,3).geom_point
gr.draw()

gr.export('file_name','MARSBAR_tests', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/',...
    'file_type','pdf')


[RMFI,PMFI]=corrcoef(MFI_scores_p,Y(:,1));
TF_MFI = table('Size',[1 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Both'});
TF_MFI(1,1) = {RMFI(2)};
TF_MFI(1,2) = {PMFI(2)};
writetable(TF_MFI,'/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/GMV_cluster1.csv','FileType','text','WriteRowNames',1)
clear TF_MFI

[RMFI,PMFI]=corrcoef(MFI_scores_p,Y(:,2));
TF_MFI = table('Size',[1 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Both'});
TF_MFI(1,1) = {RMFI(2)};
TF_MFI(1,2) = {PMFI(2)};
writetable(TF_MFI,'/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/WMV_cluster1.csv','FileType','text','WriteRowNames',1)
clear TF_MFI

[RMFI,PMFI]=corrcoef(MFI_scores_p,Y(:,3));
TF_MFI = table('Size',[1 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Both'});
TF_MFI(1,1) = {RMFI(2)};
TF_MFI(1,2) = {PMFI(2)};
writetable(TF_MFI,'/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/WMV_cluster2.csv','FileType','text','WriteRowNames',1)
clear TF_MFI










