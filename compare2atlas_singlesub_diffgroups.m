% try and replicate Ken's analysis

mapcol = brewermap(128,'*RdBu');

a = 0;
b = 2;
bb = 1;
myempty = zeros(5,5);

% get groups
mycent_LD_inj = mycentL(:,:,LD_inj_idx);
mycent_RD_inj = mycentR(:,:,RD_inj_idx);

mycent_LD_nj = mycentL(:,:,RD_inj_idx);
mycent_RD_nj = mycentR(:,:,LD_inj_idx);

mycent_LD_hc = mycentL(:,:,1:lenHC);
mycent_RD_hc = mycentR(:,:,1:lenHC);

% mean groups
inj_LD_mean = mean(mycent_LD_inj,3);
inj_RD_mean = mean(mycent_RD_inj,3);
inj_mean = [inj_LD_mean myempty; myempty inj_RD_mean];

nj_LD_mean = mean(mycent_LD_nj,3);
nj_RD_mean = mean(mycent_RD_nj,3);
nj_mean = [nj_LD_mean myempty; myempty nj_RD_mean];

hc_LD_mean = mean(mycent_LD_hc,3);
hc_RD_mean = mean(mycent_RD_hc,3);
hc_mean = [hc_LD_mean myempty; myempty hc_RD_mean];

figure('Position',[100 100 1000 400])
tiledlayout(1,3)
nexttile
imagesc(hc_mean)
title('Controls')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(inj_mean)
title('Injured')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(nj_mean)
title('Healthy')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])

filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'kv_mats');
print(filename,'-dpng')



%% plotting

% let's stick with figure of merit
% we care how D1 compares to atlas D1, how D2 compares to atlas D2 etc.
close all
clear myfom*

myfom_LD_inj = fomL(:,LD_inj_idx);
myfom_RD_inj = fomR(:,RD_inj_idx);

myfom_LD_nj = fomL(:,RD_inj_idx);
myfom_RD_nj = fomR(:,LD_inj_idx);

myfom_LD_hc = fomL(:,1:lenHC);
myfom_RD_hc = fomR(:,1:lenHC);

%instead of FOM, let's take diag of the central tendency
% for ii = 1:length(LD_inj_idx)
%     myfom_LD_inj(:,ii) = diag(mycentL(:,:,LD_inj_idx(ii)));
% end
% for ii = 1:length(RD_inj_idx)
%     myfom_RD_inj(:,ii) = diag(mycentR(:,:,RD_inj_idx(ii)));
% end
% for ii = 1:length(RD_inj_idx)
%     myfom_LD_nj(:,ii) = diag(mycentL(:,:,RD_inj_idx(ii)));
% end
% for ii = 1:length(LD_inj_idx)
%     myfom_RD_nj(:,ii) = diag(mycentR(:,:,LD_inj_idx(ii)));
% end
% for ii = 1:lenHC
%     myfom_LD_hc(:,ii) = diag(mycentL(:,:,ii));
% end
% for ii = 1:lenHC
%     myfom_RD_hc(:,ii) = diag(mycentR(:,:,ii));
% end



tmpHc = [myfom_LD_hc myfom_RD_hc];
tmpInj = [myfom_LD_inj myfom_RD_inj];
tmpNj = [myfom_LD_nj myfom_RD_nj];

tmpHcSize = size(tmpHc);
tmpInjSize = size(tmpInj);
tmpNjSize = size(tmpNj);

gFOM_hc = reshape(tmpHc,tmpHcSize(1).*tmpHcSize(2),1);
gFOM_inj = reshape(tmpInj,tmpInjSize(1).*tmpInjSize(2),1);
gFOM_nj = reshape(tmpNj,tmpNjSize(1).*tmpNjSize(2),1);


