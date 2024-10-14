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
myfiles = {'1bar.dat','30prc.dat','50prc.dat',...
    '1bar_LL.dat','30prc_LL.dat','50prc_LL.dat'};


Fs = 2500;
num_channels = 2;
target_num_samples = 114; % this is how long the fMRI timeseries is
TR = 1.5;
firstMarker = 2;
lastMarker = 11;
twoBefore = lastMarker-2;

%saveMat = struct('ch1',[],'ch2',[]);
saveMat = cell(length(myfiles),num_channels);
hrf = spm_hrf(TR);

tic
for ii = 1:length(myfiles)

    thisFile = load([mypath myfiles{ii}]);

    thisMarker = readtable([mypath extractBefore(myfiles{ii},'.') '_marker.txt']);
    
    %figure out ending. We end on an ON, so need to add the OFF and the ON
    %to the last marker position
    startMark = thisMarker.Position(firstMarker);
    endMark = thisMarker.Position(lastMarker)+(thisMarker.Position(lastMarker)-thisMarker.Position(twoBefore));
    
    % cut it to when the trials start, to when it ends
    ch1_clv = thisFile(1,startMark:endMark);
    ch2_clv = thisFile(2,startMark:endMark);
    thisLen = length(ch1_clv);
    thisLen_ch2 = length(ch2_clv);

    % detrend
    ch1_clv_dt = detrend(ch1_clv);
    ch2_clv_dt = detrend(ch2_clv);

    % zero centre
    ch1_clv_dt_nrm = ch1_clv_dt - mean(ch1_clv_dt);
    ch2_clv_dt_nrm = ch2_clv_dt - mean(ch2_clv_dt);

    % downsample the signal, to the desired target, here it is 114
    ch1_clv_dt_nrm_dsmpl = resample(ch1_clv_dt_nrm, target_num_samples,thisLen);
    ch2_clv_dt_nrm_dsmpl = resample(ch2_clv_dt_nrm, target_num_samples,thisLen_ch2);
    
    % convolve signal
    ch1_clv_dt_nrm_dsmpl_conv = conv(ch1_clv_dt_nrm_dsmpl, hrf);
    ch2_clv_dt_nrm_dsmpl_conv = conv(ch2_clv_dt_nrm_dsmpl, hrf);
    

    ch1_clv_dt_nrm_dsmpl_conv_clv = ch1_clv_dt_nrm_dsmpl_conv(1:target_num_samples);  % Trim to match original length
    ch2_clv_dt_nrm_dsmpl_conv_clv = ch2_clv_dt_nrm_dsmpl_conv(1:target_num_samples);  % Trim to match original length


%     figure
%     plot(ch1_clv_dt_nrm_dsmpl)
%     hold on
%     plot(ch2_clv_dt_nrm_dsmpl)

    saveMat{ii,1} = ch1_clv_dt_nrm_dsmpl_conv_clv;
    saveMat{ii,2} = ch2_clv_dt_nrm_dsmpl_conv_clv;

    saveMat_noconv{ii,1} = ch1_clv_dt_nrm_dsmpl;
    saveMat_noconv{ii,2} = ch2_clv_dt_nrm_dsmpl;


end
toc
disp('...done!')

%% save text files to enter later into SPM GLM

for kk = 1:length(myfiles)
    thisRow = saveMat{kk,1}';
    thisRowName = [mypath extractBefore(myfiles{kk},'.') '_ch1_dsmpled.txt'];
    writematrix(thisRow,thisRowName,'Delimiter','\t');

    thisRow = saveMat{kk,2}';
    thisRowName = [mypath extractBefore(myfiles{kk},'.') '_ch2_dsmpled.txt'];
    writematrix(thisRow,thisRowName,'Delimiter','\t');

end


%% plot
figure('Position',[0 400 1400 800])
tiledlayout(2,3)
for jj = 1:length(myfiles)
    nexttile
    plot(saveMat_noconv{jj,1},'linewidth',2)
    hold on
    plot(saveMat_noconv{jj,2},'linewidth',2)
    legend('ch1','ch2')

    if jj<4
        title([extractBefore(myfiles{1},'.') ' right leg'])
    elseif jj>3
        title([extractBefore(myfiles{4},'_') ' left leg'])
    end
end

%[FILEPATH,NAME,EXT] = fileparts(myfile1);
t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
filename = [savedir 'emg_dwnsmpl-' dataset '-' char(t)];

h = gcf;
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'inches');
set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
print(h, '-dpdf', filename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI








