% ibd_demotable - fast way to fill excel sheet from pdf reports for IBD patients from CAT12
%
% Michael Asghar
% September 2020


patients = {'001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
    '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008', ...
    'sub-012', 'sub-024','sub-038',...
    'sub-011', 'sub-014', 'sub-021', 'sub-025', 'sub-032', 'sub-033'};

hc_sex = {'M','M','F','F','M','F','M','F','F','F','M','F','F',...
    'M','M','F','M','M','F','F','M','M','M','M','M','F','M','M',...
    'F','F','M','M','M','M','F','M','F','F','M','M','F','F'}';
pat_sex = {'F','M','M','F','M','M','M','M','M','M','M','M','M','F','M',...
    'M','F','F','M','M','F','M','M','F','F','M','F','F','F','F','F','F',...
    'M','M','F','F','M','M','F','M','F','M','F','M','F','F','M'}';

% missing Jordan 9 and 10 for now, need to be preprocessed
healthies = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
    '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
    '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
    'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
    'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034'};

pat_age = [56    18    31    23    35    53    30    20    22    30    44    32    63    20    28    38    67    38,...
    68    25    20    18    41    19    28    25    24    62    32    22    31    24    41    18    31    33,...
    52    26    44    62    58    54    53    23    25    54    26]';

hc_age = [27    25    20    31    32    62    27    28    19    24    31    57    22    25    53    31    51    45,...
    27    41    37    24    35    25    26    20    35    48    42    65    64    23    27    25    26    60,...
    27    30    48    48    32    23]';

gitsub = repmat({'gita'},34,1);
jorsub = repmat({'jord'},13,1);
whoSub = [gitsub;jorsub];
whoPat = repmat({'patient'},47,1);

gitHV = repmat({'gita'},34,1);
jorHV = repmat({'jord'},8,1);
whoHV = [gitHV;jorHV];
whoHeal = repmat({'healthy'},42,1);



mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/report/';

pat_demogs = zeros(length(patients),5,1); % make room
hc_demogs = zeros(length(healthies),5,1); % make room


for ii = 1:length(patients)
    tmp = load([mypath 'cat_m' patients{ii} '.mat']);
    
    % grab
    pat_demogs(ii,:) = [round(tmp.S.subjectmeasures.vol_TIV),...          %TIV
        round(tmp.S.subjectmeasures.vol_abs_CGW(2)),... %GM
        round(tmp.S.subjectmeasures.vol_abs_CGW(3)),... %WM
        round(tmp.S.subjectmeasures.vol_abs_CGW(1)),... %CSF
        tmp.S.subjectmeasures.dist_thickness{1}(1)];    %CT
end

for ii = 1:length(healthies)
    tmp = load([mypath 'cat_m' healthies{ii} '.mat']);
    
    % grab
    hc_demogs(ii,:) = [round(tmp.S.subjectmeasures.vol_TIV),...          %TIV
        round(tmp.S.subjectmeasures.vol_abs_CGW(2)),... %GM
        round(tmp.S.subjectmeasures.vol_abs_CGW(3)),... %WM
        round(tmp.S.subjectmeasures.vol_abs_CGW(1)),... %CSF
        tmp.S.subjectmeasures.dist_thickness{1}(1)];    %CT
end

%% check for outliers

%[h,p,ci,stats] = ttest2(pat_demogs(1:34,1), pat_demogs(34:end,1));
% [h,p,ci,stats] = ttest2(hc_demogs(1:34,1), hc_demogs(34:end,1));
% [h,p,ci,stats] = ttest2(pat_age(1:34), pat_age(34:end));
% [h,p,ci,stats] = ttest2(hc_age(1:34), hc_age(34:end));

