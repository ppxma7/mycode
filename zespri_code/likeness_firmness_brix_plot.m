clear variables
close all
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/likeness_firmness_brix/'];
mypath = savedir;
myFile = [mypath 'likeness.xlsx'];
likeness = readtable(myFile,'Sheet','likeness');
brix_firm = readtable(myFile,'Sheet','brix');
nSubs = 14;
thismap = [215,48,39;...
    253,184,99;...
    26,152,80;
    69,117,180];
thismap = thismap./256;

%% --- Reshape likeness data to long format ---
kiwi_labels = {'Red','Green','Gold'};
kiwi_cols   = {'x480','x619','x875'};  % readtable prefixes numeric headers with 'x'

liking_long = [];
kiwi_long = {};
sub_long = {};

for k = 1:3
    vals = likeness.(kiwi_cols{k});
    liking_long = [liking_long; vals];
    kiwi_long   = [kiwi_long; repmat(kiwi_labels(k), nSubs, 1)];
    sub_long    = [sub_long; likeness.NOTID];
end

%% --- 1) One-way repeated-measures ANOVA: Overall Liking ---
% Arrange as nSubs x 3 matrix (cols = Red, Gold, Green)
liking_mat = [likeness.(kiwi_cols{1}), likeness.(kiwi_cols{2}), likeness.(kiwi_cols{3})];

[p_lik, tbl_lik, stats_lik] = anova1(liking_mat, kiwi_labels, 'on');
fprintf('\n=== Overall Liking ANOVA ===\n');
fprintf('F(%d,%d) = %.3f, p = %.4f\n', tbl_lik{2,3}, tbl_lik{3,3}, tbl_lik{2,5}, p_lik);
[c_lik, ~, ~, gnames_lik] = multcompare(stats_lik, 'Display', 'on');

tbldom = array2table(c_lik,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);

disp('Post-hoc pairwise (Tukey):'); disp(tbldom);

tbldom.("Group A")=gnames_lik(tbldom.("Group A"));
tbldom.("Group B")=gnames_lik(tbldom.("Group B"));
writecell(tbl_lik,sprintf([savedir 'anova_liking'],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_liking'],'%s'),'FileType','spreadsheet')


%% --- 2) One-way repeated-measures ANOVA: Firmness ---

firm_mat = [brix_firm.Firmness(strcmp(brix_firm.Kiwifruit,'Red')), ...
            brix_firm.Firmness(strcmp(brix_firm.Kiwifruit,'Green')),...
            brix_firm.Firmness(strcmp(brix_firm.Kiwifruit,'Gold'))];

[p_firm, tbl_firm, stats_firm] = anova1(firm_mat, kiwi_labels, 'on');
fprintf('\n=== Firmness ANOVA ===\n');
fprintf('F(%d,%d) = %.3f, p = %.4f\n', tbl_firm{2,3}, tbl_firm{3,3}, tbl_firm{2,5}, p_firm);
[c_firm, ~, ~, gnames_firm] = multcompare(stats_firm, 'Display', 'on');
disp('Post-hoc pairwise (Tukey):'); disp(tbldom);

tbldom = array2table(c_firm,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);

disp('Post-hoc pairwise (Tukey):'); disp(tbldom);

tbldom.("Group A")=gnames_firm(tbldom.("Group A"));
tbldom.("Group B")=gnames_firm(tbldom.("Group B"));
writecell(tbl_firm,sprintf([savedir 'anova_firm'],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_firm'],'%s'),'FileType','spreadsheet')


%% --- 3) One-way repeated-measures ANOVA: Brix ---

brix_mat = [brix_firm.Brix(strcmp(brix_firm.Kiwifruit,'Red')), ...
            brix_firm.Brix(strcmp(brix_firm.Kiwifruit,'Green')), ...
            brix_firm.Brix(strcmp(brix_firm.Kiwifruit,'Gold'))];

[p_brix, tbl_brix, stats_brix] = anova1(brix_mat, kiwi_labels, 'on');
fprintf('\n=== Brix ANOVA ===\n');
fprintf('F(%d,%d) = %.3f, p = %.4f\n', tbl_brix{2,3}, tbl_brix{3,3}, tbl_brix{2,5}, p_brix);
[c_brix, ~, ~, gnames_brix] = multcompare(stats_brix, 'Display', 'on');
disp('Post-hoc pairwise (Tukey):'); disp(tbldom);

tbldom = array2table(c_brix,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);

disp('Post-hoc pairwise (Tukey):'); disp(tbldom);

tbldom.("Group A")=gnames_brix(tbldom.("Group A"));
tbldom.("Group B")=gnames_brix(tbldom.("Group B"));
writecell(tbl_firm,sprintf([savedir 'anova_brix'],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_brix'],'%s'),'FileType','spreadsheet')




%% --- Gramm plots ---
clear g
clc
close all
figure('Position',[100 100 1200 500])
mywdith = 1;
% --- Plot 1: Overall Liking ---
g(1,1) = gramm('x', kiwi_long, 'y', liking_long, 'color', kiwi_long);
g(1,1).stat_boxplot2('drawoutlier',0,'width',mywdith);

g(1,1).geom_jitter('width',0.15,'alpha',1);
g(1,1).set_names('x',[],'y','Overall Liking','color','Kiwifruit');
g(1,1).axe_property('XGrid','on','YGrid','on','YLim',[0 10]);
g(1,1).set_color_options('map',thismap(1:3,:));

% --- Plot 2: Firmness ---
g(1,2) = gramm('x', brix_firm.Kiwifruit, 'y', brix_firm.Firmness, 'color', brix_firm.Kiwifruit);
g(1,2).stat_boxplot2('drawoutlier',0,'width',mywdith);

g(1,2).geom_jitter('width',0.15,'alpha',1);
g(1,2).set_names('x',[],'y','Firmness','color','Kiwifruit');
g(1,2).axe_property('XGrid','on','YGrid','on');
g(1,2).set_color_options('map',thismap(1:3,:));

% --- Plot 3: Brix ---
g(1,3) = gramm('x', brix_firm.Kiwifruit, 'y', brix_firm.Brix, 'color', brix_firm.Kiwifruit);
g(1,3).stat_boxplot2('drawoutlier',0,'width',mywdith);
g(1,3).geom_jitter('width',0.15,'alpha',1);
g(1,3).set_names('x',[],'y','Sugar Content (Brix)','color','Kiwifruit');
g(1,3).axe_property('XGrid','on','YGrid','on');
g(1,3).set_color_options('map',thismap(1:3,:));

g.set_text_options('Font','Helvetica','base_size',16);
g.set_point_options('base_size',8);
g.set_order_options('x',0,'color',0);
g.draw();

g.export('file_name','kiwifruit_summary','export_path',savedir,'file_type','png','resolution',300);

g.export('file_name','kiwifruit_summary','export_path',savedir,'file_type','pdf');
% g.export('file_name','kiwifruit_summary','export_path',savedir,'file_type','eps');


