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


% this is the mask from Gita's data
[mdata,mhdr] = cbiReadNifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/old_analyses/mwp1_gitaonly_age/big_roi_nifti.nii');
mdata = mdata(:); %vectorise
mdata = logical(mdata);

% use this mask to index into everybody's GMV value
mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/mri/';


thisIdx = find(mdata~=0); % rather than read in all data, just mask it before it saves it out
maskedBoy = zeros(length(thisIdx),1,1);

tic
for ii = 1:length(subjects)
    
    thicBoy = cbiReadNifti([mypath 's12mm_mwp1m' subjects{ii} '.nii']); % all gmv 
    thicBoy = thicBoy(:); % vec
    maskedBoy(:,ii) = thicBoy(thisIdx);
    %maskedBoy(:,ii) = thicBoy.*mdata;
end
toc

maskedBoyMean = mean(maskedBoy);
maskedBoyMean = maskedBoyMean(:);

%%
% now we want to plot all GMV values in this ROI
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


mycamp = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0];
mycamp = mycamp./256;

figure('Position',[100 100 800 400])
%figure
clear g
g = gramm('x',myGroup,'y',maskedBoyMean);
g.stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'color',[0 0 0],'drawoutlier',0)
g.set_point_options('markers', {'o'} ,'base_size',12)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x',[],'y','GMV left precentral gyrus (cm3)')
g.set_order_options('x',0)
g.draw()
g.update('color',myGroupC)
g.geom_jitter('alpha',0.6)
g.set_color_options('map',mycamp)
g.axe_property('PlotBoxAspectRatio',[1 1 1]);

g.draw()
[H,P,CI,STATS] = ttest2(maskedBoyMean(1:42),maskedBoyMean(43:end));
text(1,1,['p=' num2str(round(P,3)) ])
g.export('file_name','gmv_usingGitasROI', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','pdf')









