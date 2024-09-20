% GSR freq is 250Hz

ccd

%mypath='/Volumes/ares/PFS/correctedgsr/7TGSR/7tgsr/';
mypath='/Volumes/ares/PFS/correctedgsr/3TGSR/3tgsr/';
%mypath='/Volumes/ares/';
% 
% run1='16227_7t_1/export/';
% run2='16227_7t_2/export/';
% run3='16227_7t_outsode/export/';
run1='16227_3t_1/export/';
run2='16227_3t_2/export/';

%run1='gsr_pain01/export/';
%run2='gsr_pain02/export/';

cd(mypath)

%myfile1=[mypath run1 '16227_7t_1_Scanner Artifact Correction.dat'];
%myfile1=[mypath run2 'Pain0020_Scanner Artifact Correction.dat'];
%myfile1=[mypath run3 '16227_outside2_Scanner Artifact Correction.dat'];

%myfile1=[mypath run1 '16227_1_redo_Scanner Artifact Correction.dat'];
myfile1=[mypath run2 '16227_2_Scanner Artifact Correction.dat'];

%myfile1=[mypath run2 'painsub2_hand1_Scanner Artifact Correction 2.dat'];
%myfile1=[mypath run2 'painsub2hand2_Scanner Artifact Correction 2.dat'];
%myfile1=[mypath run2 'painsub2_arm2_Scanner Artifact Correction 2.dat'];

% myfile1=[mypath run1 'painpostcap2_Scanner Artifact Correction.dat'];
% myfile1=[mypath run1 'postCapthermode_1_Scanner Artifact Correction.dat'];
% myfile1=[mypath run1 'thermodearm_12778_1711_Scanner Artifact Correction'];
% myfile1=[mypath run1 'thermodearmblock2_12778_1711_Scanner Artifact Correction.dat'];

T3 = readtable(myfile1);
% T3_crop_arr = T3{:,:};
% T3_crop_arr{1}(1:4) = [];
% T3_char = char(T3_crop_arr);
% T3_num = str2num(T3_char);
% T3_vec = T3_num(:);
% 
% figure, plot(T3_vec);

if contains(myfile1,'Raw Data') %  || contains(myfile1,'Scanner')
    T3_crop_arr = T3{:,:};
    T3_crop_arr{1}(1:4) = [];
    T3_char = char(T3_crop_arr);
    T3_num = str2num(T3_char);
    T3_crop_arr_det = T3_num(:);
else
    T3_crop = T3(1,3:end);
    T3_crop_arr = T3_crop{:,:};
    T3_crop_arr_det = detrend(T3_crop_arr);
end


%

% T3_crop = T3(1,3:end);
% T3_crop_arr = T3_crop{:,:};
% T3_crop_arr_det = detrend(T3_crop_arr);
% % a = 10;
% b = 81000;
a = 1000;
b = 80000;
T3v = T3_crop_arr_det(a:b);

%
hot = [46 73 124 204 255 283];
warm = [20 99 151 177 229];
hot2 = [20 46 124 177 255];
warm2 = [73 99 151 204 229 282];
%
T3v = T3v.*-1;

close all
x = T3v;
fpass = 1/60;
fs = 250;

timings_hot = hot.*fs;
timings_warm = warm.*fs;
timings_hot2 = hot2.*fs;
timings_warm2 = warm2.*fs;

%
y = highpass(x,fpass,fs);
%fpass_low = 0.0001;
%ylow = highpass(y,fpass_low,fs);
%figure, plot(ylow)
%
%
figure('Position',[0 400 1200 800])
tiledlayout(3,1)
nexttile
plot(T3v,'Linewidth',2)
title('Raw')
nexttile
plot(y,'LineWidth',2)
xline(timings_hot,'r','LineWidth',2)
xline(timings_warm,'o','LineWidth',2)
title(sprintf('Highpass filter %.3f Hz',fpass))
nexttile
winlen = 100;
dy = movmean(y,winlen);
plot(dy,'LineWidth',2)
xline(timings_hot,'r','LineWidth',2)
xline(timings_warm,'o','LineWidth',2)
title(sprintf('Moving average %d window length',winlen))
% 
% [FILEPATH,NAME,EXT] = fileparts(myfile1);
% print('-dpdf', [FILEPATH NAME '_plot.pdf'])

[FILEPATH,NAME,EXT] = fileparts(myfile1);
t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');

h = gcf;
set(h,'PaperOrientation','landscape')
print(h,'-dpdf',[FILEPATH '/' NAME '_' char(t) '_plot.pdf'],'-bestfit')



%% external scanner data 7/11/23

% GSR freq is 250Hz

ccd
%mypath='/Volumes/styx/gsr_071123/Export/';
mypath='/Users/spmic/data/gsr_071123/Export/';
%run1='gsr_071123/Export/';

cd(mypath)

myfile1=[mypath 'Untitled_Raw Data.dat'];

T3 = readtable(myfile1);

if contains(myfile1,'Raw Data') %  || contains(myfile1,'Scanner')
    T3_crop_arr = T3{:,:};
    %T3_crop_arr{1}(1:4) = [];
    T3_crop_arr{1}(1:12) = [];
    T3_char = char(T3_crop_arr);
    T3_num = str2num(T3_char);
    T3_crop_arr_det = T3_num(:);
else
    T3_crop = T3(1,3:end);
    T3_crop_arr = T3_crop{:,:};
    T3_crop_arr_det = detrend(T3_crop_arr);
end

a = 10000;
b = 800000;
T3v = T3_crop_arr_det(a:b);

%
hot = [46 73 124 204 255 283];
warm = [20 99 151 177 229];


%
close all

T3v = T3v.*-1;
x = detrend(T3v);
fpass = 1/60;
fs = 2500;

timings_hot = hot.*fs;
timings_warm = warm.*fs;


%
y = highpass(x,fpass,fs);
%fpass_low = 0.0001;
%ylow = highpass(y,fpass_low,fs);
%figure, plot(ylow)
%
%
figure('Position',[0 400 1400 800])
tiledlayout(3,1)
nexttile
plot(T3v,'Linewidth',2)
title('Raw')
nexttile
plot(y,'LineWidth',2)
xline(timings_hot,'r','LineWidth',2)
xline(timings_warm,'o','LineWidth',2)
title(sprintf('Highpass filter %.3f Hz',fpass))
nexttile
winlen = 100;
dy = movmean(y,winlen);
plot(dy,'LineWidth',2)
xline(timings_hot,'r','LineWidth',2)
xline(timings_warm,'o','LineWidth',2)
title(sprintf('Moving average %d window length',winlen))

[FILEPATH,NAME,EXT] = fileparts(myfile1);
t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');

h = gcf;
set(h,'PaperOrientation','landscape')
print(h,'-dpdf',[FILEPATH '/' NAME '_' char(t) '_plot.pdf'],'-bestfit')


























