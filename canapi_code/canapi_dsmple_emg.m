% get EMG signal
% get marker files
% downsample and use in GLM


close all
clear variables
clc
dataset = 'canapi_full_run_111024';
mypath='/Volumes/hermes/canapi_full_run_111024/EMG/Export/';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_full_run_111024/plots/'];

% myfiles = {'1bar_raw.dat','1bar_corrected.dat','1bar_fMRI_raw.dat','1bar_fMRI_corrected.dat',...
%     '30prc_raw.dat','30prc_corrected.dat','30prc_fMRI_raw.dat','30prc_fMRI_corrected.dat',...
%     };
% 
% markerFiles = {'1bar_marker.txt','1bar_marker.txt','1bar_fMRI_marker.txt','1bar_fMRI_marker.txt',...
%     '30prc_marker.txt','30prc_marker.txt','30prc_fMRI_marker.txt','30prc_fMRI_marker.txt',...
%     };

myfiles = {'1bar_rectify.dat','1bar_LL_rectify.dat','30prc_rectify.dat',...
    '50prc_LL_rectify.dat','30prc_LL_rectify.dat','70prc_LL_rectify.dat','50prc_rectify.dat'};
markerFiles = {'1bar_marker.txt','1bar_LL_marker.txt','30prc_marker.txt',...
    '50prc_LL_marker.txt','30prc_LL_marker.txt','70prc_LL_marker.txt','50prc_marker.txt'};


Fs = 2500;
num_channels = 2;
target_num_samples = 114; % this is how long the fMRI timeseries is
%target_num_samples = 100; % without rest at end
TR = 1.5;
firstMarker = 2;
lastMarker = 11;
twoBefore = lastMarker-2;

winLen = 10000;

%saveMat = struct('ch1',[],'ch2',[]);
saveMat = cell(length(myfiles),num_channels);
hrf = spm_hrf(TR);

tic
for ii = 1:length(myfiles)

    thisFile = load([mypath myfiles{ii}]);

    %thisMarker = readtable([mypath extractBefore(myfiles{ii},'.') '_marker.txt']);
    thisMarker = readtable([mypath markerFiles{ii}]);

    
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
% 







%     figure
%     plot(ch1_clv_dt_nrm_dsmpl)
%     hold on
%     plot(ch2_clv_dt_nrm_dsmpl)

    saveMat{ii,1} = ch1_clv_dt_nrm_dsmpl_conv_clv;
    saveMat{ii,2} = ch2_clv_dt_nrm_dsmpl_conv_clv;

    saveMat_noconv{ii,1} = ch1_clv_dt_nrm_dsmpl;
    saveMat_noconv{ii,2} = ch2_clv_dt_nrm_dsmpl;

    saveMat_raw{ii,1} = ch1_clv_dt_nrm;
    saveMat_raw{ii,2} = ch2_clv_dt_nrm;


end
toc
disp('...done!')

%% save text files to enter later into SPM GLM

for kk = 1:length(myfiles)
    thisRow = saveMat{kk,1}';
    thisRowName = [mypath extractBefore(myfiles{kk},'.') '_rectify_ch1_dsmpled.txt'];
    writematrix(thisRow,thisRowName,'Delimiter','\t');

    thisRow = saveMat{kk,2}';
    thisRowName = [mypath extractBefore(myfiles{kk},'.') '_rectify_ch2_dsmpled.txt'];
    writematrix(thisRow,thisRowName,'Delimiter','\t');

end

%% get default sig

[~,signal] = wavySignal(0,1);
signal = signal./2;



%% plot
% figure('Position',[0 400 1600 800])
% tiledlayout(2,4)
% for jj = 1:length(myfiles)
%     nexttile
%     plot(saveMat_noconv{jj,1},'linewidth',2)
%     hold on
%     plot(saveMat_noconv{jj,2},'linewidth',2)
%     plot(signal)
%     %legend('Trispect force','ideal block','Location','best')
%     legend('ch1','ch2','ideal block')
% 
% %     if jj<5%4
% %         title([extractBefore(myfiles{jj},'.') ' 1 bar'])
% %     elseif jj>4%3
% %         title([extractBefore(myfiles{jj},'_') ' 30 prc'])
% %     end
%      title([extractBefore(myfiles{jj},'.')],'Interpreter','none'))
% 
% end
%[FILEPATH,NAME,EXT] = fileparts(myfile1);
t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
filename1 = [savedir 'emg_dwnsmpl-LL' dataset '-' char(t)];
filename2 = [savedir 'emg_dwnsmpl-RL' dataset '-' char(t)];

figure('Position',[0 0 1000 800])
flays = [2 5 4 6];
for jj = flays
    nexttile
    % plot(saveMat_noconv{jj,1},'linewidth',2)
    % hold on
    plot(saveMat_noconv{jj,2},'linewidth',2)
    hold on
    plot(signal)
    %legend('Trispect force','ideal block','Location','best')
    legend('ch2','ideal block')
    title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
    ylim([0 1])
end


h = gcf;
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'inches');
set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
print(h, '-dpdf', filename1, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI


figure('Position',[0 0 1000 800])
flays = [1 3 7];
for jj = flays
    nexttile
    plot(saveMat_noconv{jj,1},'linewidth',2)
    hold on
    %plot(saveMat_noconv{jj,2},'linewidth',2)
    plot(signal)
    %legend('Trispect force','ideal block','Location','best')
    legend('ch1','ideal block')
    title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
    ylim([0 1])
end


h = gcf;
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'inches');
set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
print(h, '-dpdf', filename2, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI


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




