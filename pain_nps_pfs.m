%% little script to apply the nps mask from Tor Wager
% Want to get the outputs and also plot the predicted timeseries from the
% signature.
% Would be nice to see how this correlates with SPM as well.
%
% REF:
% Wager, T. D., Atlas, L. Y., Lindquist, M. A., Roy, M., Woo, C. W., 
% & Kross, E. (2013). An fMRI-based neurologic signature of physical pain. 
% The New England journal of medicine, 
% 368(15), 1388-1397. doi:10.1056/NEJMoa1204471

clear variables
close all
clc

% Locate data
mypath='/Volumes/ares/PFS/canlab_nps/3T_hand/';
cd(mypath)

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/PFP_results/canlab_nps/'];

%savedir = '/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Pain Relief Grant - General/PFP_results/canlab_nps/';

% Load both runs of the hand heat pain stimulation
inputs_ts = {'swvrthermode1_27_toppedupabs.nii','swvrthermode2_28_toppedupabs.nii'};

% Get timings
heat1 = [46 73 124 204 255 282];
warm1 = [20 99 151 177 229];
heat2 = [20 46 124 177 255];
warm2 = [73 99 151 204 229 282];

% Run CANLAB mask
% https://github.com/canlab/Neuroimaging_Pattern_Masks
[nps_values, image_names, data_objects] = apply_nps(inputs_ts);

% Run it for SPM maps as well
inputs={'spmT_0001.nii','spmT_0002.nii'};
[nps_values_spm, image_names_spm, data_objects_spm] = apply_nps(inputs);



%% plot
fig = figure('Position',[100 100 1024 768]);
set(fig, 'PaperPositionMode', 'auto'); % Set PaperPositionMode to auto
set(fig, 'PaperOrientation', 'landscape'); % Set PaperOrientation to landscape
tiledlayout(2,2)
nexttile(1,[1 2])
plot(nps_values{1},'k','LineWidth',2)
xline(heat1,'r','heat')
xline(warm1,'b','warm')
title(sprintf('3T: Hand Run 1 / NPS SPMT Heat %.2f / NPS SPMT Warm %.2f',nps_values_spm{1},nps_values_spm{2}))
legend('Predicted NPS response from TSeries','Location','southoutside','FontSize',11)
nexttile(3,[1 2])
plot(nps_values{2},'k','LineWidth',2)
xline(heat2,'r','heat')
xline(warm2,'b','warm')
title('Hand Run 2')
legend('Predicted NPS response from TSeries','Location','southoutside','FontSize',11)
print([savedir '3T_NPS_PFS_plot.pdf'], '-dpdf', '-r300','-bestfit');


%% Now also do it for 7T
mypath='/Volumes/ares/PFS/canlab_nps/7T_hand/';
cd(mypath)

% Load both runs of the hand heat pain stimulation
inputs_ts = {'swvrqst1_clv_nord_RCR_toppedupabs.nii','swvrqst2_clv_nord_RCR_toppedupabs.nii'};



% Run CANLAB mask
% https://github.com/canlab/Neuroimaging_Pattern_Masks
[nps_values, image_names, data_objects] = apply_nps(inputs_ts);

% Run it for SPM maps as well
inputs={'spmT_0001.nii','spmT_0002.nii'};
[nps_values_spm, image_names_spm, data_objects_spm] = apply_nps(inputs);

%% plot
% Get timings
heat1 = round([46 73 124 204 255 282]./2);
warm1 = round([20 99 151 177 229]./2);
heat2 = round([20 46 124 177 255]./2);
warm2 = round([73 99 151 204 229 282]./2);

fig = figure('Position',[100 100 1024 768]);
set(fig, 'PaperPositionMode', 'auto'); % Set PaperPositionMode to auto
set(fig, 'PaperOrientation', 'landscape'); % Set PaperOrientation to landscape
tiledlayout(2,2)
nexttile(1,[1 2])
plot(nps_values{1},'k','LineWidth',2)
xline(heat1,'r','heat')
xline(warm1,'b','warm')
title(sprintf('7T: Hand Run 1 / NPS SPMT Heat %.2f / NPS SPMT Warm %.2f',nps_values_spm{1},nps_values_spm{2}))
legend('Predicted NPS response from TSeries','Location','southoutside','FontSize',11)
nexttile(3,[1 2])
plot(nps_values{2},'k','LineWidth',2)
xline(heat2,'r','heat')
xline(warm2,'b','warm')
title('Hand Run 2')
legend('Predicted NPS response from TSeries','Location','southoutside','FontSize',11)
print([savedir '7T_NPS_PFS_plot.pdf'], '-dpdf', '-r300','-bestfit');



