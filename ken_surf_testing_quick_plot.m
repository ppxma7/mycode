clear all
close all
clc

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
savedir = dataPath;

hemisphere = 'r';
surface = 'inflated'; 
map = 'viridis';
nchips = 256;
mymin = 0.5;
myalpha = 1;
zf = 1.8
% set to where your freesurfer dirs are, e.g. 020 in this case
% subdir='/Users/spmic/data/subs/';
% setenv('SUBJECTS_DIR',subdir);
%%
cmap = {'#FF0000', '#0080FF', '#FF7F00', '#407F04', '#F500FF'};
cmapped = validatecolor(cmap,'multiple');


mythresh = 0.046;
printThresh = ['p' extractAfter(num2str(mythresh),'.')];

for iSub = 1:length(subs)
    clear data data_bin data_thresh

    [vertices, faces] = read_surf(fullfile(subjectPath, subs{iSub}, 'surf', 'rh.inflated'));

    for ii = 1:5
        thisFile = ['LD' num2str(ii) '_' subs{iSub} '.mgz'];
        %thisFile = ['LD' num2str(ii) '.mgh'];
        %theFile = MRIread(fullfile(dataPath, subs{iSub}, '2mm/', thisFile));
        theFile = MRIread(fullfile(dataPath, subs{iSub}, thisFile));
        data(:,ii) = theFile.vol(:);

        binariseData = data(:,ii)>0;

        %data_bin(:,ii) = binariseData .* ii;

    end

    data_thresh = data;
    data_thresh(data < mythresh) = 0;  % Only keep probabilities ≥ 0.2

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

    % Find max voxel index per digit
    max_inds = zeros(5,1);
    for d = 1:5
        [~, max_inds(d)] = max(data_thresh(:, d));
    end


    close all
    figure
    go_paint_freesurfer(data_single_col,...
        subs{iSub},'r','range',...
        [0.1 1], 'cbar','colormap',map)

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

    legend(h_sph, {'D1', 'D2', 'D3', 'D4', 'D5'}, 'Location', 'northwestoutside')

    hold off


    camzoom(1.6)
 
    print(fullfile(savedir, [subs{iSub} '_LD_digits_fpm_thr' printThresh]), '-dpdf', '-r600')
    print(fullfile(savedir, [subs{iSub} '_LD_digits_fpm_thr' printThresh]), '-dpng', '-r600')

%
    %seqmap = digits(5);
    % plot this
    clc
    close all

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

close all

figure
go_paint_freesurfer(handAreaL, ...
    'fsaverage', 'r', ...
    'range', [0.1 max(handAreaL)], ...
    'cbar', 'colormap', 'viridis', ...
    'OutlineOnly',1)
%camzoom(zf)
print(fullfile(savedir, 'digitatlasLDnozzom'), '-dpdf', '-r600')

%print(fullfile(savedir, 'digitatlasLD'), '-dpng', '-r600')
%print(fullfile(savedir, 'digitatlasLD'), '-dpdf', '-r600')

figure
go_paint_freesurfer(handAreaR, ...
    'fsaverage', 'l', ...
    'range', [0.1 max(handAreaR)], ...
    'cbar', 'colormap', 'viridis', ...
    'OutlineOnly',1)
%camzoom(zf)
print(fullfile(savedir, 'digitatlasRDnozzom'), '-dpdf', '-r600')

%print(fullfile(savedir, 'digitatlasRD'), '-dpng', '-r600')
%print(fullfile(savedir, 'digitatlasRD'), '-dpdf', '-r600')















