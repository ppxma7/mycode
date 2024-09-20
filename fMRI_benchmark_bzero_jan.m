% plot b0
clear variables
close all

%myslice = 25;
%mylims = [0 5e8];
mymap = 'plasma';
thispath = '/Volumes/hades/FUNSTAR_QA_050124/B0/';

filenames = {'FUNSTAR_QA_WIP_B0Map_5_1_modulus_seq02.nii',...
    'FUNSTAR_QA_WIP_B0Map_13_1_modulus_seq02.nii',...
    'FUNSTAR_QA_WIP_B0Map_14_1_modulus_seq02.nii',...
    'FUNSTAR_QA_WIP_B0Map_15_1_modulus_echo01.nii',...
    'FUNSTAR_QA_WIP_B0Map_15_1_modulus_echo02.nii',...
    'FUNSTAR_QA_WIP_B0Map_15_1_phase_echo01.nii',...
    'FUNSTAR_QA_WIP_B0Map_15_1_phase_echo02.nii',...
    'FUNSTAR_QA_WIP_B0Map_16_1_modulus_echo01.nii',...
    'FUNSTAR_QA_WIP_B0Map_16_1_modulus_echo02.nii',...
    'FUNSTAR_QA_WIP_B0Map_16_1_phase_echo01.nii',...
    'FUNSTAR_QA_WIP_B0Map_16_1_phase_echo02.nii'};


for ii = 1:length(filenames)

    if contains(filenames{ii},'phase')
        mylims = [0 4000];
    else
        mylims = [0 1600];
    end

    b0_cl = MRIread([thispath filenames{ii}]);
    b0_cl_data = b0_cl.vol;
    b0_cl_data = flipud(b0_cl_data);

    nSlices = size(b0_cl_data,3);

    montage=20;
    theRound = round(nSlices./montage);
    sliceVec = 1:theRound:nSlices;
    tiles = length(sliceVec);

    grid = factork(length(sliceVec),3);

    figure('Position',[100 100 1400 500])
    tiledlayout(grid(1),grid(2))
    for jj = 1:tiles
        nexttile
        imagesc(b0_cl_data(:,:,sliceVec(jj)))
        colormap(mymap)
        c = colorbar;
        c.Label
        c.Label.String = 'a.u.';
        clim([mylims(1) mylims(2)])
        axis square
        title(sprintf('slice %d, Classic B0',sliceVec(jj)))
    end

    filename = fullfile('/Users/spmic/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_050124/', ...
        sprintf(['b0_mod' '_steps_' '%d' '_' '%d'], tiles,ii));
    print(filename,'-dpng')


end

%% also plot field maps
clear variables
close all
mymap = 'plasma';
thispath = '/Volumes/hades/FUNSTAR_QA_050124/B0/';

filenames = {'FUNSTAR_QA_WIP_B0Map_5_1_typemr18_seq05.nii',...
    'FUNSTAR_QA_WIP_B0Map_13_1_typemr18_seq05.nii',...
    'FUNSTAR_QA_WIP_B0Map_14_1_typemr18_seq05.nii'};

mylims = [0 2500];

for ii = 1:length(filenames)

    b0_cl = MRIread([thispath filenames{ii}]);
    b0_cl_data = b0_cl.vol;
    b0_cl_data = flipud(b0_cl_data);

    nSlices = size(b0_cl_data,3);

    montage=20;
    theRound = round(nSlices./montage);
    sliceVec = 1:theRound:nSlices;
    tiles = length(sliceVec);

    grid = factork(length(sliceVec),3);

    figure('Position',[100 100 1400 500])
    tiledlayout(grid(1),grid(2))
    for jj = 1:tiles
        nexttile
        imagesc(b0_cl_data(:,:,sliceVec(jj)))
        colormap(mymap)
        c = colorbar;
        c.Label
        c.Label.String = 'Hz';
        clim([mylims(1) mylims(2)])
        axis square
        title(sprintf('slice %d, Classic B0',sliceVec(jj)))
    end

    filename = fullfile('/Users/spmic/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_050124/', ...
        sprintf(['b0_fieldmaps' '_steps_' '%d' '_' '%d'], tiles,ii));
    print(filename,'-dpng')


end

%% also plot b1
clear variables
close all
mymap = 'plasma';
thispath = '/Volumes/hades/FUNSTAR_QA_050124/B1/';

filenames = {'FUNSTAR_QA_DREAM_B1_6_1_modulus_seq09.nii',...
    'FUNSTAR_QA_DREAM_B1_6_1_phase_seq09.nii'};

for ii = 1:length(filenames)

    % if contains(filenames{ii},'phase')
    %     mylims = [0 4000];
    % else
    %     mylims = [0 1600];
    % end

    b0_cl = MRIread([thispath filenames{ii}]);
    b0_cl_data = b0_cl.vol;
    b0_cl_data = flipud(b0_cl_data);

    nSlices = size(b0_cl_data,3);

    montage=20;
    theRound = round(nSlices./montage);
    sliceVec = 1:theRound:nSlices;
    tiles = length(sliceVec);

    grid = factork(length(sliceVec),3);

    figure('Position',[100 100 1400 500])
    tiledlayout(grid(1),grid(2))
    for jj = 1:tiles
        nexttile
        imagesc(b0_cl_data(:,:,sliceVec(jj)))
        colormap(mymap)
        c = colorbar;
        c.Label
        c.Label.String = '%';
        %clim([mylims(1) mylims(2)])
        axis square
        title(sprintf('slice %d, Classic B1',sliceVec(jj)))
    end

    filename = fullfile('/Users/spmic/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/benchmark_testing_7T/funstar_050124/', ...
        sprintf(['b1_mod' '_steps_' '%d' '_' '%d'], tiles,ii));
    print(filename,'-dpng')
end