dxo = transpose(repmat({'D1','D2','D3','D4','D5'},1,1));
dxoshr_hc  = repmat(dxo,1,tmpHcSize(2));
dxoshr_inj = repmat(dxo,1,tmpInjSize(2));
dxoshr_nj  = repmat(dxo,1,tmpNjSize(2));
gDXR_hc =  reshape(dxoshr_hc,[tmpHcSize(1).*tmpHcSize(2) 1]);
gDXR_inj = reshape(dxoshr_inj,[tmpInjSize(1).*tmpInjSize(2) 1]);
gDXR_nj =  reshape(dxoshr_nj,[tmpNjSize(1).*tmpNjSize(2) 1]);



gLR_hc =  [repmat({'LD'},length(gFOM_hc)./2,1); repmat({'RD'},length(gFOM_hc)./2,1)];
gLR_inj = [repmat({'LD'},length(gFOM_inj)./2,1); repmat({'RD'},length(gFOM_inj)./2,1)];
gLR_nj =  [repmat({'LD'},length(gFOM_nj)./2,1); repmat({'RD'},length(gFOM_nj)./2,1)];


%plot
mylim = [-0.7 3];
figure('Position',[100 100 1400 400])
clear g

g(1,1) = gramm('x',gDXR_hc,'y',gFOM_hc,'color',gLR_hc);
g(1,1).geom_jitter('dodge',0.7,'alpha',1)%,'edgecolor',[1 1 1])
g(1,1).no_legend()
g(1,1).set_title('Controls')

g(1,2) = gramm('x',gDXR_inj,'y',gFOM_inj,'color',gLR_inj);
g(1,2).geom_jitter('dodge',0.7,'alpha',1)%,'edgecolor',[1 1 1])
g(1,2).no_legend()
g(1,2).set_title('Injured hand')

g(1,3) = gramm('x',gDXR_nj,'y',gFOM_nj,'color',gLR_nj);
g(1,3).geom_jitter('dodge',0.7,'alpha',1)%,'edgecolor',[1 1 1])
g(1,3).no_legend()
g(1,3).set_title('Healthy hand')

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',6)
g.axe_property('XGrid','on','YGrid','on','YLim',[mylim(1) mylim(2)])
g.set_names('x', 'Digit', 'y', 'FIGURE OF MERIT ')

g.draw()

g(1,1).update()
g(1,1).stat_boxplot2('dodge', 1,'alpha', 0.7, 'linewidth', 1, 'drawoutlier',0)
g(1,1).no_legend()

g(1,2).update()
g(1,2).stat_boxplot2('dodge', 1,'alpha', 0.7, 'linewidth', 1, 'drawoutlier',0)
g(1,2).no_legend()

g(1,3).update()
g(1,3).stat_boxplot2('dodge', 1,'alpha', 0.7, 'linewidth', 1, 'drawoutlier',0)
g(1,3).no_legend()

g.draw()

filename = 'kv_test_CTDIAG';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')




%% plot all together
tmp = [myfom_LD_hc myfom_LD_inj myfom_LD_nj myfom_RD_hc myfom_RD_inj myfom_RD_nj];
gFOM = reshape(tmp,[5*100 1]);
dxoshr = repmat(dxo,1,100);
gDXR = reshape(dxoshr,[5*100 1]);
gLR = [repmat({'LD'},250,1); repmat({'RD'},250,1)];
gGRP = [repmat({'Controls'},length(myfom_LD_hc).*5, 1); ...
    repmat({'Injured'},length(myfom_LD_inj).*5, 1); ...
    repmat({'Healthy'},length(myfom_LD_nj).*5, 1);...
    repmat({'Controls'},length(myfom_RD_hc).*5, 1); ...
    repmat({'Injured'},length(myfom_RD_inj).*5, 1); ...
    repmat({'Healthy'},length(myfom_RD_nj).*5, 1)];


mylim = [-0.7 3];
figure('Position',[100 100 600 400])
clear g
g = gramm('x',gGRP,'y',gFOM,'color',gLR);
g.geom_jitter('dodge',0.7,'alpha',1)%,'edgecolor',[1 1 1])
g.no_legend()
g.set_title('All digits')

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',6)
g.axe_property('XGrid','on','YGrid','on','YLim',[mylim(1) mylim(2)])
g.set_names('x', 'Digit', 'y', 'FIGURE OF MERIT ')
g.set_order_options('x',0)

