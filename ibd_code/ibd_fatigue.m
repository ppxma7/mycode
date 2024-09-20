% fatigue script 
% basic scores (IBDFscale)
clear all
close all


gita_CD = [12 9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14 15 11 12 4 8 3];
jord_FCD = [13 15 14 13 12 15 10];
jord_NFCD = [3 0 5 0 2 4];



scores = [gita_CD jord_FCD jord_NFCD];
scores = scores(:);

groups = [repmat({'Gita PA'},length(gita_CD),1); ...
    repmat({'Jordan FCD'},length(jord_FCD),1);...
    repmat({'Jordan NFCD'},length(jord_NFCD),1);];


%clear g
figure('Position', [100 100 1200 600])
g(1,1) = gramm('x',groups,'y',scores);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'notch',false)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_title('Median+IQR')

% mean and std too please 
g(1,2) = gramm('x',groups,'y',scores);
g(1,2).stat_summary('type','std','geom',{'bar','black_errorbar'});
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_title('Mean+STD')


g.set_names('x','Group', 'y','IBD Fatigue scale')

g.draw()

g(1,1).update('y',scores);
g(1,1).geom_jitter('alpha',0.5)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)

g.draw()


g.export('file_name','ibd_fatigue_scale', ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')

%% MFI scale for Jordan's data only
%x = [1 2 3 4 5 6];

jord_MFI_gen =  [16 5 16 16 19 9 18 9 4 13 10 20 7 12 4 9 8 9 10 9 14]';
jord_MFI_phys = [15 5 12 10 16 5 11 4 6 7  7  19 7 9  5 9 6 8 6 10 15]';
jord_group = {'FCD','HV','FCD','FCD','FCD','NFCD','FCD','NFCD','HV','NFCD','HV','FCD','NFCD',...
    'HV','HV','HV','NFCD','HV','NFCD','HV','FCD'}';

jord_group2 = [jord_group;jord_group];

jord_scores = [jord_MFI_gen; jord_MFI_phys];
jord_scores_group = [repmat({'MFI general'},length(jord_MFI_gen),1);repmat({'MFI physical'},length(jord_MFI_phys),1) ];


%clear g
figure('Position', [100 100 1200 600])
g(1,1) = gramm('x',jord_group2,'y',jord_scores,'color',jord_scores_group);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'notch',false)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_title('Median+IQR')

% mean and std too please 
g(1,2) = gramm('x',jord_group2,'y',jord_scores,'color',jord_scores_group);
g(1,2).stat_summary('type','std','geom',{'bar','black_errorbar'});
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_title('Mean+STD')


g.set_names('x','Group', 'y','MFI scale')
g.set_order_options('x',{'FCD','NFCD','HV'})

g.draw()

g(1,1).update('y',jord_scores);
g(1,1).geom_jitter('alpha',0.5)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)
g(1,1).set_layout_options('legend',false)
g.draw()

