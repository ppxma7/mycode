% plot b1
clear variables
close all

%myslice = 25;
mylims = [-400 400];
mymap = 'plasma';
thispath = '/Volumes/arianthe/funstar_201123/classic/';
thispath2 = '/Volumes/arianthe/funstar_201123/mtx/';

b0_cl = MRIread([thispath 'funstar_201123_WIPB0Map_20231120141656_6_fieldmaphz.nii']);
b0_cl_data = b0_cl.vol;
b0_cl_data = flipud(b0_cl_data);

%myslice = round(size(b0_cl_data,3)./2);

theRound = round(size(b0_cl_data,3)./9);
nSlices = size(b0_cl_data,3);
sliceVec = 1:theRound:nSlices;
tiles = length(sliceVec);

grid = factor(tiles);

b0_mtx = MRIread([thispath2 'funstar_201123_WIPB0Map_20231120160009_5_fieldmaphz.nii']);
b0_mtx_data = b0_mtx.vol;
b0_mtx_data = flipud(b0_mtx_data);


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

filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_201123/', ...
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
    c.Label.String = 'Hz';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B0',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_201123/', ...
    sprintf(['b0mtx' '_steps_' '%d'], tiles));
print(filename,'-dpng')


%% plot b1
clear variables
close all

%myslice = 25;
mylims = [0 130];
mymap = 'plasma';
thispath = '/Volumes/arianthe/funstar_201123/classic/';
thispath2 = '/Volumes/arianthe/funstar_201123/mtx/';

b1_cl = MRIread([thispath 'FUNSTAR_QA_DREAM_B1_7_1_modulus_seq09.nii']);
b1_cl_data = b1_cl.vol;
b1_cl_data = flipud(b1_cl_data);

theRound = round(size(b1_cl_data,3)./9);
nSlices = size(b1_cl_data,3);
sliceVec = 1:theRound:nSlices;
tiles = length(sliceVec);

grid = factor(tiles);

b1_mtx = MRIread([thispath2 'FUNSTAR_QA_MTX_DREAM_B1_6_1_modulus_seq09.nii']);
b1_mtx_data = b1_mtx.vol;
b1_mtx_data = flipud(b1_mtx_data);


figure('Position',[100 100 1400 1000])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b1_cl_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'Hz';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, Classic B1',sliceVec(ii)))
end

filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_201123/', ...
    sprintf(['b1class' '_steps_' '%d'], tiles));
print(filename,'-dpng')

figure('Position',[100 100 1400 1000])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b1_mtx_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = 'Hz';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, MTX B1',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_201123/', ...
    sprintf(['b1mtx' '_steps_' '%d'], tiles));
print(filename,'-dpng')



