clear all
close all
clc
whichMac = char(java.lang.System.getProperty('user.name'));
subjectPath = '/Volumes/DRS-Touchmap/ma_ares_backup/TOUCH_REMAP/exp016/freesurfer/';
%subjectPath = '/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/subs/';
setenv('SUBJECTS_DIR',subjectPath);

dataPath = '/Volumes/nemosine/ken/';
%dataPath = '/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/nemosine/DigitAtlasv2/';

subs = {'026',...
    '059'
    };
%subs = {'026'}

%subs = {'14001'};


% should be where your subject's digit data are
%mypath = '/Users/spmic/data/ken_surf_testing/';
savedir = ['/Users/' whichMac '/Library/CloudStorage/OneDrive-TheUniversityofNottingham/kv_digitatlas_figures/'];


hemisphere = 'r';
surface = 'inflated'; 
map = 'viridis';
nchips = 256;
mymin = 0.5;
myalpha = 1;
zf = 1.8;

tryPerCol = 0;
dofsavg = 0; % you cant do fsavg and trypercol at the same time

if dofsavg
    mythresh = 0; % this fixes a bug where the patch doesnt show
else
    mythresh = 0.046;
end


%%
cmap = {'#FF0000', '#0080FF', '#FF7F00', '#407F04', '#F500FF'};
cmapped = validatecolor(cmap,'multiple');

% fix for fsavg fpm maxpeaks
fshemisphere = 'rh';  % or 'rh'
fsavgdir = '/Applications/freesurfer/subjects/';
[ave, ~] = read_surf(fullfile(fsavgdir, 'fsaverage', 'surf', [fshemisphere '.sphere.reg']));

for iSub = 1:length(subs)
    clear data data_bin data_thresh


    % here we load the digits and binarise
    for ii = 1:5
        thisFile = ['LD' num2str(ii) '_' subs{iSub} '.mgz'];
        %thisFile = ['LD' num2str(ii) '_' subs{iSub} '_fsbrain.mgz'];
        theFile = MRIread(fullfile(dataPath, subs{iSub}, thisFile));
        data(:,ii) = theFile.vol(:);
        binariseData = data(:,ii)>0;
    end
    

    % now check if we want to show FPM on fsavg or not
    % we have to do it this way not via 'warp'
    % because we need the maxes for the peaks in fsavg space
    if dofsavg
        [ind, ~] = read_surf(fullfile(subjectPath, subs{iSub}, 'surf', [fshemisphere '.sphere.reg']));
        ind2ave = knnsearch(ind, ave);
        data_fsavg = data(ind2ave, :);
        digit_max = max(data_fsavg, [], 1);  % 1×5 vector
        
        data_thresh = data_fsavg;
        [vertices, faces] = read_surf('/Applications/freesurfer/subjects/fsaverage/surf/rh.inflated');
    else
        % this is just regular native space
        digit_max = max(data, [], 1);
        data_thresh = data;
        [vertices, faces] = read_surf(fullfile(subjectPath, subs{iSub}, 'surf', 'rh.inflated'));
    end

    if tryPerCol
        digit_thresh = 0.5 * digit_max; % 50% of each column
        for dx = 1:5
            data_thresh(data(:, dx) < digit_thresh(dx), dx) = 0; %ccomplicated here
            %Looks at that digit's column.
            %Finds all voxel rows where the value is < 50% of that digit%s max.
            %Sets those entries to 0 only in that column.
        end
        printThresh = '50prc';
    else
        data_thresh(data < mythresh) = 0;  % Only keep probabilities ≥ X
        printThresh = ['p' extractAfter(num2str(mythresh),'.')];
    end

    % this creates a binary map, so setting each column to 1-5 
    %Find the maximum probability and the digit it came from
    [maxvals, maxdigit] = max(data_thresh, [], 2);  % data is X × 5

    %Assign only voxels where the max is > 0
    data_labels = zeros(size(maxdigit));        % default = 0 (unlabeled)
    data_labels(maxvals > 0) = maxdigit(maxvals > 0);  % digit 1–5

    %conflict_voxels = sum(data_labels > 0, 2) > 1;
    %fprintf('Remaining overlaps: %d\n', sum(conflict_voxels));  % Should be 0 now

    % we also want the FPM map combined
    data_single_col = max(data_thresh, [], 2);


    % Both should mark the *same* vertices
    mask_labels = data_labels > 0;
    mask_single = data_single_col > 0;

    % Compare
    fprintf('Labels set: %d voxels\n', sum(mask_labels));
    fprintf('Single col set: %d voxels\n', sum(mask_single));
    fprintf('Overlap: %d voxels\n', sum(mask_labels & mask_single));


    % Find max voxel index per digit
    % for the spheres
    max_inds = zeros(5,1);
    for d = 1:5
        [~, max_inds(d)] = max(data_thresh(:, d));
    end

    %% now plotting

    % first do FPMs
    close all
    figure
    if dofsavg
        go_paint_freesurfer(data_single_col,...
            'fsaverage','r','range',...
            [0.0000001 1], 'cbar','colormap',map)
    else
        go_paint_freesurfer(data_single_col,...
            subs{iSub},'r','range',...
            [0.0000001 1], 'cbar','colormap',map)
    end

    hold on
    % Plot dots at max digit points, adjusting marker size and color as you like
    %colors = digits(5);  % distinct colors for digits

    [xs, ys, zs] = sphere(20); % sphere coordinates
    h_sph = gobjects(5,1);  % to store handles for legend
    r = 1.5; % radius of small sphere
    for d = 1:5
        h_sph(d) = surf(r*xs + vertices(max_inds(d),1), ...
            r*ys + vertices(max_inds(d),2), ...
            r*zs + vertices(max_inds(d),3), ...
            'FaceColor', cmapped(d,:), 'EdgeColor', 'none');
    end
    %legend(h_sph, {'D1', 'D2', 'D3', 'D4', 'D5'}, 'Location', 'northwestoutside')
    hold off
    camzoom(1.6)

    if dofsavg
        print(fullfile(savedir, [subs{iSub} '_LD_digits_fpm_warped']), '-dpdf', '-r600')
        print(fullfile(savedir, [subs{iSub} '_LD_digits_fpm_warped']), '-dpng', '-r600')
    else
        print(fullfile(savedir, [subs{iSub} '_LD_digits_fpm_thr' printThresh]), '-dpdf', '-r600')
        print(fullfile(savedir, [subs{iSub} '_LD_digits_fpm_thr' printThresh]), '-dpng', '-r600')
    end

    %seqmap = digits(5);
    % plot this
    %% now plot binary digits
    clc
    close all
    
    if ~dofsavg
        figure
        go_paint_freesurfer(data_labels,...
            subs{iSub},'r','range',...
            [0.1 5], 'cbar','colormap',cmapped,'nchips',5,'customcmap')
        camzoom(zf)

        print(fullfile(savedir, [subs{iSub} '_LD_digits_bin_thr' printThresh]), '-dpdf', '-r600')
        print(fullfile(savedir, [subs{iSub} '_LD_digits_bin_thr' printThresh]), '-dpng', '-r600')

        figure
        go_paint_freesurfer(data_labels,...
            subs{iSub},'r','range',...
            [0.1 5], 'cbar','colormap',cmapped,'nchips',5,'customcmap','warp')
        camzoom(zf)

        print(fullfile(savedir, [subs{iSub} '_LD_digits_bin_warped_thr' printThresh]), '-dpdf', '-r600')
        print(fullfile(savedir, [subs{iSub} '_LD_digits_bin_warped_thr' printThresh]), '-dpng', '-r600')
    end