g.export('file_name','jordan_MFI_scale', ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')

%% Can we look for significant group effect?
% 2 factor ANOVA
% factor 1 is GROUP (FCD, NFCD, or HV)
% factor 2 is MFI TYPE (General or Physical)

mypath = '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/';
[p,tbl,stats,terms] = anovan(jord_scores,{jord_group2 jord_scores_group},'model',2,'varnames',{'Group','Score type'});

%results = multcompare(stats,'Dimension',[1]);
%results = multcompare(stats,'Dimension',[2]);
results = multcompare(stats,'Dimension',[1 2]);

labels = {'FCD_{gen}','HV_{gen}','NFCD_{gen}','FCD_{phy}','HV_{phy}','NFCD_{phy}'};

results_mat = zeros(6,6,1);
results_mat(1,2:6) = results(1:5,6);
results_mat(2,3:6) = results(6:9,6);
results_mat(3,4:6) = results(10:12,6);
results_mat(4,5:6) = results(13:14,6);
results_mat(5,6) = results(15,6);

results_mat_transpose = transpose(results_mat);

whole_tri = results_mat + results_mat_transpose;

n = length(whole_tri); % matrix size
B = logical(eye(n)); % identity square matrix
whole_tri(1:6+1:end) = diag(B); % take the diag elents of B and stick them in whole_tri

whole_tri_1p = 1-whole_tri; % 1-p?



figure, imagesc(whole_tri)
yticklabels(labels)
xticklabels(labels)
ytickangle(45)
xtickangle(45)
colormap pink
colorbar
caxis([0 0.05])
title('p values')
print([mypath 'MFI_multcompare'],'-dpng')

%% try plotting MFI vs IBDF in Jordan's group. Only patients, for now
% this is to get a correlation value, for converting Gita's patients IBDF
% into MFI

jord_MFI_gen =  [16 5 16 16 19 9 18 9 4 13 10 20 7 12 4 9 8 9 10 9 14]';
jord_MFI_phys = [15 5 12 10 16 5 11 4 6 7  7  19 7 9  5 9 6 8 6 10 15]';

jord_ibdf = [13 15 14 13 3 12 0 5 15 0 2 4 10]';
jord_ibdf2 = [jord_ibdf; jord_ibdf];
% 
% jord_ibdf = [jord_FCD jord_NFCD];
% jord_ibdf = jord_ibdf(:);

% kill hvs
idx = ~strcmpi('HV',jord_group);

jord_mfi_gen_pa = jord_MFI_gen(idx);
jord_mfi_phy_pa = jord_MFI_phys(idx);

jord_mfi = [jord_mfi_gen_pa; jord_mfi_phy_pa];

myGroup = [repmat({'MFI General'},length(jord_mfi_gen_pa),1); repmat({'MFI Physical'},length(jord_mfi_phy_pa),1)];

figure %('Position',[100 100 1200 600])
g = gramm('x',jord_ibdf2,'y',jord_mfi,'color',myGroup);
g.geom_point()
g.set_title('Jordan: MFI vs IBDF')
% g(1,2) = gramm('x',jord_ibdf,'y',jord_mfi_phy_pa);
% g(1,2).geom_point()
% g(1,2).set_title('Jordan: MFI phy vs IBDF')
g.stat_glm('geom','area','disp_fit',true)

g.axe_property('YLim',[0 25])
g.set_names('x','IBDF scale', 'y','MFI scale')
%g.set_order_options('x',{'FCD','NFCD','HV'})
g.set_point_options('markers', {'o'} ,'base_size',15)
g.set_text_options('Font','Helvetica','base_size',16)

g.draw()
g.export('file_name','MFIvsIBDF_jordan', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/IBD_thickness_fatigue/',...
    'file_type','pdf')

[Rge,Pge]=corrcoef(jord_ibdf,jord_mfi_gen_pa);
[Rph,Pph]=corrcoef(jord_ibdf,jord_mfi_phy_pa);
T = table('Size',[2 2],'VariableType',{'double','double'},'RowNames',{'R','P-val'},'VariableNames',{'MFIgen','MFIphy'});
T(1,1) = {Rge(2)};
T(1,2) = {Rph(2)};
T(2,1) = {Pge(2)};
T(2,2) = {Pph(2)};
writetable(T,'/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/IBD_thickness_fatigue/MFIvsIBDF_jordan.csv','FileType','text','WriteRowNames',1)


%% remake this now using Gita's converted scores
% convert gita's group into MFI
m = 0.70884;
c = 7.6819;
m2 = 0.69797;
c2 = 4.5396;
gita_CD = [12 9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14,15 11 12 4 8 3];
gita_CD_general = round((m*gita_CD)+c);
gita_CD_physical = round((m2*gita_CD)+c2);

jord_groupX = {'Jord:FCD','Jord:HV','Jord:FCD','Jord:FCD','Jord:FCD','Jord:NFCD','Jord:FCD','Jord:NFCD','Jord:HV','Jord:NFCD','Jord:HV','Jord:FCD','Jord:NFCD',...
    'Jord:HV','Jord:HV','Jord:HV','Jord:NFCD','Jord:HV','Jord:NFCD','Jord:HV','Jord:FCD'}';

% MFI_scores_g = [gita_CD_general(:); jord_MFI_gen_pa(:)];
% MFI_scores_p = [gita_CD_physical(:); jord_MFI_phy_pa(:)];
gita_group = repmat({'Gita:CD'},length(gita_CD),1);
gita_groupY = repmat({'Active'},length(gita_CD),1);  % this is for multcompare later
gita_group = gita_group(:);
jord_group4 = [gita_group; jord_groupX;gita_group; jord_groupX];
jord_groupY = [gita_groupY; jord_group;gita_groupY; jord_group]; % this is for multcompare later

jord_scores = [gita_CD_general(:); jord_MFI_gen; gita_CD_physical(:); jord_MFI_phys];
jord_scores_group = [repmat({'MFI general'},length(jord_MFI_gen),1); ...
    repmat({'MFI general'},length(gita_CD_general),1); ...
    repmat({'MFI physical'},length(jord_MFI_phys),1);...
    repmat({'MFI physical'},length(gita_CD_physical),1);...
    ];


%clear g
figure('Position', [100 100 1600 600])
g(1,1) = gramm('x',jord_group4,'y',jord_scores,'color',jord_scores_group);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'notch',false)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_title('Median+IQR')

