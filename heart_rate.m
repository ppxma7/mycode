% disp('Choose a phys log file with a high heartrate') % Choose fMRI physlog as it's easy to find and is never broken
% [lFileName,lpath] = uigetfile({'*.log'},'Choose a phys log file with a high heartrate'); %Ellie
ccd
% lFileName = 'PHYSLOG_MARKERS_QST2.log';
% lpath = '/Volumes/ares/PFS/7T/spl/';

%lFileName = 'ScanPsaLog20220901130150_Thermode1.log';
lFileName = 'ScanPsaLog20220901130804_Thermode2.log';
lpath = '/Volumes/ares/PFS/3T/spl/';

disp('Reading in phys log...')
[v1raw, v2raw, v1, v2, ppu, resp, vsc, gx, gy, gz, mark, mark2] = textread(strcat(lpath,lFileName), ...
    '%d %d %d %d %d %d %d %d %d %d %s %s', 'headerlines', 6, 'whitespace', '#'); %read in the physlog and create correct columns and not to include first 6 lines.

disp('okay done.')
%figure, plot(ppu)

sample_rate = 2/1000; %% sample rate in s
FS=1/sample_rate;  %% Sample frequency (Hz)
N = length(ppu);
t  = (0:N-1)*sample_rate; % [s] Time vector
deltaF = FS/N; % [1/s]) frequency intervalue of discrete signal

scanLen = 300; %seconds (150 dynamics for thermode heat pain on 7T, TR2s)

if contains(lpath,'3T')
    minpeakdist = 200;
    minpeakh = 400;
else
    minpeakdist = 200;
    minpeakh = 1500;
end

LenOverRate = scanLen./sample_rate;
ppu_crop = ppu(length(ppu)-LenOverRate+1:end);
[PKS,LOCS] = findpeaks(ppu_crop,'MinPeakDistance',minpeakdist,'MinPeakHeight',minpeakh);
BPM = length(PKS)./(scanLen./60);

%
figure('color','white','position',[70 100 800 900]); 
tiledlayout(3,1)
nexttile
plot(1e3*t,ppu)
title(sprintf('Heartbeat data, scanLen=%d s, freq=%d Hz',scanLen,FS))
xlabel('t (ms)')
nexttile
findpeaks(ppu_crop,'MinPeakDistance',minpeakdist,'MinPeakHeight',minpeakh);
title(sprintf('BPM=%.1f',BPM))
xlabel('t (s)')

%
hot = [46 73 124 204 255 283];
warm = [20 99 151 177 229];
hot2 = [20 46 124 177 255];
warm2 = [73 99 151 204 229 282];

timings_hot = hot.*FS;
timings_warm = warm.*FS;
timings_hot2 = hot2.*FS;
timings_warm2 = warm2.*FS;

winlen = 500;
dy = movmean(ppu_crop,winlen);
% figure, plot(dy)

nexttile
plot(dy)
xline(timings_hot2,'r','Hot','LineWidth',2,'LabelVerticalAlignment','bottom')
xline(timings_warm2,'o','Warm','LineWidth',2,'LabelVerticalAlignment','bottom')
title(sprintf('stim onsets movmean, winlen=%d',winlen))

[FILEPATH,NAME,EXT] = fileparts([lpath lFileName]);
print('-dpdf', [FILEPATH '/' NAME '_plot.pdf'],'-bestfit')

