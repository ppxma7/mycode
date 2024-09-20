mypath = '/Volumes/styx/fMRI_benchmark_v2_161023/fMRI_report_analysis/data/';
cd(mypath)



wh_cla = 'CO1_NORD1_classic_WH1_holeHead_rsfMRI_2mm_iso_TR1p5_20231016140529_9_clv.nii';
wh_mtx = 'CO2_NORD1_mtx_WH2_holeHead_rsfMRI_2mm_iso_TR1p5_20231016151649_14_clv.nii';
s_cla = 'CO1_NORD1_classic_S1_ensorimotor_1p25mm_iso_TR2_20231016140529_14_clv.nii';
s_mtx = 'CO2_NORD1_mtx_S2_ensorimotor_1p25mm_iso_TR2_20231016151649_19_clv.nii';

wh_cla_data = MRIread(wh_cla);
wh_mtx_data = MRIread(wh_mtx);
% s_cla_data = MRIread(s_cla);
% s_mtx_data = MRIread(s_mtx);

wh_cla_datav = rot90(wh_cla_data.vol);
wh_mtx_datav = rot90(wh_mtx_data.vol);
% s_cla_datav = rot90(s_cla_data.vol);
% s_mtx_datav = rot90(s_mtx_data.vol);


%% CLASSIC

quickCrop = [51,70,41,60,round(size(wh_cla_datav,3)./2)+5];
%quickCrop = [51,52,41,42,round(size(wh_cla_datav,3)./2)+5];
%quickCrop = [41,60,61,80,round(size(wh_cla_datav,3)./2)];
mypatch = wh_cla_datav(quickCrop(1):quickCrop(2),quickCrop(3):quickCrop(4),quickCrop(5),:);

squatch = squeeze(mypatch);
squatch_rows = mean(squatch,1);
squatch_rowscols = mean(squatch_rows,2);
squatch_t = squeeze(squatch_rowscols);
std_sq = std(squatch,0,3);
std_sq_rows = mean(std_sq,1);

mean_cla = mean(squatch_t);
std_cla = mean(std_sq_rows);
a = squatch_t-mean_cla;
b = std_sq_rows-std_cla;

bloop = figure;
tiledlayout(2,2)
nexttile
imagesc(wh_cla_datav(:,:,quickCrop(5),1))
title(sprintf('slice %d',quickCrop(5)))
clim([0 max(wh_cla_datav(:))])
hold on
rectangle('Position',[quickCrop(3),quickCrop(1),20,20],...
         'LineWidth',2,'LineStyle','--')
colormap viridis
colorbar
nexttile
imagesc(squatch(:,:,1))
title('patch')
colormap viridis
colorbar
clim([0 max(wh_cla_datav(:))])
nexttile([1 2])
plot(1:length(a),a,'LineWidth',2)
hold on
plot(1:length(b),b,'LineWidth',2)
legend('Mean patch','STD patch','FontSize',9,'Location','southeast')
title(sprintf('mean %.0f, std %.0f',mean(squatch_t), mean(std_sq_rows)));
ylim([-1000 1000])
print(bloop,[mypath 'classic_signal_std.png'],'-dpng');

%% MTX
%quickCrop = [51,70,41,60,round(size(wh_mtx_datav,3)./2)+5];
%quickCrop = [41,60,61,80,round(size(wh_cla_datav,3)./2)];
mypatch = wh_mtx_datav(quickCrop(1):quickCrop(2),quickCrop(3):quickCrop(4),quickCrop(5),:);

squatch_mtx = squeeze(mypatch);
squatch_rows_mtx = mean(squatch_mtx,1);
squatch_rowscols_mtx = mean(squatch_rows_mtx,2);
squatch_t_mtx = squeeze(squatch_rowscols_mtx);
std_sq_mtx = std(squatch_mtx,0,3);
std_sq_rows_mtx = mean(std_sq_mtx,1);

mean_mtx = mean(squatch_t_mtx);
std_mtx = mean(std_sq_rows_mtx);
amtx = squatch_t_mtx-mean_mtx;
bmtx = std_sq_rows_mtx-std_mtx;

bloop = figure;
tiledlayout(2,2)
nexttile
imagesc(wh_mtx_datav(:,:,quickCrop(5),1))
title(sprintf('slice %d',quickCrop(5)))
clim([0 max(wh_mtx_datav(:))])
hold on
rectangle('Position',[quickCrop(3),quickCrop(1),20,20],...
         'LineWidth',2,'LineStyle','--')
colormap viridis
colorbar
nexttile
imagesc(squatch_mtx(:,:,1))
title('patch')
colormap viridis
colorbar
clim([0 max(wh_mtx_datav(:))])
nexttile([1 2])
plot(1:length(amtx),amtx,'LineWidth',2)
hold on
plot(1:length(bmtx),bmtx,'LineWidth',2)
legend('Mean patch','STD patch','FontSize',9,'Location','southeast')
title(sprintf('mean %.0f, std %.0f',mean(squatch_t_mtx), mean(std_sq_rows_mtx)));
ylim([-1000 1000])
print(bloop,[mypath 'mtx_signal_std.png'],'-dpng');

%% now plot on same axis

facor = mean(squatch_t_mtx)./mean(squatch_t);
facor_std = mean(std_sq_rows_mtx)./mean(std_sq_rows);
location = 'northeast';
sdfsd = figure;
tiledlayout(2,2)
nexttile([1 2])
plot(squatch_t.*facor,'LineWidth',2)
hold on
plot(squatch_t_mtx,'LineWidth',2)
legend('Mean classic','Mean mtx','FontSize',9,'Location',location)
nexttile([1 2])
plot(std_sq_rows.*facor_std,'LineWidth',2)
hold on
plot(std_sq_rows_mtx,'LineWidth',2)
legend('Std classic','Std mtx','FontSize',9,'Location',location)
print(sdfsd,[mypath 'comparison_signal_std.png'],'-dpng');