% mean and std too please 
g(1,2) = gramm('x',jord_group4,'y',jord_scores,'color',jord_scores_group);
g(1,2).stat_summary('type','std','geom',{'bar','black_errorbar'});
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_title('Mean+STD')


g.set_names('x','Group', 'y','MFI scale')
g.set_order_options('x',{'Gita:CD','Jord:FCD','Jord:NFCD','Jord:HV'})

g.draw()

g(1,1).update('y',jord_scores);
g(1,1).geom_jitter('alpha',0.5,'dodge',0.5)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)
g(1,1).set_layout_options('legend',false)
g.draw()

g.export('file_name','converted_MFI_scale', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/IBD_thickness_fatigue/',...
    'file_type','pdf')
% 


%% Can we look for significant group effect? DO THIS INCLUDING GITAS
% 2 factor ANOVA
% factor 1 is GROUP (FCD, NFCD, or HV, or GitaCD)
% factor 2 is MFI TYPE (General or Physical)
mypath = '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/';
[p,tbl,stats,terms] = anovan(jord_scores,{jord_groupY jord_scores_group},'model',2,'varnames',{'Group','Score type'});

%results = multcompare(stats,'Dimension',[1])
%results = multcompare(stats,'Dimension',[2])
results = multcompare(stats,'Dimension',[1 2]);

labels = {'Active_{gen}','FCD_{gen}','HV_{gen}','NFCD_{gen}','Active_{phy}','FCD_{phy}','HV_{phy}','NFCD_{phy}'};

nn = 8;
results_mat = zeros(nn,6,1);
results_mat(1,2:nn) = results(1:7,6);
results_mat(2,3:nn) = results(8:13,6);
results_mat(3,4:nn) = results(14:18,6);
results_mat(4,5:nn) = results(19:22,6);
results_mat(5,6:nn) = results(23:25,6);
results_mat(6,7:nn) = results(26:27,6);
results_mat(7,8) = results(28,6);

results_mat_transpose = transpose(results_mat);

whole_tri = results_mat + results_mat_transpose;

n = length(whole_tri); % matrix size
B = logical(eye(n)); % identity square matrix
whole_tri(1:nn+1:end) = diag(B); % take the diag elents of B and stick them in whole_tri

whole_tri_1p = 1-whole_tri; % 1-p?



figure, imagesc(whole_tri)
yticklabels(labels)
xticklabels(labels)
ytickangle(45)
xtickangle(45)
colormap pink
colorbar
caxis([0 0.05])
title('p values')
print([mypath 'MFI_multcompare_withGitas'],'-dpng')