figure('Position',[100 100 1400 600])
clear g
g(1,1) = gramm('x', [whoSub; whoHV] ,'y',[pat_demogs(:,1); hc_demogs(:,1)]);
g(1,1).stat_boxplot('alpha',0)
g(1,2) = gramm('x', [whoSub; whoHV],'y',[pat_age; hc_age]);
g(1,2).stat_boxplot('alpha',0)
g.draw
g(1,1).update('y',[pat_demogs(:,1); hc_demogs(:,1)],'color',[whoPat;whoHeal]);
g(1,1).geom_jitter()
g(1,1).set_point_options('markers', {'o'} ,'base_size',12)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','which group','y','TIV (cm3)')
g(1,2).update('y',[pat_age; hc_age],'color',[whoPat;whoHeal]);
g(1,2).geom_jitter()
g(1,2).set_point_options('markers', {'o'} ,'base_size',12)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x','which group','y','age (years)')
g.draw
g.export('file_name','check_demo_outliers', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/',...
    'file_type','png')
% now put into table and save as csv


%% Want a table to summarise means and adjusted values and p vals

% try corrected method using residuals a la
% https://www.nature.com/articles/s41598-020-69361-9 / sanchis-segura 2020

% VOIadj = VOIn - b(TIVn-mean(TIV)
% VOIsca = VOIadj * mean(mean(TIVhc),mean(TIVpa)) / TIVn

mean_tiv_hc = mean(hc_demogs(:,1));
mean_tiv_pa = mean(pat_demogs(:,1));

b_gmv = myLinReg(hc_demogs(:,1),hc_demogs(:,2));
b_wmv = myLinReg(hc_demogs(:,1),hc_demogs(:,3));
b_csf = myLinReg(hc_demogs(:,1),hc_demogs(:,4));

bpat_gmv = myLinReg(pat_demogs(:,1),pat_demogs(:,2));
bpat_wmv = myLinReg(pat_demogs(:,1),pat_demogs(:,3));
bpat_csf = myLinReg(pat_demogs(:,1),pat_demogs(:,4));

GMV_corrected = hc_demogs(:,2) - b_gmv(2)*(hc_demogs(:,1) - mean_tiv_hc);
WMV_corrected = hc_demogs(:,3) - b_wmv(2)*(hc_demogs(:,1) - mean_tiv_hc);
CSF_corrected = hc_demogs(:,4) - b_csf(2)*(hc_demogs(:,1) - mean_tiv_hc);

GMV_corrected_pat = pat_demogs(:,2) - bpat_gmv(2)*(pat_demogs(:,1) - mean_tiv_pa);
WMV_corrected_pat = pat_demogs(:,3) - bpat_wmv(2)*(pat_demogs(:,1) - mean_tiv_pa);
CSF_corrected_pat = pat_demogs(:,4) - bpat_csf(2)*(pat_demogs(:,1) - mean_tiv_pa);

GMV_corr_sca = GMV_corrected .* mean([mean_tiv_hc;mean_tiv_pa]) ./ hc_demogs(:,1);
WMV_corr_sca = WMV_corrected .* mean([mean_tiv_hc;mean_tiv_pa]) ./ hc_demogs(:,1);
CSF_corr_sca = CSF_corrected .* mean([mean_tiv_hc;mean_tiv_pa]) ./ hc_demogs(:,1);

GMV_corr_sca_pat = GMV_corrected_pat .* mean([mean_tiv_hc;mean_tiv_pa]) ./ pat_demogs(:,1);
WMV_corr_sca_pat = WMV_corrected_pat .* mean([mean_tiv_hc;mean_tiv_pa]) ./ pat_demogs(:,1);
CSF_corr_sca_pat = CSF_corrected_pat .* mean([mean_tiv_hc;mean_tiv_pa]) ./ pat_demogs(:,1);

% chi2 for gender
code1 = ones(length(hc_sex),1);
code2 = ones(length(pat_sex),1)+1;
codes = [code1; code2];
mysex = [hc_sex;pat_sex];
[conttbl,chi2,p,labels] = crosstab(codes, mysex);

[H,Pgmv,CI,STATSgmv] = ttest2(GMV_corr_sca, GMV_corr_sca_pat);
[H,Pwmv,CI,STATSwmv] = ttest2(WMV_corr_sca, WMV_corr_sca_pat);
[H,Pcsf,CI,STATScsf] = ttest2(CSF_corr_sca, CSF_corr_sca_pat);

[H,Pgmvabs,CI,STATSgmvabs] = ttest2(hc_demogs(:,2), pat_demogs(:,2));
[H,Pwmvabs,CI,STATSwmvabs] = ttest2(hc_demogs(:,3), pat_demogs(:,3));
[H,Pcsfabs,CI,STATScsfabs] = ttest2(hc_demogs(:,4), pat_demogs(:,4));

[H,Pct,CI,STATSct] = ttest2(hc_demogs(:,5), pat_demogs(:,5));

[H,Page,CI,STATSage] = ttest2(hc_age, pat_age);

[H,Ptiv,CI,STATStiv] = ttest2(hc_demogs(:,1), pat_demogs(:,1));


%T = table('Size',[10 7],'VariableTypes',{'string','double','double','double','double','double','double'},'VariableNames',{'Category','HC Mean','HC SD/SE','PA Mean','PA SD/SE','Test stat','p-value'})

Category = {'Age (years)','Sex','TIV','GMV','GMV adj','WMV', 'WMV adj','CSF', 'CSF adj', 'CT'}';
HC_Mean = [mean(hc_age); sum(contains(hc_sex,'F')); mean_tiv_hc; mean(hc_demogs(:,2));  mean(GMV_corr_sca);  mean(hc_demogs(:,3));  mean(WMV_corr_sca); mean(hc_demogs(:,4));  mean(CSF_corr_sca); mean(hc_demogs(:,5)) ];
HC_SD = [std(hc_age); 0 ; std(hc_demogs(:,1)); std(hc_demogs(:,2));  std(GMV_corr_sca);  std(hc_demogs(:,3));  std(WMV_corr_sca); std(hc_demogs(:,4));  std(CSF_corr_sca); std(hc_demogs(:,5)) ];
PA_Mean = [mean(pat_age); sum(contains(pat_sex,'F')); mean_tiv_pa; mean(pat_demogs(:,2)); mean(GMV_corr_sca_pat); mean(pat_demogs(:,3));  mean(WMV_corr_sca_pat); mean(pat_demogs(:,4));  mean(CSF_corr_sca_pat); mean(pat_demogs(:,5))  ];
PA_SD = [std(pat_age); 0 ; std(pat_demogs(:,1)); std(pat_demogs(:,2));  std(GMV_corr_sca_pat);  std(pat_demogs(:,3));  std(WMV_corr_sca_pat); std(pat_demogs(:,4));  std(CSF_corr_sca_pat); std(pat_demogs(:,5)) ];
Test_statistic = [STATSage.tstat; chi2; STATStiv.tstat; STATSgmvabs.tstat; STATSgmv.tstat; STATSwmvabs.tstat; STATSwmv.tstat; STATScsfabs.tstat; STATScsf.tstat; STATSct.tstat];
P_value = [Page; Ptiv; p; Pgmvabs; Pgmv; Pwmvabs; Pwmv; Pcsfabs; Pcsf; Pct];

T = table(Category,HC_Mean,HC_SD,PA_Mean,PA_SD,Test_statistic, P_value);
% Christ, why did i do this





%% table
varTypes = {'double','double','double','double','double',};
varNames = {'TIV','GMV','WMV','CSF','CT'};
T1 = table('Size',[size(pat_demogs,1), size(pat_demogs,2)],'VariableTypes',varTypes,'VariableNames',varNames); %preallocate
T2 = table('Size',[size(hc_demogs,1), size(hc_demogs,2)],'VariableTypes',varTypes,'VariableNames',varNames);

T1.TIV = pat_demogs(:,1);
T1.GMV = pat_demogs(:,2);
T1.WMV = pat_demogs(:,3);
T1.CSF = pat_demogs(:,4);
T1.CT = pat_demogs(:,5);

T2.TIV = hc_demogs(:,1);
T2.GMV = hc_demogs(:,2);
T2.WMV = hc_demogs(:,3);
T2.CSF = hc_demogs(:,4);
T2.CT = hc_demogs(:,5);

writetable(T1,'/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/excel_sheets/pat_demogs.xlsx','FileType','spreadsheet')
writetable(T2,'/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/excel_sheets/hc_demogs.xlsx','FileType','spreadsheet')