g.draw()

g.update()
g.stat_boxplot2('dodge', 1,'alpha', 0.7, 'linewidth', 1, 'drawoutlier',0)
%g.no_legend()
g.set_order_options('x',0)


g.draw()

filename = 'kv_test_grp_CTDIAG';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')


%% stats
[p1,tbl,stat] = anova1(gFOM,gGRP);
[p2,tbl,stats,terms] = anovan(gFOM,{gGRP gDXR});
MC1 = multcompare(stats,"Dimension",1); % group
MC2 = multcompare(stats,"Dimension",2); % digit


%% repair zone specific? 
% make assumption that we only care about 1-3 for median 
% and D4-5 for ulnar
% so restrict FOM by this.
close all
clc
myfom_LD_media = fomL(:,LD_media_idx);
myfom_RD_media = fomR(:,RD_media_idx);
myfom_LD_ulnar = fomL(:,LD_ulnar_idx);
myfom_RD_ulnar = fomR(:,RD_ulnar_idx);
myfom_LD_both = fomL(:,LD_both_idx);
myfom_RD_both = fomR(:,RD_both_idx);

myfom_LD_media_nj = fomL(:,RD_media_idx);
myfom_RD_media_nj = fomR(:,LD_media_idx);
myfom_LD_ulnar_nj = fomL(:,RD_ulnar_idx);
myfom_RD_ulnar_nj = fomR(:,LD_ulnar_idx);
myfom_LD_both_nj = fomL(:,RD_both_idx);
myfom_RD_both_nj = fomR(:,LD_both_idx);


v1 = vectify(myfom_LD_media(1:3,:));
v2 = vectify(myfom_LD_ulnar(4:5,:));
v3 = vectify(myfom_LD_media_nj(1:3,:));
v4 = vectify(myfom_LD_ulnar_nj(4:5,:));
v1r = vectify(myfom_RD_media(1:3,:));
v2r = vectify(myfom_RD_ulnar(4:5,:));
v3r = vectify(myfom_RD_media_nj(1:3,:));
v4r = vectify(myfom_RD_ulnar_nj(4:5,:));

gFOM_rzs = [myfom_LD_hc(:); v1;  v2;  myfom_LD_both(:); v3;  v4;  myfom_LD_both_nj(:);...
           myfom_RD_hc(:); v1r; v2r; myfom_RD_both(:); v3r; v4r; myfom_RD_both_nj(:) ];

gGRP_rzs = [repmat({'Controls'},  size(myfom_LD_hc,1).*size(myfom_LD_hc,2), 1); ...
    repmat({'Injured Median'},    length(v1), 1); ...
    repmat({'Injured Ulnar'},     length(v2), 1);...
    repmat({'Injured Both'},      size(myfom_LD_both,1).*size(myfom_LD_both,2), 1); ...
    repmat({'Healthy Median'},    length(v3), 1); ...
    repmat({'Healthy Ulnar'},     length(v4), 1);...
    repmat({'Healthy Both'},      size(myfom_LD_both_nj,1).*size(myfom_LD_both_nj,2),1);...
    repmat({'Controls'},          size(myfom_RD_hc,1).*size(myfom_RD_hc,2), 1); ...
    repmat({'Injured Median'},    length(v1r), 1); ...
    repmat({'Injured Ulnar'},     length(v2r), 1);...
    repmat({'Injured Both'},      size(myfom_RD_both,1).*size(myfom_RD_both,2), 1); ...
    repmat({'Healthy Median'},    length(v3r), 1); ...
    repmat({'Healthy Ulnar'},     length(v4r), 1);...
    repmat({'Healthy Both'},      size(myfom_RD_both_nj,1).*size(myfom_RD_both_nj,2),1);...
    ];

