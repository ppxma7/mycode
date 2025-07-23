% get EMG signal
% get marker files
% downsample and use in GLM


close all
clear variables
clc
%dataset = 'canapi_sub01_030225';
%dataset = 'canapi_sub02_180325';
%dataset = 'canapi_sub03_180325';
%dataset = 'canapi_sub04_280425';
%dataset = 'canapi_sub05_240625';
%dataset = 'canapi_sub06_240625';
%dataset = 'canapi_sub07_010725';
%dataset = 'canapi_sub08_010725';
%dataset = 'canapi_sub10_160725';
dataset = {'canapi_sub01_030225', 'canapi_sub02_180325', 'canapi_sub03_180325',...
    'canapi_sub04_280425','canapi_sub05_240625', 'canapi_sub06_240625',...
    'canapi_sub07_010725', 'canapi_sub08_010725', 'canapi_sub09_160725', ...
    'canapi_sub10_160725'};

saveem = 0;

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/EMGplots/'];

% myfiles = {'CANAPI01_RL_1BAR_Rectify.dat','CANAPI01_RL_15per_Rectify.dat',...
%     'CANAPI01_LL_1BAR_Rectify.dat','CANAPI01_LL_15per_Rectify.dat',...
%     };

% myfiles = {'CANAPI_sub02_R_1BAR_Rectify.dat','CANAPI_sub02_R_15per_Rectify.dat',...
%     'CANAPI_sub02_L_1BAR_Rectify.dat','CANAPI_sub02_L_15per_Rectify.dat',...
%     };

% myfiles = {'CANAPI_sub03_R_1BAR_redo2_Rectify.dat','CANAPI_sub03_R_15per_Rectify.dat',...
%     'CANAPI_sub03_L_1BAR_Rectify.dat','CANAPI_sub03_L_15per_Rectify.dat',...
%     };
%
% myfiles = {'CANAPI_sub04_R_1BAR_redo_Rectify.dat','CANAPI_sub04_R_15per_Rectify.dat',...
%     'CANAPI_sub04_L_1BAR_Rectify.dat','CANAPI_sub04_L_15per1_Rectify.dat',...
%     };

% myfiles = {'CANAPI_sub05_RL_1bar_Rectify.dat','CANAPI_sub05_RL_15per_Rectify.dat',...
%     'CANAPI_sub05_LL_1bar_r2_Rectify.dat','CANAPI_sub05_LL_15per_Rectify.dat',...
%     };
% myfiles = {'CANAPI_sub06_RL_1bar2_Rectify.dat','CANAPI_sub06_RL_15per_Rectify.dat',...
%     'CANAPI_sub06_LL_1bar_Rectify.dat','CANAPI_sub06_LL_15per_Rectify.dat',...
%     };
% myfiles = {'CANAPI_sub07_RL_1barreal_Rectify.dat','CANAPI_sub07_RL_15per_Rectify.dat',...
%     'CANAPI_sub07_LL_1bar_Rectify.dat','CANAPI_sub07_LL_15per_Rectify.dat',...
%     };
% myfiles = {'CANAPI_sub08_RL_1bar2_Rectify.dat','CANAPI_sub08_RL_15per_Rectify.dat',...
%     'CANAPI_sub08_LL_1bar_Rectify.dat','CANAPI_sub08_LL_15per_Rectify.dat',...
%     };
% myfiles = {'CANAPI_sub09_RL_1bar_Rectify.dat','CANAPI_sub09_RL_15per_Rectify.dat',...
%     'CANAPI_sub09_LL_1bar_Rectify.dat','CANAPI_sub09_LL_15per_Rectify.dat',...
%     };
% myfiles = {'CANAPI_sub10_RL_1bar_Rectify.dat','CANAPI_sub10_RL_15per_Rectify.dat',...
%     'CANAPI_sub10_LL_1bar_Rectify.dat','CANAPI_sub10_LL_15per_Rectify.dat',...
%     };

