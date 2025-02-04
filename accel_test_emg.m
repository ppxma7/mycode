
close all
clear variables
clc
dataset = 'accel_test';
mypath='/Users/spmic/data/accel_testing/Export/';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/MSIR_fMRI_wrist/plots/'];

myfiles = {'accel_test_feb2025_Filters.dat'};


markerFiles = {'accel_test_feb2025_Filters_marker.txt'};

Fs = 2500;
num_channels = 5;
%target_num_samples = 228; % this is how long the fMRI timeseries is
%target_num_samples = 100; % without rest at end
%TR = 1.5;
firstMarker = 1;
lastMarker = 7;

winLen = 10000;

%saveMat = struct('ch1',[],'ch2',[]);
saveMat = cell(length(myfiles),num_channels);


tic
for ii = 1:length(myfiles)

    thisFile = load([mypath myfiles{ii}]);

    %thisMarker = readtable([mypath extractBefore(myfiles{ii},'.') '_marker.txt']);
    thisMarker = readtable([mypath markerFiles{ii}]);


    startMark = thisMarker.Position(firstMarker);
    endMark = thisMarker.Position(lastMarker);

    EMG1 = thisFile(1,startMark:endMark);
    EMG2 = thisFile(2,startMark:endMark);
    a3DX = thisFile(3,startMark:endMark);
    a3DY = thisFile(4,startMark:endMark);
    a3DZ = thisFile(5,startMark:endMark);

    saveMat{ii,1} = EMG1;
    saveMat{ii,2} = EMG2;
    saveMat{ii,3} = a3DX;
    saveMat{ii,4} = a3DY;
    saveMat{ii,5} = a3DZ;


   

end

%% plot


%% plot
close all
t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
filename1 = [savedir 'accel_test' dataset '-' char(t)];
figure('Position',[0 0 1400 800])
tiledlayout(5,1)

titles = {'EMG1','EMG2','X','Y','Z'};

for ii = 1:5
    nexttile
    plot(saveMat{ii},'linewidth',2,'Color','#1f78b4')
    hold on
    xline(thisMarker.Position,'r')
    title(titles{ii})
end

% title('EMG1')
% nexttile
% plot(saveMat{2},'linewidth',2,'Color','#1f78b4')
% title('EMG2')
% nexttile
% plot(saveMat{3},'linewidth',2,'Color','#1f78b4')
% title('X')
% nexttile
% plot(saveMat{4},'linewidth',2,'Color','#1f78b4')
% title('Y')
% nexttile
% plot(saveMat{5},'linewidth',2,'Color','#1f78b4')
% title('Z')


h = gcf;
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'inches');
set(h, 'PaperSize', [20 12]);  % Increase the paper size to 20x12 inches
set(h, 'PaperPosition', [0 0 20 12]);  % Adjust paper position to fill the paper size
print(h, '-dpdf', filename1, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI









