% plot b1
clear variables
close all

%myslice = 25;
mylims = [0 5e8];
mymap = 'plasma';
thispath = '/Volumes/arianthe/funstar_061223/classic/';
thispath2 = '/Volumes/arianthe/funstar_061223/mtx/';

b0_cl = MRIread([thispath 'FUNSTAR_QA+T1_WIP_B0Map_19_1_modulus_seq02.nii']);
b0_cl_data = b0_cl.vol;
b0_cl_data = flipud(b0_cl_data);


nSlices = size(b0_cl_data,3);

montage=20; 
theRound = round(nSlices./montage);
sliceVec = 1:theRound:nSlices;
tiles = length(sliceVec);

grid = factork(length(sliceVec),3);

b0_mtx = MRIread([thispath2 'FUNSTAR_QA_MTX_0612_WIP_B0Map_5_1_modulus_seq02.nii']);
b0_mtx_data = b0_mtx.vol;
b0_mtx_data = flipud(b0_mtx_data);

b0_mtx2 = MRIread([thispath2 'FUNSTAR_QA_MTX_0612_WIP_B0Map_10_1_modulus_seq02.nii']);
b0_mtx2_data = b0_mtx2.vol;
b0_mtx2_data = flipud(b0_mtx2_data);


figure('Position',[100 100 1400 500])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_cl_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'a.u.';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, Classic B0',sliceVec(ii)))
end



filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['b0class' '_steps_' '%d'], tiles));
print(filename,'-dpng')



figure('Position',[100 100 1400 500])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_mtx_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'a.u.';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B0',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['b0mtx5' '_steps_' '%d'], tiles));
print(filename,'-dpng')


figure('Position',[100 100 1400 500])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_mtx2_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'a.u.';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B0',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['b0mtx10' '_steps_' '%d'], tiles));
print(filename,'-dpng')

%% also plot field maps
mymap = 'plasma';
mylims = [-200 200];

b0_cl = MRIread([thispath 'FUNSTAR_QA+T1_WIP_B0Map_19_1_typemr18_seq05.nii']);
b0_cl_data = b0_cl.vol;
b0_cl_data = flipud(b0_cl_data);


nSlices = size(b0_cl_data,3);

montage=20; 
theRound = round(nSlices./montage);
sliceVec = 1:theRound:nSlices;
tiles = length(sliceVec);

grid = factork(length(sliceVec),3);

b0_mtx = MRIread([thispath2 'FUNSTAR_QA_MTX_0612_WIP_B0Map_5_1_typemr18_seq05.nii']);
b0_mtx_data = b0_mtx.vol;
b0_mtx_data = flipud(b0_mtx_data);

b0_mtx2 = MRIread([thispath2 'FUNSTAR_QA_MTX_0612_WIP_B0Map_10_1_typemr18_seq05.nii']);
b0_mtx2_data = b0_mtx2.vol;
b0_mtx2_data = flipud(b0_mtx2_data);

figure('Position',[100 100 1400 500])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_cl_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'Hz';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, Classic B0',sliceVec(ii)))
end

filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['field_b0class' '_steps_' '%d'], tiles));
print(filename,'-dpng')

figure('Position',[100 100 1400 500])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_mtx_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'Hz';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B0',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['field_b0mtx5' '_steps_' '%d'], tiles));
print(filename,'-dpng')

figure('Position',[100 100 1400 500])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_mtx2_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'Hz';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B0',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['field_b0mtx10' '_steps_' '%d'], tiles));
print(filename,'-dpng')


%% plot b1
clear variables
close all

%myslice = 25;
mylims = [0 140];
mymap = 'plasma';
thispath = '/Volumes/arianthe/funstar_061223/classic/';
thispath2 = '/Volumes/arianthe/funstar_061223/mtx/';

b1_cl = MRIread([thispath 'FUNSTAR_QA+T1_DREAM_B1_20_1_modulus_seq09.nii']);
b1_cl_data = b1_cl.vol;
b1_cl_data = flipud(b1_cl_data);

nSlices = size(b1_cl_data,3);

montage=20; 
theRound = round(nSlices./montage);
sliceVec = 1:theRound:nSlices;
tiles = length(sliceVec);

grid = factork(length(sliceVec),4);

b1_mtx = MRIread([thispath2 'FUNSTAR_QA_MTX_0612_DREAM_B1_6_1_modulus_seq09.nii']);
b1_mtx_data = b1_mtx.vol;
b1_mtx_data = flipud(b1_mtx_data);

b1_mtx2 = MRIread([thispath2 'FUNSTAR_QA_MTX_0612_DREAM_B1_11_1_modulus_seq09.nii']);
b1_mtx2_data = b1_mtx2.vol;
b1_mtx2_data = flipud(b1_mtx2_data);



horazon = 1600;
vertazon = 800;

figure('Position',[100 100 horazon vertazon])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b1_cl_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = '%';
   %clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, Classic B1',sliceVec(ii)))
end

filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['b1class' '_steps_' '%d'], tiles));
print(filename,'-dpng')

figure('Position',[100 100 horazon vertazon])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b1_mtx_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = '%';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B1',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['b1mtx_6' '_steps_' '%d'], tiles));
print(filename,'-dpng')

figure('Position',[100 100 horazon vertazon])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b1_mtx2_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = '%';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B1',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_061223/', ...
    sprintf(['b1mtx_11' '_steps_' '%d'], tiles));
print(filename,'-dpng')


