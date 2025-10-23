close all
clear variables
clc

dataset = {'canapi_sub01_030225', 'canapi_sub02_180325', 'canapi_sub03_180325',...
    'canapi_sub04_280425','canapi_sub05_240625', 'canapi_sub06_240625',...
    'canapi_sub07_010725', 'canapi_sub08_010725', 'canapi_sub09_160725', ...
    'canapi_sub10_160725'};

%dataset = {'canapi_sub01_030225', 'canapi_sub02_180325'};

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/unilateral_tstats_raw/'];

if ~exist(savedir, 'dir')
    mkdir(savedir);
end

sigVal = 3.1;
sigValneg = -3.1;

% Right leg task
onebarR = 'spmT_0001.nii';
% Left leg task
onebarL = 'spmT_0003.nii';

% left hemisphere
maskL = '/Volumes/kratos/canapi_raw_tstats/prepostsmaCG_L_bin.nii';
vmaskL = niftiread(maskL);
% right hemisphere
maskR = '/Volumes/kratos/canapi_raw_tstats/prepostsmaCG_R_bin.nii';
vmaskR = niftiread(maskR);

tic
for iSub = 1:length(dataset)
    disp(['Running subject ' dataset{iSub}])

    % --- Paths to t-maps ---
    tRfile = ['/Volumes/kratos/' dataset{iSub} '/spm_analysis/first_level/spmT_0001.nii']; % Right leg
    tLfile = ['/Volumes/kratos/' dataset{iSub} '/spm_analysis/first_level/spmT_0003.nii']; % Left leg
    
    % --- Load SPM volumes ---
    vT_R = spm_vol(tRfile);
    vT_L = spm_vol(tLfile);
    tR = spm_read_vols(vT_R);
    tL = spm_read_vols(vT_L);
    
    % --- Resample masks to match t-map grid (nearest neighbour, no mean image) ---
    flags = struct('mask', false, 'mean', false, 'interp', 0, 'which', 1, ...
                   'wrap', [0 0 0], 'prefix', 'r');
    
    % Expected resliced filenames
    rMaskL = fullfile(fileparts(maskL), ['r' spm_file(maskL,'filename')]);
    rMaskR = fullfile(fileparts(maskR), ['r' spm_file(maskR,'filename')]);
    
    % Reslice only if not already done
    if ~isfile(rMaskL)
        fprintf('🧭 Reslicing left mask...\n');
        P = char(vT_R.fname, maskL);
        spm_reslice(P, flags);
    else
        fprintf('⏭️ Skipping left mask (already resliced)\n');
    end
    
    if ~isfile(rMaskR)
        fprintf('🧭 Reslicing right mask...\n');
        P = char(vT_R.fname, maskR);
        spm_reslice(P, flags);
    else
        fprintf('⏭️ Skipping right mask (already resliced)\n');
    end
    
    % --- Read resampled masks ---
    maskL_res = spm_read_vols(spm_vol(rMaskL));
    maskR_res = spm_read_vols(spm_vol(rMaskR));
    
    % Binarize to clean up any interpolation noise
    maskL_res = maskL_res > 0.5;
    maskR_res = maskR_res > 0.5;
    
    % mask
    RbyL = tR.*maskL_res;
    RbyR = tR.*maskR_res;
    LbyR = tL.*maskR_res;
    LbyL = tL.*maskL_res;
    
    %vectorise
    vRbyL = RbyL(:);
    vRbyR = RbyR(:);
    vLbyR = LbyR(:);
    vLbyL = LbyL(:);
    
    % get pos and neg separately and threshold
    vRbyL_pos = vRbyL(vRbyL>sigVal);
    vRbyL_neg = vRbyL(vRbyL<sigValneg);
    vRbyR_pos = vRbyR(vRbyR>sigVal);
    vRbyR_neg = vRbyR(vRbyR<sigValneg);
    vLbyR_pos = vLbyR(vLbyR>sigVal);
    vLbyR_neg = vLbyR(vLbyR<sigValneg);
    vLbyL_pos = vLbyL(vLbyL>sigVal);
    vLbyL_neg = vLbyL(vLbyL<sigValneg);

    % now do means separately
    % --- Compute mean and SD for each ---
    % pairs = {
    %     'RbyL_pos', vRbyL_pos;
    %     'RbyL_neg', vRbyL_neg;
    %     'RbyR_pos', vRbyR_pos;
    %     'RbyR_neg', vRbyR_neg;
    %     'LbyR_pos', vLbyR_pos;
    %     'LbyR_neg', vLbyR_neg;
    %     'LbyL_pos', vLbyL_pos;
    %     'LbyL_neg', vLbyL_neg;
    % };

    pairs = {
        'RbyL_pos', vRbyL_pos;
        'RbyL_neg', vRbyL_neg;
        'RbyR_pos', vRbyR_pos;
        'RbyR_neg', vRbyR_neg;
        'LbyR_pos', vLbyR_pos;
        'LbyR_neg', vLbyR_neg;
        'LbyL_pos', vLbyL_pos;
        'LbyL_neg', vLbyL_neg;
    };
    
    means = nan(height(cell2table(pairs)),1);
    stds  = nan(height(cell2table(pairs)),1);
    labels = pairs(:,1);
    
    for idex = 1:numel(labels)
        vals = pairs{idex,2};
        vals = vals(isfinite(vals));
        if isempty(vals)
            means(idex) = NaN;
            stds(idex)  = NaN;
            fprintf('⚠️ %s: no voxels passed threshold\n', labels{idex});
        else
            means(idex) = mean(vals);
            stds(idex)  = std(vals);
            fprintf('%s → mean = %.3f, SD = %.3f (n=%d)\n', ...
                    labels{idex}, means(idex), stds(idex), numel(vals));
        end
    end

    meansG(:,iSub) = means;
    stdsG(:,iSub) = stds;
    labelsG(:,iSub) = labels;


    % sanity check
    % figure
    % tiledlayout(2,2)
    % nexttile
    % histogram(vRbyL_pos)
    % xlim([0 20])
    % nexttile
    % histogram(vRbyL_neg)
    % xlim([-20 0])

    % sanity check
    % sliceNum = 70;
    % figure
    % tiledlayout(2,2)
    % nexttile
    % imagesc(tR(:,:,sliceNum))
    % nexttile
    % imagesc(maskL_res(:,:,sliceNum))
    % nexttile
    % imagesc(RbyL(:,:,sliceNum))
        
