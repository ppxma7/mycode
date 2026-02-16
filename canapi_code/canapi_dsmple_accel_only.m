close all
clear variables
clc

dataset = {'canapi_test_outside_dual_accel'};

saveem = 1;
ch2normch1 = 1;

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/ACCELplots/'];

myfiles = {'canapi_outside_test_Rectify.dat'};

mySlices = {1};

markerFiles = cell(1,length(myfiles));
for ii = 1:length(myfiles)
    markerFiles{ii} = [extractBefore(myfiles{ii},'.') '_marker.txt'];
end

Fs = 2500;
num_channels = 6;
target_num_samples = 227; % this is how long the fMRI timeseries is
%target_num_samples = 100; % without rest at end
TR = 1.5;
firstMarker = 2;
lastMarker = 17;
twoBefore = lastMarker-2;

winLen = 100;

saveMat = cell(length(4),num_channels);
hrf = spm_hrf(TR);

%% get default sig

[~,signal] = wavySignal(0,1);
signal = signal./2;

tic

for iSub = 1:length(dataset)

    disp(['Running subject ' dataset{iSub}])

    for ii = 1 %:4

        mypath=['/Volumes/kratos/CANAPI/' dataset{iSub} '/EEG/Export/'];

        
        thisSlice = mySlices{iSub}(ii);
        disp([' Running this file: ' myfiles{thisSlice}])
        %thisFile = load([mypath myfiles{ii}]);
        thisFile = load([mypath myfiles{thisSlice}]);

        %thisMarker = readtable([mypath extractBefore(myfiles{ii},'.') '_marker.txt']);
        thisMarker = readtable([mypath markerFiles{thisSlice}]);

        r128 = contains(thisMarker.Description,'R128');
        if sum(r128) ~= 0
            thisMarker(r128,:) = [];
        end

        %figure out ending. We end on an ON, so need to add the OFF and the ON
        %to the last marker position
        %startMark = thisMarker.Position(firstMarker);
        %endMark = thisMarker.Position(lastMarker)+(thisMarker.Position(lastMarker)-thisMarker.Position(twoBefore));
        
        % fudge for now
        startMark = 5000;
        endMark = 14000;

        ch1_clv = thisFile(1,startMark:endMark);
        ch2_clv = thisFile(2,startMark:endMark);
        ch3_clv = thisFile(3,startMark:endMark);
        ch4_clv = thisFile(4,startMark:endMark);
        ch5_clv = thisFile(5,startMark:endMark);
        ch6_clv = thisFile(6,startMark:endMark);

        thisLen = length(ch1_clv);
        
                % ----- limb vector magnitude -----
        right_mag = sqrt(ch1_clv.^2 + ch2_clv.^2 + ch3_clv.^2);
        left_mag  = sqrt(ch4_clv.^2 + ch5_clv.^2 + ch6_clv.^2);

        [right_env, ~] = envelope(right_mag, winLen, 'rms');
        [left_env,  ~] = envelope(left_mag,  winLen, 'rms');

        baselineX = 8000;

        baseR = mean(right_env(1:baselineX));
        baseL = mean(left_env(1:baselineX));

        right_zero = max(0, right_env - baseR);
        left_zero  = max(0, left_env  - baseL);

        if ii == 1 || ii == 2        % RIGHT PUSH
            task   = right_zero;
            nontask = left_zero  / max(right_zero);

        elseif ii == 3 || ii == 4    % LEFT PUSH
            task   = left_zero;
            nontask = right_zero / max(left_zero);
        end

        task_dsmpl    = resample(task, target_num_samples, thisLen);
        nontask_dsmpl = resample(nontask, target_num_samples, thisLen);
        
        figure
        plot(task_dsmpl)
        hold on
        plot(nontask_dsmpl)

        task_conv    = conv(task_dsmpl, hrf);
        nontask_conv = conv(nontask_dsmpl, hrf);
        task_conv    = task_conv(1:target_num_samples);
        nontask_conv = nontask_conv(1:target_num_samples);
        
        % figure
        % plot(task_conv)
        % hold on
        % plot(nontask_conv)

        %%
        saveMat{ii,1} = task_conv;
        saveMat{ii,2} = nontask_conv;

        saveMat_noconv{ii,1} = task_dsmpl;
        saveMat_noconv{ii,2} = nontask_dsmpl;

        % save for operation later
        opMatsubs{ii,1,iSub} = task_conv;
        opMatsubs{ii,2,iSub} = nontask_conv;

        opMatsubs_noconv{ii,1,iSub} = task_dsmpl;
        opMatsubs_noconv{ii,2,iSub} = nontask_dsmpl;


    end

    %% save text files to enter later into SPM GLM - per subject

    if saveem

        for kk = 1 %:4

            thisSlice = mySlices{iSub}(kk);

            thisRow = saveMat{kk,1}';
            thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ch1_dsmpled.txt'];
            writematrix(thisRow,thisRowName,'Delimiter','\t');

            thisRow = saveMat{kk,2}';
            thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ch2_dsmpled.txt'];
            writematrix(thisRow,thisRowName,'Delimiter','\t');


        end
    end
    
    %% plotting
    if saveem
        close all
        t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
        filename1 = [savedir 'accel_dwnsmpl_' dataset{iSub} '-' char(t)];
        figure('Position',[0 0 1400 800])
        tiledlayout(2,2)

        flays = 1; %4; %[2 5 4 6];
        for jj = 1:flays
            nexttile
            plot(saveMat_noconv{jj,1},'linewidth',2,'Color','#1f78b4')
            hold on
            plot(saveMat_noconv{jj,2},'linewidth',1,'Color','#d95f02')
            hold on
            plot(signal)
            legend('ch1','ch2','ideal block')
            title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
            ylim([0 2])
        end

        h = gcf;
        set(h, 'PaperOrientation', 'landscape');
        set(h, 'PaperUnits', 'inches');
        set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
        set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
        print(h, '-dpdf', filename1, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI

    end



end
toc
disp('...done!')
keyboard

%% run correlations

[~,signal] = wavySignal(0,1,227);
signal = signal./2;


% Assume your cell array is called `emg_data`, size 4x5x10
correlations = zeros(4, 5, 10);  % Preallocate

% Loop over runs, channels, subjects
for subj = 2:10
    for ch = 1:5
        for run = 1:4
            emg_trace = opMatsubs_noconv{run, ch, subj};  % 1x227 double
            emg_trace = emg_trace(1:length(signal)); % fudge to keep sizes
            r = corr(emg_trace(:), signal(:));    % Pearson correlation
            correlations(run, ch, subj) = r;
        end
    end
end

% Assume `correlations` is now 4x5x10
% Remove subject 1
correlations = correlations(:, :, 2:10);  % Now 4x5x9

% Predefine labels
subject_labels = arrayfun(@(s) sprintf('Subject %d', s), 2:10, 'UniformOutput', false);
run_labels = {'1barR', 'lowR', '1barL', 'lowL'};
channel_labels = {'EMG ch1', 'EMG ch2', 'Accel X', 'Accel Y', 'Accel Z'};

% Get sizes
[nRuns, nChans, nSubj] = size(correlations);

% Initialize label vectors
subj_vec = cell(nRuns * nChans * nSubj, 1);
run_vec = cell(size(subj_vec));
chan_vec = cell(size(subj_vec));
corr_vec = zeros(size(subj_vec));

% Fill in
idx = 1;
for subj = 1:9
    for chan = 1:5
        for run = 1:4
            subj_vec{idx} = subject_labels{subj};
            run_vec{idx} = run_labels{run};
            chan_vec{idx} = channel_labels{chan};
            corr_vec(idx) = correlations(run, chan, subj);
            idx = idx + 1;
        end
    end
end



% Flatten manually
corr_flat = [];
for subj = 1:9
    for chan = 1:5
        for run = 1:4
            corr_flat(end+1,1) = correlations(run, chan, subj);
        end
    end
end

% Compare with default MATLAB vectorization
isequal(corr_flat, correlations(:))  % Should return true
%%
clear g
close all
figure
g = gramm('x', chan_vec, 'y', corr_vec, 'color', run_vec);
g.stat_summary('geom', {'bar', 'black_errorbar'}, 'type', 'sem');
g.set_names('x','Channel','y','Correlation','color','Run');
g.set_title('Correlation of EMG/Accel signals with boxcar');
g.axe_property('YLim', [0 1]);  % Optional: fix y-axis
g.draw()

filename = ('corr_vec_1_noconv');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

clear g
figure
g = gramm('x', run_vec, 'y', corr_vec, 'color', chan_vec);
g.stat_summary('geom', {'bar', 'black_errorbar'}, 'type', 'sem');
g.set_names('x','Run','y','Correlation','color','Channel');
g.set_title('Boxcar correlations grouped by run');
g.axe_property('YLim', [0 1]);
g.draw()
filename = ('corr_vec_2_noconv');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

clear g
figure
g = gramm('x', chan_vec, 'y', corr_vec, 'color', subj_vec);
g.geom_jitter2('dodge', 0.6);  % adds subject dots
g.stat_summary('geom', {'point', 'line'}, 'dodge', 0.6);  % mean over subjects
g.set_names('x','Channel','y','Correlation','color','Subject');
g.set_title('Subject-level boxcar correlations');
g.axe_property('YLim', [-0.1 1]);
g.draw();
filename = ('corr_vec_3_noconv');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')





%% what about channel 1 to 2
nRuns = 4;
nSubjects = 10;

ch1vch2_corrs = zeros(nRuns, nSubjects);  % run × subject

for subj = 1:nSubjects
    %subj_idx = subj - 1;  % shift index since we drop subject 1
    subj_idx = subj;  % shift index since we drop subject 1

    for run = 1:nRuns
        trace1 = opMatsubs_noconv{run, 1, subj};  % channel 1
        trace2 = opMatsubs_noconv{run, 2, subj};  % channel 2

        trace1 = trace1(1:length(signal));
        trace2 = trace2(1:length(signal));

        ch1vch2_corrs(run, subj_idx) = corr(trace1(:), trace2(:));
    end
end
%run_labels = {'1barR', 'lowR', '1barL', 'lowL'};
run_labels = {'1barR', '15%R', '1barL', '15%L'};
%subject_labels = arrayfun(@(s) sprintf('Subject %d', s), 2:10, 'UniformOutput', false);
subject_labels = arrayfun(@(s) sprintf('Subject %d', s), 1:10, 'UniformOutput', false);

corr_vec = []; % remaking this to include subject 1
run_vec = {};
subj_vec = {};

for subj = 1:nSubjects
    for run = 1:nRuns
        corr_vec(end+1,1) = ch1vch2_corrs(run, subj);
        run_vec{end+1,1} = run_labels{run};
        subj_vec{end+1,1} = subject_labels{subj};
    end
end

% Flatten manually
manual_flat = [];
for subj = 1:nSubjects
    for run = 1:nRuns
        manual_flat(end+1,1) = ch1vch2_corrs(run, subj);
    end
end

% Confirm order
isequal(manual_flat, ch1vch2_corrs(:)) 


clear g
close all
figure('Position',[100 100 1000 600])

g = gramm('x', run_vec, 'y', corr_vec);
g.stat_summary('geom', {'bar', 'black_errorbar'}, 'type', 'sem');
g.set_names('x','Run','y','Ch1 ↔ Ch2 corr');
g.set_title('Correlation between EMG ch1 and ch2 across runs');
g.axe_property('YLim', [-0.2 1.2]);
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.set_order_options('x',0,'color',0)
g.draw();
g.update('y',corr_vec,'color', subj_vec)
g.geom_jitter2('dodge', 0.6);  % Optional: show individual subjects
g.set_order_options('x',0,'color',0)
g.draw();

filename = ('corr_vec_channel_1_2_noconv');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% I want to look at amplitudes of the no conv EMG traces

subject_labels = arrayfun(@(s) sprintf('Subject %d', s), 1:10, 'UniformOutput', false);
run_labels = {'1barR', 'lowR', '1barL', 'lowL'};
channel_labels = {'EMG ch1', 'EMG ch2', 'Accel X', 'Accel Y', 'Accel Z'};


nChans = 2;  % Only EMG 1 and 2
rms_matrix = zeros(nSubjects, nRuns * nChans);  % 10 x 8 (4 runs × 2 chans)
labels = {};

idx = 1;
for run = 1:nRuns
    for chan = 1:nChans % Only EMG 1 and 2
        labels{idx} = sprintf('%s - %s', run_labels{run}, channel_labels{chan});
        for subj = 1:nSubjects
            rms_matrix(subj, idx) = rms(opMatsubs_noconv{run, chan, subj});
        end
        idx = idx + 1;
    end
end

% RMS imagesc matrix, low = low mag, high = high magnitude
figure;
imagesc(rms_matrix);
colorbar;
xticks(1:(nRuns*nChans));
xticklabels(labels);
yticks(1:nSubjects);
yticklabels(subject_labels);
xlabel('Run - Channel');
ylabel('Subject');
title('RMS of EMG traces');
h = gcf;
thisFilename = [savedir 'rms_matrix_emg'];
%print(h, '-dpdf', thisFilename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI
print(h, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI


%% can we use RMS to compare ch1 to ch2 

% okay careful here, because i think for sub01, sub03, the channels are flipped
%sub01rms = rms_matrix(1,:);
%sub01rms_corr = [sub01rms(2) sub01rms(1) sub01rms(4) sub01rms(3) sub01rms(6) sub01rms(5) sub01rms(8) sub01rms(7)];
%sub03rms = rms_matrix(3,:);
%sub03rms_corr = [sub03rms(2) sub03rms(1) sub03rms(4) sub03rms(3) sub03rms(6) sub03rms(5) sub03rms(8) sub03rms(7)];

rms_matrix_corrected = rms_matrix;
%rms_matrix_corrected(1,:) = sub01rms_corr;
%rms_matrix_corrected(3,:) = sub03rms_corr;

nSubjects = size(rms_matrix, 1);
nRuns = 4;

ch1_vs_ch2 = zeros(nRuns, nSubjects); % channel dominance ratio

for run = 1:nRuns
    col_ch1 = (run-1)*2 + 1; % EMG1 column
    col_ch2 = col_ch1 + 1;   % EMG2 column

    ch1_rms = rms_matrix_corrected(:, col_ch1);
    ch2_rms = rms_matrix_corrected(:, col_ch2);
    
    if run <= 2
        % Runs 1-2 = right leg tasks → want ch1/ch2
        ch1_vs_ch2(run,:) = (ch1_rms ./ ch2_rms) * 100;
    else
        % Runs 3-4 = left leg tasks → want ch2/ch1
        ch1_vs_ch2(run,:) = (ch2_rms ./ ch1_rms) * 100;
    end
end

disp('Leg-dominance ratio (%):')
disp(ch1_vs_ch2)
save('canapi_rms_emg','ch1_vs_ch2')





%% correlation vs RMS of ch1 and ch2
emg1 = rms_matrix(:, 1:2:end);  % Channel 1 for all runs → size 10 × 4 - get odd cols
emg2 = rms_matrix(:, 2:2:end);  % Channel 2 for all runs → size 10 × 4 - get even cols

% fix to match corr vec
rms_vals_ch1 = transpose(emg1);
rms_vals_ch1 = rms_vals_ch1(:);

rms_vals_ch2 = transpose(emg2);
rms_vals_ch2 = rms_vals_ch2(:);

mymark = {'d','s','o','p'};
% look at instructed leg actually only

% A linear positive trend (points going up with RMS) means:
% the stronger they move the instructed leg, the more the uninstructed leg tends to come along for the ride.
% e.g. look at sub01
% When moving the right leg, they put in strong effort (high RMS) and the left leg coactivates (high corr).
% When moving the left leg, they either don't activate as strongly (low RMS), or manage to keep the right leg quiet (low corr).

for i = 1:length(corr_vec)
    thisRun = run_vec{i};  % extract string like '1barR' or 'lowL'
    if contains(thisRun, 'R')   % right leg instructed
        RMS_instructed(i)   = rms_vals_ch1(i);
        RMS_uninstructed(i) = rms_vals_ch2(i);
    elseif contains(thisRun, 'L')   % left leg instructed
        RMS_instructed(i)   = rms_vals_ch2(i);
        RMS_uninstructed(i) = rms_vals_ch1(i);
    end
end

%RMS_ratio = RMS_uninstructed ./ RMS_instructed;


close all
clear g
figure('Position',[100 100 1400 600]);

g(1,1) = gramm('x', RMS_instructed, 'y', corr_vec, ...
               'color', subj_vec, 'marker', run_vec);
g(1,1).geom_point();
g(1,1).set_names('x','RMS instructed leg','y','Correlation');

g(1,2) = gramm('x', RMS_uninstructed, 'y', corr_vec, ...
               'color', subj_vec, 'marker', run_vec);
g(1,2).geom_point();
g(1,2).set_names('x','RMS uninstructed leg','y','Correlation');

% g(1,2) = gramm('x', RMS_ratio, 'y', corr_vec, ...
%                'color', subj_vec, 'marker', run_vec);
% g(1,2).geom_point();
% g(1,2).set_names('x','RMS ratio (uninstr./instr.)','y','Correlation');
% 


g.set_text_options('Font','Helvetica','base_size',12);
%.set_point_options('base_size',10)
g.set_point_options("markers",mymark, 'base_size',12)
g.set_order_options('color',0)

g.draw()

filename = ('rms_corr_trend_gramm_instructed');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% do cross correlation amplitude

% swap sub01 channels as they were flipped in scanner
%opMatsubs_noconv_sub01fix = opMatsubs_noconv;
%opMatsubs_noconv_sub01fix(:,1,1) = opMatsubs_noconv(:,2,1);
%opMatsubs_noconv_sub01fix(:,2,1) = opMatsubs_noconv(:,1,1);
run_labels = {'1barL', '1barR'};
run_labels_stack = repmat(run_labels,1,length(dataset))';
subs = repmat({'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08','sub09','sub10'},length(run_labels),1);
subs = subs(:);

cmap = {'#238b45','#66c2a4','#b2e2e2','#edf8fb'};
cmapped = validatecolor(cmap,'multiple');

channel_labels = {'EMG ch1', 'EMG ch2'};
nRuns = 4;
nSubjects = 10;
%useRuns = [1 3];  % only these runs

ch1vch2_xcorr_normXC = zeros(nRuns, nSubjects);  % run × subject
ch1vch2_xcorr_peakXC = zeros(nRuns, nSubjects);  % run × subject

for subj = 1:nSubjects
    for run = 1:nRuns

        % --- Get EMG traces (already filtered, rectified, envelope, etc.) ---
        trace1 = opMatsubs_noconv{run, 1, subj};  % channel 1
        trace2 = opMatsubs_noconv{run, 2, subj};  % channel 2

        % --- Optional: make same length (safety) ---
        N = min(length(trace1), length(trace2));
        trace1 = trace1(1:N);
        trace2 = trace2(1:N);

        trace1m = trace1 - mean(trace1);
        trace2m = trace2 - mean(trace2);

        % --- Compute raw (unnormalized) cross-correlation ---
        [xc, lags] = xcorr(trace1m, trace2m);

        % --- Find peak (amplitude × synchrony) ---
        peakXC = max(abs(xc));

        % --- Save your preferred metric ---
        ch1vch2_xcorr_peakXC(run, subj) = peakXC;
    end
end


% figure('Position',[100 100 1200 800]);
% bar(ch1vch2_xcorr_peakXC', 'grouped');
% xlabel('Participant');
% ylabel('Amplitude cross-correlation index');
% title('Per-run amplitude cross-correlation between EMG1 & EMG2');
% %legend(compose('Run %d', 1:nRuns), 'Location', 'bestoutside');
% legend(run_labels, 'Location', 'bestoutside');
% grid on;
save('canapi_xcorr_emg','ch1vch2_xcorr_peakXC')
% h = gcf;
% thisFilename = [savedir 'xcorr_emg'];
% orient(h,'Landscape')
% print(h, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI

% CAREFUL HERE< JUST FOR PLOTTING FLIP SO LEFT IS ON LEFT OF BAR
ch1vch2_xcorr_peakXC_subset = ch1vch2_xcorr_peakXC;
peakxcsubset_flippedLR = [ch1vch2_xcorr_peakXC_subset(3,:); ch1vch2_xcorr_peakXC_subset(1,:)];
peakxcsubset_flippedLR = peakxcsubset_flippedLR(:);

% ch1vch2_xcorr_peakXC_subset(2,:) = NaN;
% ch1vch2_xcorr_peakXC_subset(4,:) = NaN;
% ch1vch2_xcorr_peakXC_subset = ch1vch2_xcorr_peakXC_subset(~isnan(ch1vch2_xcorr_peakXC_subset));
%%
dodgeVal = 0.8;
clear g
figure('Position',[100 100 900 600])
g = gramm('x', subs, 'y', peakxcsubset_flippedLR, 'color', run_labels_stack);
%g.geom_jitter2('dodge', 0);  % adds subject dots
%g.geom_point()
g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
g.set_names('x',[],'y','Amplitude cross-correlation index','color','Task');
%g.set_title('Max T stat per task');
g.set_title('Per-run amplitude cross-correlation between EMG1 & EMG2');

g.set_text_options('Font','Helvetica', 'base_size', 12)
g.axe_property('FontSize',16,'ylim',[0 16],'XGrid','on','YGrid','on');
g.set_color_options("map",cmapped)
g.set_order_options("color",0)
g.no_legend()

% Optional styling
% g.set_names('x',[],'y','Mean T','color','Condition');
% g.set_title('fMRI T-values');
% g.axe_property('FontSize',12,'ylim',[0 16],'XGrid','on','YGrid','on');
% g.set_order_options('x',0,'color',0)
% g.set_color_options('map',cmapped)
% g.no_legend
% g.draw();


%g.axe_property('YLim', [0 30]);
g.draw();
filename = ('xcorr_emg');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% Plot
% close all
% clear g
% figure('Position',[100 100 1400 600]);
% 
% g(1,1) = gramm('x', rms_vals_ch1, 'y', corr_vec, 'color', subj_vec,'marker',run_vec);
% g(1,1).geom_point();
% g(1,2) = gramm('x', rms_vals_ch2, 'y', corr_vec, 'color', subj_vec,'marker',run_vec);
% g(1,2).geom_point();
% 
% 
% %g.geom_point();
% %g.stat_glm();  % Fit regression line
% g.set_names('x','Mean RMS','y','Correlation','color','Subject');
% g.set_title('Correlation vs RMS');
% g.set_text_options('Font','Helvetica','base_size',12);
% %.set_point_options('base_size',10)
% g.set_point_options("markers",mymark, 'base_size',12)
% g.set_order_options('color',0)
% 
% g.draw();
% 
% filename = ('rms_corr_trend_gramm');
% g.export('file_name',filename, ...
%     'export_path',...
%     savedir,...
%     'file_type','pdf')

%% corr_vec is the correlation matrix from earlier 
% figure;
% scatter(mean_rms, corr_vec, 60, 'filled')
% xlabel('Mean RMS (CH1 & CH2)')
% ylabel('Correlation (CH1 vs CH2)')
% title('Correlation vs Amplitude (RMS)')
% grid on
% % Fit linear model: corr = beta0 + beta1 * RMS
% p = polyfit(mean_rms, corr_vec, 1);  % Degree 1 = linear
% 
% % Generate fit line
% x_fit = linspace(min(mean_rms), max(mean_rms), 100);
% y_fit = polyval(p, x_fit);
% 
% hold on;
% plot(x_fit, y_fit, 'r-', 'LineWidth', 2)
% legend('Data', sprintf('Linear Fit: y = %.2fx + %.2f', p(1), p(2)),'Location','best')
% h = gcf;
% thisFilename = [savedir 'rms_corr_trend'];
% %print(h, '-dpdf', thisFilename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI
% print(h, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI
% % Optional: stats
% mdl = fitlm(mean_rms, corr_vec);
% disp(mdl)  % Gives R², p-value, CI, etc.


% some plotting fixes
opMatsubs_noconv{3, 1, 8} = detrend(opMatsubs_noconv{3, 1, 8});
opMatsubs_noconv{3, 1, 5} = detrend(opMatsubs_noconv{3, 1, 5});


%% Now plot individual traces of EMG plots
run_idx = 1;  % Choose which run to plot (1 = '1barR', etc.)
run_label = {'1barR', 'lowR', '1barL', 'lowL'};
channel_colors = {'#1f78b4', '#d95f02'};  % ch1 = blue, ch2 = orange

for iRun = 3
    % Prepare figure
    figure('Position', [100 100 1400 600]);
    tiledlayout(2,5);  % 2 rows × 5 columns

    for subj = 1:10  % subjects 2 to 10 (i.e., 9 subjects)
        nexttile
        % Get EMG traces
        % if subj==1
        %     ch1 = opMatsubs_noconv{iRun, 2, subj};
        %     ch2 = opMatsubs_noconv{iRun, 1, subj};
        % else
        ch1 = opMatsubs_noconv{iRun, 1, subj};
        ch2 = opMatsubs_noconv{iRun, 2, subj};
        % end

        % rather than raw, can we do % of instructed leg
%         ch1_pct = 100 * ch1 / max(ch1);   
%         ch2_pct = 100 * ch2 / max(ch1);
        if subj==3
            plot(ch1(1:225), 'Color', channel_colors{1}, 'LineWidth', 1.2); hold on;
        else
            plot(ch1, 'Color', channel_colors{1}, 'LineWidth', 1.2); hold on;
        end
        if subj==3
            plot(ch2(1:225), 'Color', channel_colors{2}, 'LineWidth', 1.2);
        else
            plot(ch2, 'Color', channel_colors{2}, 'LineWidth', 1.2);
        end
        
        if subj~=10
            title(sprintf('s0%d', subj));
        else
            title(sprintf('s%d', subj));
        end
        ylim([-0.4 1.3]);  % Adjust based on range of EMG
        xlim([1 length(ch1)]);
        if subj == 1
            ylabel('Amplitude');
        end
        if subj == 1
            xlabel('Timepoints');
        end
    end

    %legend({'EMG ch1','EMG ch2'}, 'Position',[0.15 0.82 0.1 0.1]);  % optional
    legend({'EMG ch1','EMG ch2'},'Location','bestoutside');  % optional
    sgtitle(sprintf('EMG traces (Run: %s)', run_label{iRun}));

    thisFilename = [savedir 'renormemg_traces_per_subj_legend' run_label{iRun}];
    h = gcf;
    xx = 20;
    yy = 9;
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'inches');
    set(h, 'PaperSize', [xx yy]);  % Increase the paper size to 20x12 inches
    set(h, 'PaperPosition', [0 0 xx yy]);  % Adjust paper position to fill the paper size
    print(h, '-dpdf', thisFilename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI


end







%%
% figure('Position',[0 0 1000 800])
% flays = [1 3 7];
% for jj = flays
%     nexttile
%     plot(saveMat_noconv{jj,1},'linewidth',2)
%     hold on
%     %plot(saveMat_noconv{jj,2},'linewidth',2)
%     plot(signal)
%     %legend('Trispect force','ideal block','Location','best')
%     legend('ch1','ideal block')
%     title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
%     ylim([0 1])
% end
%
%
% h = gcf;
% set(h, 'PaperOrientation', 'landscape');
% set(h, 'PaperUnits', 'inches');
% set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
% set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
% print(h, '-dpdf', filename2, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI

return
%% just check resampling
figure('Position',[0 400 1600 800])
tiledlayout(2,2)

nexttile(1)
plot(saveMat_raw{5,1},'linewidth',2)
hold on
plot(saveMat_raw{6,1},'linewidth',2)
legend('raw','corrected')
title('emg')

nexttile(3)
plot(saveMat_raw{7,1},'linewidth',2)
hold on
plot(saveMat_raw{8,1},'linewidth',2)
legend('raw fMRI','corrected fMRI')

a = saveMat_raw{5,1};
b = saveMat_raw{6,1};
c = saveMat_raw{7,1};
d = saveMat_raw{8,1};
arsmpl = resample(a, target_num_samples,length(a));
brsmpl = resample(b, target_num_samples,length(b));
crsmpl = resample(c, target_num_samples,length(c));
drsmpl = resample(d, target_num_samples,length(d));

nexttile(2)
plot(arsmpl,'linewidth',1)
hold on
plot(brsmpl,'linewidth',2,'LineStyle','--')
legend('raw','corrected')
title('resampled')
nexttile(4)
plot(crsmpl,'linewidth',1)
hold on
plot(drsmpl,'linewidth',2,'LineStyle','--')
legend('raw fMRI','corrected fMRI')

%     if jj<5%4
%         title([extractBefore(myfiles{jj},'.') ' 1 bar'])
%     elseif jj>4%3
%         title([extractBefore(myfiles{jj},'_') ' 30 prc'])
%     end


%[FILEPATH,NAME,EXT] = fileparts(myfile1);
t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
filename = [savedir 'emg_raw_compare-' dataset '-' char(t)];

h = gcf;
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'inches');
set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
print(h, '-dpdf', filename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI




