close all
clear variables
clc

% remake this script ignoring the EMG for now, just use accelerometer
% traces
% ignore sub1 as well as they have no accel

dataset = {'canapi_sub02_180325', 'canapi_sub03_180325',...
    'canapi_sub04_280425','canapi_sub05_240625', 'canapi_sub06_240625',...
    'canapi_sub07_010725', 'canapi_sub08_010725', 'canapi_sub09_160725', ...
    'canapi_sub10_160725'};


saveem = 1;
ch2normch1 = 1;

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/ACCELplots/'];

myfiles = {
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

mySlices = {1:4, 5:8, 9:12, 13:16, 17:20, 21:24, 25:28, 29:32, 33:36};

markerFiles = cell(1,length(myfiles));
for ii = 1:length(myfiles)
    markerFiles{ii} = [extractBefore(myfiles{ii},'.') '_marker.txt'];
end

Fs = 2500;
num_channels = 2;
target_num_samples = 227; % this is how long the fMRI timeseries is
%target_num_samples = 100; % without rest at end
TR = 1.5;
firstMarker = 2;
lastMarker = 17;
twoBefore = lastMarker-2;

winLen = 10000;

saveMat = cell(length(4),num_channels);
hrf = spm_hrf(TR);

%% get default sig

[~,signal] = wavySignal(0,1);
signal = signal./2;

tic

for iSub = 1:length(dataset)

    disp(['Running subject ' dataset{iSub}])

    for ii = 1:4

        mypath=['/Volumes/kratos/CANAPI/' dataset{iSub} '/EMG/Export/'];


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
        startMark = thisMarker.Position(firstMarker);
        endMark = thisMarker.Position(lastMarker)+(thisMarker.Position(lastMarker)-thisMarker.Position(twoBefore));

        % fudge for now
        % startMark = 5000;
        %endMark = length(thisFile);
        %endMark = 1900000;

        ch1_clv = thisFile(3,startMark:endMark);
        ch2_clv = thisFile(4,startMark:endMark);
        ch3_clv = thisFile(5,startMark:endMark);

        thisLen = length(ch1_clv);

        % ----- limb vector magnitude -----
        active_mag = sqrt(ch1_clv.^2 + ch2_clv.^2 + ch3_clv.^2);
        
        [active_env, ~] = envelope(active_mag, winLen, 'rms');

        baselineX = 100000;

        baseR = mean(active_env(1:baselineX));

        active_zero = max(0, active_env - baseR);

        task = active_zero;

        task_dsmpl    = resample(task, target_num_samples, thisLen);
        
        % --- scale to 0-1 ---
        maxVal = max(task_dsmpl);
        if maxVal > 0
            task_dsmpl = task_dsmpl ./ maxVal;
        end
 
        % figure
        % plot(task_dsmpl)

        task_conv    = conv(task_dsmpl, hrf);
        task_conv    = task_conv(1:target_num_samples);

        %%
        saveMat{ii,1} = task_conv;

        saveMat_noconv{ii,1} = task_dsmpl;

        % save for operation later
        opMatsubs{ii,1,iSub} = task_conv;

        opMatsubs_noconv{ii,1,iSub} = task_dsmpl;


    end

    %% save text files to enter later into SPM GLM - per subject

    if saveem

        for kk = 1:4

            thisSlice = mySlices{iSub}(kk);

            thisRow = saveMat{kk,1}';
            thisRowName = [mypath extractBefore(myfiles{thisSlice},'.') '_rectify_ACTIVE_dsmpled.txt'];
            writematrix(thisRow,thisRowName,'Delimiter','\t');


        end
    end

    %% plotting
    if saveem
        %close all
        t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
        filename1 = [savedir 'accel_dwnsmpl_' dataset{iSub} '-' char(t)];
        figure('Position',[0 0 1400 800])
        tiledlayout(2,2)

        flays = 4; %4; %[2 5 4 6];
        for jj = 1:flays

            plotSlice = mySlices{iSub}(jj);
            thisFile  = myfiles{plotSlice};

            nexttile
            plot(saveMat_noconv{jj,1},'linewidth',2,'Color','#1f78b4')
            hold on
            
            plot(signal)
            legend('Active','ideal block')
            title(thisFile,'Interpreter','none')  % <-- full filename

            %title([extractBefore(myfiles{jj},'.')],'Interpreter','none')
            %ylim([0 0.2])
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