end
toc



%% now we can plot

posDex = [1 3 5 7];
negDex = [2 4 6 8];

meansG_pos = meansG(posDex,:);
meansG_neg = meansG(negDex,:);
stdsG_pos = stdsG(posDex,:);
stdsG_neg = stdsG(negDex,:);
labelsG_pos = labelsG(posDex,:);
labelsG_neg = labelsG(negDex,:);

subs = repmat({'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08','sub09','sub10'},4,1);
subs = subs(:);

% we need to swap rows for plotting on left
meansG_pos = [meansG_pos(3:4,:); meansG_pos(1:2,:)];
stdsG_pos = [stdsG_pos(3:4,:); stdsG_pos(1:2,:)];
meansG_neg = [meansG_neg(3:4,:); meansG_neg(1:2,:)];
stdsG_neg = [stdsG_neg(3:4,:); stdsG_neg(1:2,:)];
labelsG_pos = [labelsG_pos(3:4,:); labelsG_pos(1:2,:)];
labelsG_neg = [labelsG_neg(3:4,:); labelsG_neg(1:2,:)];


posStack = table(meansG_pos(:), stdsG_pos(:), labelsG_pos(:),subs,...
    'VariableNames', {'Mean','Std','Label','Subject'});
negStack = table(meansG_neg(:), stdsG_neg(:), labelsG_neg(:),subs,...
    'VariableNames', {'Mean','Std','Label','Subject'});

writetable(posStack, fullfile(savedir,'outputraw.csv'));


% Initialise gramm
% % Make sure Subject is categorical for cleaner grouping
% posStack.Subject = categorical(posStack.Subject);

% Compute error limits for gramm
posStack.ymin = posStack.Mean - posStack.Std;
posStack.ymax = posStack.Mean + posStack.Std;

negStack.ymin = negStack.Mean - negStack.Std;
negStack.ymax = negStack.Mean + negStack.Std;



cmap = {'#e31a1c','#fd8d3c','#0570b0','#74a9cf'};
cmapped = validatecolor(cmap,'multiple');


%% Build gramm object
clc
close all
figure('Position',[100 100 1000 500]);

dodgeVal = 0.8;

g = gramm( ...
    'x', posStack.Subject, ...
    'y', posStack.Mean, ...
    'color', posStack.Label, ...
    'ymin', posStack.ymin, ...
    'ymax', posStack.ymax);

% Bars + your own SD errorbars
g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.geom_interval('geom','errorbar','dodge',0.5,'width',1);   % <- uses ymin/ymax that you defined

% Optional styling
g.set_names('x',[],'y','Mean T','color','Condition');
g.set_title('fMRI T-values','FontSize',16);
g.axe_property('FontSize',16,'ylim',[0 16],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.set_color_options('map',cmapped)
g.no_legend
g.draw();

g.update()
g.geom_interval('geom','errorbar','dodge',dodgeVal,'width',0.6);   % <- uses ymin/ymax that you defined
comesInBlack = ones(4,3).*0.3;
g.set_color_options('map',comesInBlack)
g.no_legend
g.draw()

filename = ('rawtstatfmriplot');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% same for neg
clc
close all
figure('Position',[100 100 1000 500]);

dodgeVal = 0.8;

g = gramm( ...
    'x', negStack.Subject, ...
    'y', negStack.Mean, ...
    'color', negStack.Label, ...
    'ymin', negStack.ymin, ...
    'ymax', negStack.ymax);

% Bars + your own SD errorbars
g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.geom_interval('geom','errorbar','dodge',0.5,'width',1);   % <- uses ymin/ymax that you defined

% Optional styling
g.set_names('x',[],'y','Mean T','color','Condition');
%g.set_title('Positive T-values');
g.axe_property('FontSize',12,'ylim',[-10 0],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.set_color_options('map',cmapped)
g.no_legend
g.draw();

g.update()
g.geom_interval('geom','errorbar','dodge',dodgeVal,'width',0.6);   % <- uses ymin/ymax that you defined
comesInBlack = ones(4,3).*0.3;
g.set_color_options('map',comesInBlack)
g.no_legend
g.draw()

filename = ('rawtstatfmriplot_neg');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')











