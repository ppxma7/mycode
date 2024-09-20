% plot b1
clear variables
close all

%myslice = 25;
%mylims = [-400 400];
mymap = 'plasma';
thispath = '/Volumes/arianthe/Surface_coil_241123/';
%thispath2 = '/Volumes/arianthe/funstar_201123/mtx/';

b0_cl = MRIread([thispath 'surface_coil_test_WIP_WIP_B0Mapcalibrate_SENSE_4_1_modulus_seq02.nii']);
b0_cl_data = b0_cl.vol;
b0_cl_data = flipud(b0_cl_data);

%myslice = round(size(b0_cl_data,3)./2);

%theRound = round(size(b0_cl_data,3)./9);
nSlices = size(b0_cl_data,3);
%sliceVec = 1:theRound:nSlices;
%tiles = length(sliceVec);

%grid = factor(tiles);

montage=10; % for tiles
theRound = round(nSlices./montage);
sliceVec = 1:theRound:nSlices;
tiles = length(sliceVec);

grid = factork(length(sliceVec),3);




b0_mtx = MRIread([thispath 'surface_coil_test_WIP_WIP_B0Mapcalibrate_SENSE_4_1_typemr18_seq05.nii']);
b0_mtx_data = b0_mtx.vol;
b0_mtx_data = flipud(b0_mtx_data);

b1 = MRIread([thispath 'surface_coil_test_DREAM_B1_5_1_modulus_seq09.nii']);
b1_data = b1.vol;
b1_data = flipud(b1_data);

nS2 = size(b1_data,3);
theRound2 = round(nS2./montage);
sliceVec2 = 1:theRound2:nS2;
tiles2 = length(sliceVec2);

grid2 = factork(length(sliceVec2),3);


%%
%mylims = [0 1e9];
figure('Position',[100 100 1800 700])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_cl_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    %c.Label.String = 'Hz';
    %clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, Classic B0 seq 02',sliceVec(ii)))
end

filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/', ...
    sprintf(['b01' '_steps_' '%d'], tiles));
print(filename,'-dpng')

mylims = [-400 400];
figure('Position',[100 100 1800 700])
tiledlayout(grid(1),grid(2))
for ii = 1:tiles
    nexttile
    imagesc(b0_mtx_data(:,:,sliceVec(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    %c.Label.String = 'Hz';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, Classic B0 seq 05',sliceVec(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/', ...
    sprintf(['b02' '_steps_' '%d'], tiles));
print(filename,'-dpng')

mylims = [0 150];
figure('Position',[100 100 1800 700])
tiledlayout(grid2(1),grid2(2))
for ii = 1:tiles2
    nexttile
    imagesc(b1_data(:,:,sliceVec2(ii)))
    colormap(mymap)
    c = colorbar;
    c.Label
    c.Label.String = '%';
    clim([mylims(1) mylims(2)])
    axis square
    title(sprintf('slice %d, Classic B1 seq 09',sliceVec2(ii)))
end
filename = fullfile('/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/', ...
    sprintf(['b1' '_steps_' '%d'], tiles));
print(filename,'-dpng')