myfiles = {'CANAPI01_RL_1BAR_Rectify.dat','CANAPI01_RL_15per_Rectify.dat',...
    'CANAPI01_LL_1BAR_Rectify.dat','CANAPI01_LL_15per_Rectify.dat',...
    'CANAPI_sub02_R_1BAR_Rectify.dat','CANAPI_sub02_R_15per_Rectify.dat',...
    'CANAPI_sub02_L_1BAR_Rectify.dat','CANAPI_sub02_L_15per_Rectify.dat',...
    'CANAPI_sub03_R_1BAR_redo2_Rectify.dat','CANAPI_sub03_R_15per_Rectify.dat',...
    'CANAPI_sub03_L_1BAR_Rectify.dat','CANAPI_sub03_L_15per_Rectify.dat',...
    'CANAPI_sub04_R_1BAR_redo_Rectify.dat','CANAPI_sub04_R_15per_Rectify.dat',...
    'CANAPI_sub04_L_1BAR_Rectify.dat','CANAPI_sub04_L_15per1_Rectify.dat',...
    'CANAPI_sub05_RL_1bar_Rectify.dat','CANAPI_sub05_RL_15per_Rectify.dat',...
    'CANAPI_sub05_LL_1bar_r2_Rectify.dat','CANAPI_sub05_LL_15per_Rectify.dat',...
    'CANAPI_sub06_RL_1bar2_Rectify.dat','CANAPI_sub06_RL_15per_Rectify.dat',...
    'CANAPI_sub06_LL_1bar_Rectify.dat','CANAPI_sub06_LL_15per_Rectify.dat',...
    'CANAPI_sub07_RL_1barreal_Rectify.dat','CANAPI_sub07_RL_15per_Rectify.dat',...
    'CANAPI_sub07_LL_1bar_Rectify.dat','CANAPI_sub07_LL_15per_Rectify.dat',...
    'CANAPI_sub08_RL_1bar2_Rectify.dat','CANAPI_sub08_RL_15per_Rectify.dat',...
    'CANAPI_sub08_LL_1bar_Rectify.dat','CANAPI_sub08_LL_15per_Rectify.dat',...
    'CANAPI_sub09_RL_1bar_Rectify.dat','CANAPI_sub09_RL_15per_Rectify.dat',...
    'CANAPI_sub09_LL_1bar_Rectify.dat','CANAPI_sub09_LL_15per_Rectify.dat',...
    'CANAPI_sub10_RL_1bar_Rectify.dat','CANAPI_sub10_RL_15per_Rectify.dat',...
    'CANAPI_sub10_LL_1bar_Rectify.dat','CANAPI_sub10_LL_15per_Rectify.dat',...
    };

mySlices = {1:4, 5:8, 9:12, 13:16, 17:20, 21:24, 25:28, 29:32, 33:36, 37:40};


markerFiles = cell(1,length(myfiles));
for ii = 1:length(myfiles)
    markerFiles{ii} = [extractBefore(myfiles{ii},'.') '_marker.txt'];
end

%
%
% markerFiles = {'CANAPI_sub08_RL_1bar2_Rectify_marker.txt','CANAPI_sub08_RL_15per_Rectify_marker.txt',...
%     'CANAPI_sub08_LL_1bar_Rectify_marker.txt','CANAPI_sub08_LL_15per_Rectify_marker.txt'};

Fs = 2500;
num_channels = 2;
target_num_samples = 227; % this is how long the fMRI timeseries is
%target_num_samples = 100; % without rest at end
TR = 1.5;
firstMarker = 2;
lastMarker = 17;
twoBefore = lastMarker-2;

winLen = 10000;

%saveMat = struct('ch1',[],'ch2',[]);
saveMat = cell(length(4),num_channels);
hrf = spm_hrf(TR);

%% get default sig

[~,signal] = wavySignal(0,1);
signal = signal./2;

tic

