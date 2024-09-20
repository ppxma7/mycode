% check SPM12 motion parameters
close all
clear variables
thispath = '/Volumes/hermes/zespri_tasks/spm_analysis/';
nSubs = 14;
session = 'D';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/nback_motion/'];
for ii = 1:nSubs
    thisSub = [thispath 'session_' session '/nback/rp_nback_' num2str(ii) session '.txt'];
    thisTxt = load(thisSub);

    figure('Position',[100 100 700 400])
    tiledlayout(2,2)
    nexttile([1 2])
    plot(thisTxt(:,1),'LineWidth',2)
    hold on
    plot(thisTxt(:,2),'LineWidth',2)
    plot(thisTxt(:,3),'LineWidth',2)
    legend('x','y','z','Location','eastoutside')
    %ylim([-0.8 0.8])
    grid minor
    ylabel('mm')
    title(sprintf('Subject_ %s%s',num2str(ii), session))
    nexttile([1 2])
    plot(thisTxt(:,4),'LineWidth',2)
    hold on
    plot(thisTxt(:,5),'LineWidth',2)
    plot(thisTxt(:,6),'LineWidth',2)
    legend('pitch','roll','yaw','Location','eastoutside')
    %ylim([-0.02 0.02])
    grid minor
    ylabel('degrees/radians')
    print([savedir 'subject_motion_' num2str(ii) session '.png'], '-dpng', '-r300');


end

%% same for brand task

% check SPM12 motion parameters
close all
clear variables
thispath = '/Volumes/hermes/zespri_tasks/spm_analysis/brand_D/brand_data/';
nSubs = 14;
session = '2';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/brand_motion/'];
for ii = 1:nSubs

    if ii~=8
        thisSub = [thispath 'rp_brand' session '_' num2str(ii) 'D.txt'];
        thisTxt = load(thisSub);

        figure('Position',[100 100 700 400])
        tiledlayout(2,2)
        nexttile([1 2])
        plot(thisTxt(:,1),'LineWidth',2)
        hold on
        plot(thisTxt(:,2),'LineWidth',2)
        plot(thisTxt(:,3),'LineWidth',2)
        legend('x','y','z','Location','eastoutside')
        %ylim([-0.8 0.8])
        grid minor
        ylabel('mm')
        title(sprintf('Subject %s Session %s',num2str(ii), session))
        nexttile([1 2])
        plot(thisTxt(:,4),'LineWidth',2)
        hold on
        plot(thisTxt(:,5),'LineWidth',2)
        plot(thisTxt(:,6),'LineWidth',2)
        legend('pitch','roll','yaw','Location','eastoutside')
        %ylim([-0.02 0.02])
        grid minor
        ylabel('degrees/radians')
        print([savedir 'subject_' num2str(ii) '_move_session_' session '.png'], '-dpng', '-r300');
    else
        disp('skipping subject 8')
    end


end