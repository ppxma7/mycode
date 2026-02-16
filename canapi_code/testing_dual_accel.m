dataset = {'canapi_test_outside_dual_accel'};
myfiles = {'canapi_outside_test_Rectify.dat'};

markerFiles = cell(1,length(myfiles));
for ii = 1:length(myfiles)
    markerFiles{ii} = [extractBefore(myfiles{ii},'.') '_marker.txt'];
end

mySlices = {1};

startMark = 5000;
endMark = 14000;

for iSub = 1:length(dataset)

    thisSlice = mySlices{iSub}(ii);
    mypath=['/Volumes/kratos/CANAPI/' dataset{iSub} '/EEG/Export/'];
    thisFile = load([mypath myfiles{thisSlice}]);
    thisMarker = readtable([mypath markerFiles{thisSlice}]);



    %keyboard

end

%%
Fs = 2500;
num_channels = 6;
target_num_samples = 227; % this is how long the fMRI timeseries is
%target_num_samples = 100; % without rest at end
TR = 1.5;
winLen = 30;
hrf = spm_hrf(TR);

accel1 = thisFile(1,startMark:endMark);
accel2 = thisFile(2,startMark:endMark);
accel3 = thisFile(3,startMark:endMark);
accel4 = thisFile(4,startMark:endMark);
accel5 = thisFile(5,startMark:endMark);
accel6 = thisFile(6,startMark:endMark);

thisLen = length(accel1);

%%
%[myupper, mylower] = envelope(accel1, winLen,'rms');
close all
clc
[myupper, mylower] = envelope(accel1,30,'rms');
[myupper4, mylower4] = envelope(accel4,30,'rms');

figure
plot(myupper)
hold on
plot(myupper4)

%%
close all
clc
a = normalize(myupper,'range');
aa = resample(a, target_num_samples, thisLen);
figure
plot(aa)
aaa = conv(aa, hrf);
plot(aaa)


%%



figure('Position',[0 0 1400 800])
tiledlayout(1,2)

flays = 6; %[2 5 4 6];
for jj = 1:flays
    nexttile
    plot(accel1{jj,1},'linewidth',2,'Color','#1f78b4')
    hold on
    plot(saveMat_noconv{jj,2},'linewidth',1,'Color','#d95f02')
    hold on
    plot(signal)
    legend('ch1','ch2','ideal block')
    title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
    ylim([0 1])
end