end

keyboard


%% testing this works
% % print each digit on the native surface one by one
% for iSub = 1:length(subs)
%     for ii = 1:5
%         thisFile = ['LD' num2str(ii) '_' subs{ii} '.mgz'];
% 
%         theFile = MRIread(fullfile(dataPath, subs{ii}, thisFile));
% 
%         data = theFile.vol(:);
% 
%         figure
%         go_paint_freesurfer(data,...
%             subs{ii},'r','range',...
%             [0.1 1], 'cbar','colormap',map)
%         %print(fullfile(savedir, sprintf('RD_%d_inflated', ii)), '-dpdf', '-r600')
%         %keyboard
% 
%     end
% end

%% load in george atlas
subdir = '/Users/ppzma/Documents/MATLAB/digitAtlas/subjects/';
tic
subs = {'001', '002', '003', '004', '005', '006', '007', '008', '009','010', ...
    '011', '012', '013', '014', '015', '016', '017', '018', '019', '020', '021','022'};
for ii = 1:length(subs)
    for iDigit = 1:5
        theFile = MRIread([subdir subs{ii} '/surf/LD' sprintf('%d',iDigit) '_manual' '.mgz']);
        LD(:,iDigit,ii) = theFile.vol(:);
    end  
    for iDigit = 1:5
        theFile = MRIread([subdir subs{ii} '/surf/RD' sprintf('%d',iDigit) '_manual' '.mgz']);
        RD(:,iDigit,ii) = theFile.vol(:);
    end
end
toc

pLD_all = LD;
pRD_all = RD;
pLD_FPM = mean(LD,3);
pRD_FPM = mean(RD,3);

handAreaR = sum(pRD_FPM,2);
handAreaL = sum(pLD_FPM,2);

%%
whichMac = char(java.lang.System.getProperty('user.name'));

savedir = ['/Users/' whichMac '/Library/CloudStorage/OneDrive-TheUniversityofNottingham/kv_digitatlas_figures/'];

close all

figure
go_paint_freesurfer(handAreaL, ...
    'fsaverage', 'r', ...
    'range', [0.1 max(handAreaL)], ...
    'cbar', 'colormap', 'viridis', ...
    'OutlineOnly',1)
camzoom(zf)
%camzoom(zf)
print(fullfile(savedir, 'digitatlasLD'), '-dpdf', '-r600')
print(fullfile(savedir, 'digitatlasLD'), '-dpng', '-r600')
%print(fullfile(savedir, 'digitatlasLD'), '-dpdf', '-r600')

figure
go_paint_freesurfer(handAreaR, ...
    'fsaverage', 'l', ...
    'range', [0.1 max(handAreaR)], ...
    'cbar', 'colormap', 'viridis', ...
    'OutlineOnly',1)
camzoom(zf)
%camzoom(zf)
print(fullfile(savedir, 'digitatlasRD'), '-dpdf', '-r600')
print(fullfile(savedir, 'digitatlasRD'), '-dpng', '-r600')
%print(fullfile(savedir, 'digitatlasRD'), '-dpdf', '-r600')















