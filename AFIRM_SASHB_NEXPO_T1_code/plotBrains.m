% script to visualise brains and masks from FAST
close all
clear variables
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/sashb_mprage_images/'];

mypath='/Volumes/nemosine/SAN/SASHB/inputs/';


% subjects = {'SASHB_4_1', 'SASHB_4_2', 'SASHB_5_1', 'SASHB_5_2', 'SASHB_6_1' ...
%     'SASHB_6_2', 'SASHB_7_1', 'SASHB_7_2'};

%subjects = {'SASHB_1_1', 'SASHB_1_2', 'SASHB_2_1', 'SASHB_2_2', 'SASHB_3_1' ...
    %'SASHB_3_2'};
subjects = {'SASHB_7_2'};

for ii = 1:length(subjects)
    MPRAGEdir = fullfile(mypath,subjects{ii},'/MPRAGE/');
    %MPRAGEfile = fullfile(MPRAGEdir,'16905_005_MPRAGE_optibrain.nii.gz');
    %MPRAGEfile = fullfile(MPRAGEdir,'17880002_MPRAGE_optibrain.nii.gz');
    %MPRAGEfile = fullfile(MPRAGEdir,'156862_005_MPRAGE_optibrain.nii.gz');
    MPRAGEfile = fullfile(MPRAGEdir,[subjects{ii} '_MPRAGE_optibrain.nii.gz']);

    brain = niftiread(MPRAGEfile);

    brain_no_ext = extractBefore(MPRAGEfile,'.');
    %if length(subjects) > 1
        brain_no_ext = strrep(brain_no_ext,'opti','');
    %end

    pve0  = niftiread([brain_no_ext '_pve_0.nii.gz']); % CSF
    pve1  = niftiread([brain_no_ext '_pve_1.nii.gz']); % GM
    pve2  = niftiread([brain_no_ext '_pve_2.nii.gz']); % WM


    brain = double(brain);
    pve0  = double(pve0);
    pve1  = double(pve1);
    pve2  = double(pve2);

    %% -------- Slice indices (mid-slices) --------
    sx = round(size(brain,1)/2); % sagittal
    sy = round(size(brain,2)/2); % coronal
    sz = round(size(brain,3)/2)-12; % axial

    

    %% -------- Figure layout --------
    figure('Color','k','Position',[100 100 777 1200]) % here the k is to make background black
    tiledlayout(4,3,'Padding','tight','TileSpacing','none')

    %titles = {'Sagittal','Coronal','Axial'};

    %% -------- Row 1: Brain only --------
    for i = 1:3
        nexttile
        switch i
            case 1
                base = squeeze(brain(sx,:,:)); % have to squeeze that dim for imagesc
            case 2
                base = squeeze(brain(:,sy,:));
            case 3
                base = squeeze(brain(:,:,sz));
        end
        base = pad_to_square(base); % this func makes the size symmetrical
        plot_slice(base)
        %title(titles{i})
    end

    %% -------- Row 2: Brain + CSF (pve_0) --------
    for i = 1:3
        nexttile
        switch i
            case 1
                base = brain(sx,:,:); ov = pve0(sx,:,:);
            case 2
                base = brain(:,sy,:); ov = pve0(:,sy,:);
            case 3
                base = brain(:,:,sz); ov = pve0(:,:,sz);
        end
        base = squeeze(base);
        ov = squeeze(ov);
        base = pad_to_square(base);
        ov   = pad_to_square(ov);
        overlay_pve(base, ov, 'r')

        %plot_slice(base)
        %hold on
        %h = imagesc(rot90(ov));
        %set(h,'AlphaData',rot90(ov))   % opacity proportional to PVE
        %colormap(gca,hot)
        %hold off
    end

    %% -------- Row 3: Brain + GM (pve_1) --------
    for i = 1:3
        nexttile
        switch i
            case 1
                base = brain(sx,:,:); ov = pve1(sx,:,:);
            case 2
                base = brain(:,sy,:); ov = pve1(:,sy,:);
            case 3
                base = brain(:,:,sz); ov = pve1(:,:,sz);
        end
        base = squeeze(base);
        ov = squeeze(ov);
        base = pad_to_square(base);
        ov   = pad_to_square(ov);
        overlay_pve(base, ov, 'g')
        

        % plot_slice(base)
        % hold on
        % h = imagesc(rot90(ov));
        % set(h,'AlphaData',rot90(ov))
        % %colormap(gca,hot)
        % hold off
    end

    %% -------- Row 4: Brain + WM (pve_2) --------
    for i = 1:3
        nexttile
        switch i
            case 1
                base = brain(sx,:,:); ov = pve2(sx,:,:);
            case 2
                base = brain(:,sy,:); ov = pve2(:,sy,:);
            case 3
                base = brain(:,:,sz); ov = pve2(:,:,sz);
        end
        base = squeeze(base);
        ov = squeeze(ov);
        base = pad_to_square(base);
        ov   = pad_to_square(ov);
        overlay_pve(base, ov, 'b')

        % plot_slice(base)
        % hold on
        % h = imagesc(rot90(ov));
        % set(h,'AlphaData',rot90(ov))
        % %colormap(gca,hot)
        % hold off
    end
    
    thisFilename = fullfile(savedir,[subjects{ii} '_plot']);
    h = gcf;
    print(h, '-dpdf', thisFilename, '-r600');

end



function overlay_pve(base, ov, color)
    imagesc(rot90(base)), axis image off
    colormap(gca, gray)
    hold on

    ov = rot90(ov);
    %ov(ov < 0.2) = 0;   % threshold (optional)

    R = zeros(size(ov));
    G = zeros(size(ov));
    B = zeros(size(ov));

    switch color
        case 'r', R = ov;
        case 'g', G = ov;
        case 'b', B = ov;
        case 'w', R = ov; G = ov; B = ov;
    end

    h = imagesc(cat(3,R,G,B));
    set(h,'AlphaData',ov)
    hold off
end


function plot_slice(img)
% Set the colormap for the overlay slices
    imagesc(rot90(img)), axis image off, 
    colormap(gca,gray)
    hold off
end


function img2 = pad_to_square(img, padval)
    if nargin < 2, padval = 0; end
    [ny,nx] = size(img);
    n = max(nx,ny);
    img2 = padval * ones(n,n,'like',img);
    y0 = floor((n-ny)/2) + 1;
    x0 = floor((n-nx)/2) + 1;
    img2(y0:y0+ny-1, x0:x0+nx-1) = img;
end