gGRP = [repmat({'Controls'}, size(myfom_LD_hc,1).*size(myfom_LD_hc,2), 1); ...
    repmat({'Injured'},      length(v1)+length(v2)+size(myfom_LD_both,1).*size(myfom_LD_both,2), 1); ...
    repmat({'Healthy'},      length(v3)+length(v4)+size(myfom_LD_both_nj,1).*size(myfom_LD_both_nj,2), 1);...
    repmat({'Controls'},     size(myfom_RD_hc,1).*size(myfom_RD_hc,2), 1); ...
    repmat({'Injured'},      length(v1r)+length(v2r)+size(myfom_RD_both,1).*size(myfom_RD_both,2), 1); ...
    repmat({'Healthy'},      length(v3r)+length(v4r)+size(myfom_RD_both_nj,1).*size(myfom_RD_both_nj,2), 1)];


gLR_rzs = [repmat({'LD'},208,1); repmat({'RD'},208,1)];


mylim = [-0.7 3];
figure('Position',[100 100 600 400])
clear g
g = gramm('x',gGRP,'y',gFOM_rzs,'color',gGRP_rzs);
%g = gramm('x',gGRP,'y',gFOM_rzs,'color',gLR_rzs);
g.geom_jitter('dodge',0.7,'alpha',1)%,'edgecolor',[1 1 1])
g.no_legend()
g.set_title('All digits')

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',6)
g.axe_property('XGrid','on','YGrid','on','YLim',[mylim(1) mylim(2)])
g.set_names('x', 'Digit', 'y', 'FIGURE OF MERIT ')
g.set_order_options('x',0)

g.draw()

g.update()
g.stat_boxplot2('dodge', 1,'alpha', 0.7, 'linewidth', 1, 'drawoutlier',0)
%g.no_legend()
g.set_order_options('x',0)


g.draw()
%filename = 'kv_test_grp_RZS_CTDIAG';
filename = 'kv_test_grp_RZS_diffgroup_CTDIAG_LR';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')



%% stats
[p1,tbl,stat] = anova1(gFOM_rzs,gGRP_rzs);

%% typicality measures?

% typicality is just a correlation of each subject's CT matrix to the 
% group standard, so like the atlas in our case

% here is the CT from the atlas based on the LVO 
load(['/Users/' userName '/Documents/MATLAB/digitAtlas/sundries/lv_surf_useful.mat'],'LD_central_tendency','RD_central_tendency')

atlas_mean_CTLD = mean(LD_central_tendency,3);
atlas_mean_CTRD = mean(RD_central_tendency,3);


for ii = 1:length(mycentL)
    RHO(ii) = corr2(mycentL(:,:,ii),atlas_mean_CTLD);
    RHOr(ii) = corr2(mycentR(:,:,ii),atlas_mean_CTRD);
    %RHO(ii) = std2(mycentL(:,:,ii),atlas_mean_CTLD);
    %RHOr(ii) = std2(mycentR(:,:,ii),atlas_mean_CTRD);
end

RHO = RHO(:);
RHOr = RHOr(:);
boog = subs(:);


figure('Position',[100 100 1400 400])

g = gramm('x',[subs subs],'y',[RHO; RHOr],'color',[repmat({'LD'},50,1), repmat({'RD'},50,1)]);
g.geom_point()
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
g.axe_property('XGrid','on','YGrid','on')
g.set_names('x', 'subject', 'y', '2D correlation')
g.set_title('Correlation to atlas CT')
g.set_order_options('x',0)
g.draw()
filename = 'kv_typicality_atlas';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')


filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'corr2atlas_text.txt');
%print(filename,'-dpng')

T = table(RHO, RHOr, boog, 'VariableNames', {'corr_left','corr_right', 'SubjectID'});
% Set display format for numeric data
formatSpec = '%.3f';  % Display format with 3 decimal places
T.corr_left = cellfun(@(x) sprintf(formatSpec, x), num2cell(T.corr_left), 'UniformOutput', false);
T.corr_right = cellfun(@(x) sprintf(formatSpec, x), num2cell(T.corr_right), 'UniformOutput', false);

writetable(T, filename, 'Delimiter', ' ');  % Save as space-delimited text file


























