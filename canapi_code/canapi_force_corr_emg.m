
close all
clear variables
clc

dataset = {'canapi_sub10_160725'};

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/forceplots/'];


myfiles = {
    'CANAPI_sub10_RL_1bar_Rectify.dat','CANAPI_sub10_RL_15per_Rectify.dat',...
    'CANAPI_sub10_LL_1bar_Rectify.dat','CANAPI_sub10_LL_15per_Rectify.dat',...
    };

myfiles = {
    'CANAPI_sub10_LL_1bar_Rectify.dat',...
    };
mySlices = {1:4, 5:8, 9:12, 13:16, 17:20, 21:24, 25:28, 29:32, 33:36, 37:40};

forcefile = {'CANAPI_subj10_LL_1bar_Force.csv'};

markerFiles = cell(1,length(myfiles));
for ii = 1:length(myfiles)
    markerFiles{ii} = [extractBefore(myfiles{ii},'.') '_marker.txt'];
end

Fs = 2500;
num_channels = 2;
target_num_samples = 227; % this is how long the fMRI timeseries is
TR = 1.5;
firstMarker = 2;
lastMarker = 17;
twoBefore = lastMarker-2;

winLen = 10000;

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


        ch1_clv_dt_nrm_dsmpl = ch1_clv_dt_nrm_dsmpl(1:target_num_samples);
        ch2_clv_dt_nrm_dsmpl = ch2_clv_dt_nrm_dsmpl(1:target_num_samples);

        % get z trace
        ch5_clv = thisFile(5,startMark:endMark);
        thisLen5 = length(ch5_clv);
        [myupper5, mylower5] = envelope(ch5_clv,winLen,'rms');
        ch5_clv_dt_nrm = normalize(myupper5,'range');
        ch5_clv_dt_nrm_dsmpl = resample(ch5_clv_dt_nrm, target_num_samples,thisLen5);
        ch5_clv_dt_nrm_dsmpl = ch5_clv_dt_nrm_dsmpl(1:target_num_samples);

        ch1_clv_dt_nrm_dsmpl = transpose(ch1_clv_dt_nrm_dsmpl);
        ch5_clv_dt_nrm_dsmpl = transpose(ch5_clv_dt_nrm_dsmpl);


        %%
        forcepath = ['/Volumes/kratos/' dataset{iSub} '/forceplot/'];

        thisforce = readtable([forcepath forcefile{thisSlice}]);
        thisforce_data = thisforce.Var1;

        startMark_frc = 1500;
        endMark_frc = 7700;


        frc_clv = thisforce_data(startMark_frc:endMark_frc);
        %
        [myupperfrc, mylowerfrc] = envelope(frc_clv,80,'rms');
        
        frc_clv_nrm = normalize(myupperfrc,'range');

        frc_clv_nrm_rs = resample(frc_clv_nrm, target_num_samples,length(frc_clv_nrm));
        %%
        close all
        
        r_frc_emg(ii,iSub) = corr(frc_clv_nrm_rs, ch1_clv_dt_nrm_dsmpl);
        r_frc_acc(ii,iSub) = corr(frc_clv_nrm_rs, ch5_clv_dt_nrm_dsmpl);
        r_emg_acc(ii,iSub) = corr(ch1_clv_dt_nrm_dsmpl, ch5_clv_dt_nrm_dsmpl);

        disp(['frc v emg: ' num2str(r_frc_emg(ii,iSub))])
        disp(['frc v accel: ' num2str(r_frc_acc(ii,iSub))])
        disp(['accel v emg: ' num2str(r_emg_acc(ii,iSub))])
        
        figure('Position',[100 100 1200 700])
        tiledlayout(2,2)
        nexttile
        plot(frc_clv_nrm_rs,'linewidth',2)
        hold on
        plot(ch1_clv_dt_nrm_dsmpl,'linewidth',2)
        ylabel('Pearson Correlation')
        legend('Force trace','EMG LL 1bar','location','southeast')
        title(['Force vs EMG r: ' num2str(r_frc_emg(ii,iSub))])

        nexttile
        plot(frc_clv_nrm_rs,'linewidth',2)
        hold on
        plot(ch5_clv_dt_nrm_dsmpl,'linewidth',2)
        ylabel('Pearson Correlation')
        legend('Force trace','Accel Z','location','southoutside')
        title(['Force vs Accel r: ' num2str(r_frc_acc(ii,iSub))])

        nexttile
        plot(ch1_clv_dt_nrm_dsmpl,'linewidth',2)
        hold on
        plot(ch5_clv_dt_nrm_dsmpl,'linewidth',2)
        ylabel('Pearson Correlation')
        legend('EMG LL 1bar','Accel Z','location','southeast')
        title(['EMG vs Accel r: ' num2str(r_emg_acc(ii,iSub))])

        %t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
        filename = [savedir 'forcetrace_v_emg_v_accel-' dataset{iSub}];

        h = gcf;
        a = 20;
        b = 12;

        set(h, 'PaperOrientation', 'landscape');
        set(h, 'PaperUnits', 'inches');
        set(h, 'PaperSize', [a b]);  % Increase the paper size to 20x12 inches
        set(h, 'PaperPosition', [0 0 a b]);  % Adjust paper position to fill the paper size
        print(h, '-dpdf', filename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI


        



        %%







    end
end