for iSub = 1:length(dataset)

    disp(['Running subject ' dataset{iSub}])

    for ii = 1:4

        mypath=['/Volumes/kratos/' dataset{iSub} '/EEG/Export/'];

        
        thisSlice =mySlices{iSub}(ii);
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
        startMark = thisMarker.Position(firstMarker);
        endMark = thisMarker.Position(lastMarker)+(thisMarker.Position(lastMarker)-thisMarker.Position(twoBefore));

        % this is for the version where there was no rest at the end
        %endMark = thisMarker.Position(lastMarker)+(thisMarker.Position(lastMarker-1)-thisMarker.Position(twoBefore));

        % cut it to when the trials start, to when it ends
        ch1_clv = thisFile(1,startMark:endMark);
        ch2_clv = thisFile(2,startMark:endMark);
        thisLen = length(ch1_clv);
        thisLen_ch2 = length(ch2_clv);

        % % detrend
        % ch1_clv_dt = detrend(ch1_clv);
        % ch2_clv_dt = detrend(ch2_clv);
        %
        % % zero centre
        % ch1_clv_dt_nrm = ch1_clv_dt - mean(ch1_clv_dt);
        % ch2_clv_dt_nrm = ch2_clv_dt - mean(ch2_clv_dt);
        [myupper, mylower] = envelope(ch1_clv,winLen,'rms');
        [myupper2, mylower2] = envelope(ch2_clv,winLen,'rms');

        ch1_clv_dt_nrm = normalize(myupper,'range');
        ch2_clv_dt_nrm = normalize(myupper2,'range');

        % downsample the signal, to the desired target, here it is 114
        disp('resampling')
        ch1_clv_dt_nrm_dsmpl = resample(ch1_clv_dt_nrm, target_num_samples,thisLen);
        ch2_clv_dt_nrm_dsmpl = resample(ch2_clv_dt_nrm, target_num_samples,thisLen_ch2);

        % convolve signal
        ch1_clv_dt_nrm_dsmpl_conv = conv(ch1_clv_dt_nrm_dsmpl, hrf);
        ch2_clv_dt_nrm_dsmpl_conv = conv(ch2_clv_dt_nrm_dsmpl, hrf);


        ch1_clv_dt_nrm_dsmpl_conv_clv = ch1_clv_dt_nrm_dsmpl_conv(1:target_num_samples);  % Trim to match original length
        ch2_clv_dt_nrm_dsmpl_conv_clv = ch2_clv_dt_nrm_dsmpl_conv(1:target_num_samples);  % Trim to match original length



        %     figure('Position',[100 100 600 800])
        %     tiledlayout(5,1)
        %     nexttile
        %     plot(ch1_clv)
        %     title('signal')
        %     nexttile
        %     plot(ch1_clv_dt)
        %     title('signal+detrend')
        %     nexttile
        %     plot(ch1_clv_dt_nrm)
        %     title('signal+detrend+normalize')
        %     nexttile
        %     plot(ch1_clv_dt_nrm_dsmpl)
        %     title('signal+detrend+normalize+dsmple')
        %     nexttile
        %     plot(ch1_clv_dt_nrm_dsmpl_conv_clv)
        %     title('signal+detrend+normalize+dsmple+convolve')
        %     filename = [savedir 'emg-proc-steps' extractBefore(myfiles{ii},'.')];
        %     h = gcf;
        %     set(h, 'PaperOrientation', 'landscape');
        %     set(h, 'PaperUnits', 'inches');
        %     set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
        %     set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
        %     print(h, '-dpdf', filename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI
        %%
        saveMat{ii,1} = ch1_clv_dt_nrm_dsmpl_conv_clv;
        saveMat{ii,2} = ch2_clv_dt_nrm_dsmpl_conv_clv;

        saveMat_noconv{ii,1} = ch1_clv_dt_nrm_dsmpl;
        saveMat_noconv{ii,2} = ch2_clv_dt_nrm_dsmpl;

        saveMat_raw{ii,1} = ch1_clv_dt_nrm;
        saveMat_raw{ii,2} = ch2_clv_dt_nrm;

        %% optional if you have accelerometer traces

        if size(thisFile,1) == 5

            ch3_clv = thisFile(3,startMark:endMark);
            ch4_clv = thisFile(4,startMark:endMark);
            ch5_clv = thisFile(5,startMark:endMark);

            thisLen = length(ch3_clv);

            [myupper3, mylower3] = envelope(ch3_clv,winLen,'rms');
            [myupper4, mylower4] = envelope(ch4_clv,winLen,'rms');
            [myupper5, mylower5] = envelope(ch5_clv,winLen,'rms');


            ch3_clv_dt_nrm = normalize(myupper3,'range');
            ch4_clv_dt_nrm = normalize(myupper4,'range');
            ch5_clv_dt_nrm = normalize(myupper5,'range');

            % downsample the signal, to the desired target, here it is 114
            ch3_clv_dt_nrm_dsmpl = resample(ch3_clv_dt_nrm, target_num_samples,thisLen);
            ch4_clv_dt_nrm_dsmpl = resample(ch4_clv_dt_nrm, target_num_samples,thisLen);
            ch5_clv_dt_nrm_dsmpl = resample(ch5_clv_dt_nrm, target_num_samples,thisLen);

            % convolve signal
            ch3_clv_dt_nrm_dsmpl_conv = conv(ch3_clv_dt_nrm_dsmpl, hrf);
            ch4_clv_dt_nrm_dsmpl_conv = conv(ch4_clv_dt_nrm_dsmpl, hrf);
            ch5_clv_dt_nrm_dsmpl_conv = conv(ch5_clv_dt_nrm_dsmpl, hrf);


            ch3_clv_dt_nrm_dsmpl_conv_clv = ch3_clv_dt_nrm_dsmpl_conv(1:target_num_samples);  % Trim to match original length
            ch4_clv_dt_nrm_dsmpl_conv_clv = ch4_clv_dt_nrm_dsmpl_conv(1:target_num_samples);  % Trim to match original length
            ch5_clv_dt_nrm_dsmpl_conv_clv = ch5_clv_dt_nrm_dsmpl_conv(1:target_num_samples);  % Trim to match original length

            saveMat{ii,3} = ch3_clv_dt_nrm_dsmpl_conv_clv;
            saveMat{ii,4} = ch4_clv_dt_nrm_dsmpl_conv_clv;
            saveMat{ii,5} = ch5_clv_dt_nrm_dsmpl_conv_clv;

            saveMat_noconv{ii,3} = ch3_clv_dt_nrm_dsmpl;
            saveMat_noconv{ii,4} = ch4_clv_dt_nrm_dsmpl;
            saveMat_noconv{ii,5} = ch5_clv_dt_nrm_dsmpl;

            saveMat_raw{ii,3} = ch3_clv_dt_nrm;
            saveMat_raw{ii,4} = ch4_clv_dt_nrm;
            saveMat_raw{ii,5} = ch5_clv_dt_nrm;
        end


        % save for operation later
        opMatsubs{ii,1,iSub} = ch1_clv_dt_nrm_dsmpl_conv_clv;
        opMatsubs{ii,2,iSub} = ch2_clv_dt_nrm_dsmpl_conv_clv;
        opMatsubs_noconv{ii,1,iSub} = ch1_clv_dt_nrm_dsmpl;
        opMatsubs_noconv{ii,2,iSub} = ch2_clv_dt_nrm_dsmpl;
        opMatsubs_raw{ii,1,iSub} = ch1_clv_dt_nrm;
        opMatsubs_raw{ii,2,iSub} = ch2_clv_dt_nrm;
        if size(thisFile,1) == 5
            opMatsubs{ii,3,iSub} = ch3_clv_dt_nrm_dsmpl_conv_clv;
            opMatsubs{ii,4,iSub} = ch4_clv_dt_nrm_dsmpl_conv_clv;
            opMatsubs{ii,5,iSub} = ch5_clv_dt_nrm_dsmpl_conv_clv;
            opMatsubs_noconv{ii,3,iSub} = ch3_clv_dt_nrm_dsmpl;
            opMatsubs_noconv{ii,4,iSub} = ch4_clv_dt_nrm_dsmpl;
            opMatsubs_noconv{ii,5,iSub} = ch5_clv_dt_nrm_dsmpl;
            opMatsubs_raw{ii,3,iSub} = ch3_clv_dt_nrm;
            opMatsubs_raw{ii,4,iSub} = ch4_clv_dt_nrm;
            opMatsubs_raw{ii,5,iSub} = ch5_clv_dt_nrm;
        end



    end

    %% save text files to enter later into SPM GLM - per subject

    if saveem

        for kk = 1:4

            thisSlice = mySlices{iSub}(kk);

            thisRow = saveMat{kk,1}';
            thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ch1_dsmpled.txt'];
            writematrix(thisRow,thisRowName,'Delimiter','\t');

            thisRow = saveMat{kk,2}';
            thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ch2_dsmpled.txt'];
            writematrix(thisRow,thisRowName,'Delimiter','\t');

            %optional save accel traces if emg looks bad

            if size(thisFile,1) == 5
                thisRow = saveMat{kk,3}';
                thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ch3_dsmpled.txt'];
                writematrix(thisRow,thisRowName,'Delimiter','\t');

                thisRow = saveMat{kk,4}';
                thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ch4_dsmpled.txt'];
                writematrix(thisRow,thisRowName,'Delimiter','\t');

                thisRow = saveMat{kk,5}';
                thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ch5_dsmpled.txt'];
                writematrix(thisRow,thisRowName,'Delimiter','\t');
            end

        end
    end
    
    %% plotting
    if saveem
        close all
        t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
        filename1 = [savedir 'emg_dwnsmpl_' dataset{iSub} '-' char(t)];
        figure('Position',[0 0 1400 800])
        tiledlayout(2,2)

        flays = 4; %[2 5 4 6];
        for jj = 1:flays
            nexttile
            plot(saveMat_noconv{jj,1},'linewidth',2,'Color','#1f78b4')
            hold on
            plot(saveMat_noconv{jj,2},'linewidth',1,'Color','#d95f02')
            hold on
            plot(signal)
            legend('ch1','ch2','ideal block')
            title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
            ylim([0 1])
        end

        h = gcf;
        set(h, 'PaperOrientation', 'landscape');
        set(h, 'PaperUnits', 'inches');
        set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
        set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
        print(h, '-dpdf', filename1, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI

        if size(thisFile,1) == 5

            t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
            filename1 = [savedir 'accel_emg_dwnsmpl_' dataset{iSub} '-' char(t)];
            figure('Position',[0 0 1400 800])
            tiledlayout(2,2)

            flays = 4; %[2 5 4 6];
            for jj = 1:flays
                nexttile
                plot(saveMat_noconv{jj,3},'linewidth',1,'Color','#1b9e77')
                hold on
                plot(saveMat_noconv{jj,4},'linewidth',1,'Color','#d95f02')
                hold on
                plot(saveMat_noconv{jj,5},'linewidth',1,'Color','#7570b3')
                hold on
                plot(signal,'Color','#EDB120')
                legend('x','y','z','ideal block')
                title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
                ylim([0 1])
            end
            h = gcf;
            set(h, 'PaperOrientation', 'landscape');
            set(h, 'PaperUnits', 'inches');
            set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
            set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
            print(h, '-dpdf', filename1, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI

        end
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

for subj = 1:10
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
run_labels = {'1barR', 'lowR', '1barL', 'lowL'};
%subject_labels = arrayfun(@(s) sprintf('Subject %d', s), 2:10, 'UniformOutput', false);
subject_labels = arrayfun(@(s) sprintf('Subject %d', s), 1:10, 'UniformOutput', false);

corr_vec = [];
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
figure('Position',[100 100 1200 800])

g = gramm('x', run_vec, 'y', corr_vec);
g.stat_summary('geom', {'bar', 'black_errorbar'}, 'type', 'sem');
g.set_names('x','Run','y','Ch1 ↔ Ch2 corr');
g.set_title('Correlation between EMG ch1 and ch2 across runs');
g.axe_property('YLim', [-0.2 1.2]);
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.draw();
g.update('y',corr_vec,'color', subj_vec)
g.geom_jitter2('dodge', 0.6);  % Optional: show individual subjects

g.draw();

filename = ('corr_vec_channel_1_2_noconv');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% I want to look at amplitudes of the no conv EMG traces
rms_matrix = zeros(nSubjects, nRuns * nChans);  % 10 x 8 (4 runs × 2 chans)
labels = {};

idx = 1;
for run = 1:nRuns
    for chan = 1:nChans
        labels{idx} = sprintf('%s - %s', run_labels{run}, channel_labels{chan});
        for subj = 1:10
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


% Now plot individual traces of EMG plots
run_idx = 1;  % Choose which run to plot (1 = '1barR', etc.)
run_label = {'1barR', 'lowR', '1barL', 'lowL'};
channel_colors = {'#1f78b4', '#d95f02'};  % ch1 = blue, ch2 = orange

for iRun = 1:4
    % Prepare figure
    figure('Position', [100 100 1600 600]);
    tiledlayout(2,5);  % 2 rows × 5 columns

    for subj = 1:10  % subjects 2 to 10 (i.e., 9 subjects)
        nexttile
        % Get EMG traces
        ch1 = opMatsubs_noconv{iRun, 1, subj};
        ch2 = opMatsubs_noconv{iRun, 2, subj};

        plot(ch1, 'Color', channel_colors{1}, 'LineWidth', 1.2); hold on;
        plot(ch2, 'Color', channel_colors{2}, 'LineWidth', 1.2);

        title(sprintf('Subject %d', subj));
        ylim([-0.1 1]);  % Adjust based on range of EMG
        xlim([1 length(ch1)]);
        if subj == 2
            ylabel('Amplitude');
        end
        if subj >= 8
            xlabel('Timepoints');
        end
    end

    legend({'EMG ch1','EMG ch2'}, 'Position',[0.85 0.5 0.1 0.1]);  % optional
    sgtitle(sprintf('Raw EMG traces (Run: %s)', run_label{iRun}));

    thisFilename = [savedir 'emg_traces_per_subj_' run_label{iRun}];
    h = gcf;
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'inches');
    set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
    set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
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




