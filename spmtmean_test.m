close all
clear all
clc

mypath = '/Volumes/nemosine/canapi_level2/1barR_testings';

mask = MRIread(fullfile(mypath,'prepostsmaCG_bin.nii'));
maskimg = mask.vol;

conpaths = {[fullfile(mypath,'sub01_con_0001.nii')],...
    [fullfile(mypath,'sub02_con_0001.nii')],...
    [fullfile(mypath,'sub03_con_0001.nii')],...
    [fullfile(mypath,'sub04_con_0001.nii')],...
};

% Preallocate
mean_vals = zeros(length(conpaths),1);
std_vals = zeros(length(conpaths),1);

% For the overlap map:
overlap_img = zeros(size(maskimg));  % same size as brain

for ii = 1:length(conpaths)
    thisfile = MRIread(conpaths{ii});
    thisimg = thisfile.vol;
    
    % Create a binary thresholded map for overlap
    active_voxels = thisimg > 0.1;  % threshold at 0 (adjust if you want)
    
    % Only count active voxels inside the mask
    active_voxels = active_voxels & (maskimg > 0);
    
    % Accumulate overlap
    overlap_img = overlap_img + active_voxels;
    
    % For mean/std inside ROI
    masked_vals = thisimg(maskimg>0);
    masked_vals = masked_vals(~isnan(masked_vals));
    mean_vals(ii) = mean(masked_vals);
    std_vals(ii) = std(masked_vals);
end

% At this point, overlap_img has values 0–4
%% Plotting
figure;
colormap(viridis(5));  % Use a 5-color colormap (0 to 4 levels)

% Prepare plotting volume
% You can threshold if you only want to show where overlap > 0
to_plot = overlap_img;
to_plot(to_plot==0) = NaN;  % Don't plot zeros (no activation)

% Display 3D slices
slice(double(to_plot),[],[],1:size(to_plot,3));  % Slices along Z axis
shading interp
axis equal tight
colorbar
clim([0 4]);  % Set colorbar from 0 to 4
title('Subject Overlap Map (0–4)')
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3);

%%
close all

%%% Paths
t1_path = '/Users/ppzma/data/MNI152_T1_2mm.nii.gz';  % <- your MNI T1 template path

% Load background T1
T1 = MRIread(t1_path);
T1img = T1.vol;

% Load your overlap map
% (Assume overlap_img is already loaded before this code)

% --- Plotting ---
figure('Position',[100 100 1024 768])
hold on;

% 1. Plot MNI T1 brain surface (outer brain)

% Threshold T1 to get brain tissue
brain_threshold = 5000;  % around this value is safe for T1-weighted images
brain_mask = T1img > brain_threshold;

% Smooth the brain mask to make the surface nicer
%brain_mask = smooth3(brain_mask, 'gaussian', [7 7 7], 2);  % more smoothing

% Create brain surface
brain_surf = isosurface(brain_mask, 0.5);

% Plot brain surface
brain_patch = patch(brain_surf);
brain_patch.FaceColor = [0.9 0.9 0.9];  % even lighter grey
brain_patch.EdgeColor = 'none';
brain_patch.FaceAlpha = 0;  % extremely transparent


% 2. Plot Overlap Surfaces (colored according to parula)

% Define  colormap with 4 steps
cmap = viridis(4);

for n = 1:4
    % Find voxels where overlap == n
    current_level = (overlap_img == n);
    
    if any(current_level(:))
        % Smooth slightly to make nicer surfaces
        %current_level = smooth3(current_level, 'gaussian', [5 5 5], 2);
        
        % Isosurface for this overlap level
        p = patch(isosurface(current_level, 0.3));
        
        % Use colormap color
        p.FaceColor = cmap(n,:);
        p.EdgeColor = 'none';
        p.FaceAlpha = 0.95;  % fairly solid
    end
end


daspect([1 1 1])
axis tight
rotate3d on

view([-154.0440 15.9896]);  % Example: left-right view

% axis equal off
% view(3)
% camlight headlight
% lighting gouraud
% material dull

% Colorbar setup
colorbar('Ticks', [1 2 3 4], 'TickLabels', {'1 Subject','2 Subjects','3 Subjects','4 Subjects'});
clim([1 4]);  % Same clim range
colormap(cmap);  % Set the colorbar to match surface colors

title('Subject Overlap on MNI152 Brain')

set(gcf, 'Color', 'w');  % Set background to white
set(gca, 'Color', 'none');  % Transparent axes background if needed
%
print(gcf, fullfile(mypath,'overlap_fig'), '-dpdf', '-r600', '-bestfit');


