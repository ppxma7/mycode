% plot b0 and b1
clear variables
close all

myslice = 25;
mylims = [-400 400];

thispath = '/Volumes/styx/fMRI_benchmark_v2_161023/classic/structurals/';
thispath2 = '/Volumes/styx/fMRI_benchmark_v2_161023/mtx/structurals/';



b0_cl = MRIread([thispath 'classic_WIPB0Map_20231016140529_5_fieldmaphz.nii']);
b0_cl_data = b0_cl.vol;
b0_cl_data = flipud(b0_cl_data);

b0_mtx = MRIread([thispath2 'mtx_WIPB0Map_20231016151649_5_fieldmaphz.nii']);
b0_mtx_data = b0_mtx.vol;
b0_mtx_data = flipud(b0_mtx_data);

b0_cl2 = MRIread([thispath 'classic_WIPB0Map_20231016140529_11_fieldmaphz.nii']);
b0_cl_data2 = b0_cl2.vol;
b0_cl_data2 = flipud(b0_cl_data2);

b0_mtx2 = MRIread([thispath2 'mtx_WIPB0Map_20231016151649_16_fieldmaphz.nii']);
b0_mtx_data2 = b0_mtx2.vol;
b0_mtx_data2 = flipud(b0_mtx_data2);

b0_cl3 = MRIread([thispath 'classic_WIPB0Map_20231016140529_16_fieldmaphz.nii']);
b0_cl_data3 = b0_cl3.vol;
b0_cl_data3 = flipud(b0_cl_data3);

b0_mtx3 = MRIread([thispath2 'mtx_WIPB0Map_20231016151649_22_fieldmaphz.nii']);
b0_mtx_data3 = b0_mtx3.vol;
b0_mtx_data3 = flipud(b0_mtx_data3);

figure('Position',[100 100 800 1000])
tiledlayout(3,2)
nexttile
imagesc(b0_cl_data(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = 'Hz';
clim([mylims(1) mylims(2)])
title('Classic B0')
nexttile
imagesc(b0_mtx_data(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = 'Hz';
clim([mylims(1) mylims(2)])
title('MTX B0')

nexttile
imagesc(b0_cl_data2(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = 'Hz';
clim([mylims(1) mylims(2)])
title('Classic B0')
nexttile
imagesc(b0_mtx_data2(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = 'Hz';
clim([mylims(1) mylims(2)])
title('MTX B0')

nexttile
imagesc(b0_cl_data3(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = 'Hz';
clim([mylims(1) mylims(2)])
title('Classic B0')
nexttile
imagesc(b0_mtx_data3(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = 'Hz';
clim([mylims(1) mylims(2)])
title('MTX B0')

filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/fMRI_benchmark_oct_2023/', ...
    sprintf(['b0classmtx' '_slice_' '%d'], myslice));
print(filename,'-dpng')

%% Now B1 maps

%myslice = 20;
mylims = [0 150];

thispath = '/Volumes/styx/fMRI_benchmark_v2_161023/classic/b1/';
thispath2 = '/Volumes/styx/fMRI_benchmark_v2_161023/mtx/b1/';

b0_cl = MRIread([thispath 'fMRI_benchmark_v2_DREAM_B1_6_1_modulus_seq09.nii']);
b0_cl_data = b0_cl.vol;
b0_cl_data = flipud(b0_cl_data);

b0_mtx = MRIread([thispath2 'fMRI_benchmark_MTX_DREAM_B1_6_1_modulus_seq09.nii']);
b0_mtx_data = b0_mtx.vol;
b0_mtx_data = flipud(b0_mtx_data);

b0_cl2 = MRIread([thispath 'fMRI_benchmark_v2_DREAM_B1_12_1_modulus_seq09.nii']);
b0_cl_data2 = b0_cl2.vol;
b0_cl_data2 = flipud(b0_cl_data2);

b0_mtx2 = MRIread([thispath2 'fMRI_benchmark_MTX_DREAM_B1_17_1_modulus_seq09.nii']);
b0_mtx_data2 = b0_mtx2.vol;
b0_mtx_data2 = flipud(b0_mtx_data2);

b0_cl3 = MRIread([thispath 'fMRI_benchmark_v2_DREAM_B1_17_1_modulus_seq09.nii']);
b0_cl_data3 = b0_cl3.vol;
b0_cl_data3 = flipud(b0_cl_data3);

b0_mtx3 = MRIread([thispath2 'fMRI_benchmark_MTX_DREAM_B1_23_1_modulus_seq09.nii']);
b0_mtx_data3 = b0_mtx3.vol;
b0_mtx_data3 = flipud(b0_mtx_data3);

figure('Position',[100 100 800 1000])
tiledlayout(3,2)
nexttile
imagesc(b0_cl_data(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = '%';
clim([mylims(1) mylims(2)])
title('Classic B1')
nexttile
imagesc(b0_mtx_data(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = '%';
clim([mylims(1) mylims(2)])
title('MTX B1')

nexttile
imagesc(b0_cl_data2(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = '%';
clim([mylims(1) mylims(2)])
title('Classic B1')
nexttile
imagesc(b0_mtx_data2(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = '%';
clim([mylims(1) mylims(2)])
title('MTX B1')

nexttile
imagesc(b0_cl_data3(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = '%';
clim([mylims(1) mylims(2)])
title('Classic B1')
nexttile
imagesc(b0_mtx_data3(:,:,myslice))
colormap viridis
c = colorbar;
c.Label
c.Label.String = '%';
clim([mylims(1) mylims(2)])
title('MTX B1')

filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/fMRI_benchmark_oct_2023/', ...
    sprintf(['b1classmtx' '_slice_' '%d'], myslice));
print(filename,'-dpng')














