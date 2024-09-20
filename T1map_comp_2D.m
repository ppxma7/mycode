clear all; close all; clc;

%subj = {'SUB01', 'SUB02', 'SUB03', 'SUB04', 'SUB05', 'SUB06', 'SUB07', 'SUB08', 'SUB09', 'SUB10'};
subj = {'16280','12428','0408','1810','15435_221024'};

% 16280, 12528 = Becky 3T
% 15435 = 3T
% 0408, 1810 = 7T

import mlreportgen.ppt.*;
ppt_path = '/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/T1 mapping - General/twod_subtractions/';
cd(ppt_path)
ppt = Presentation('T1maps2D.pptx'); %ppt_path,
open(ppt);
slide1 = add(ppt,'Title Slide');
replace(slide1,'Title','T1 maps 2D');
replace(slide1,'Subtitle','Michael Asghar');

ncol = 256;
[colormap] = cbrewer('div', 'RdBu', 256,'pchip');

    
for n=1:length(subj)
    
    % read in T1 maps and do the difference here
    mypath = [ppt_path,subj{n} '/'];
    t1_name = [subj{n},'_clv_T1.nii.gz'];
    t1_nordic_name = [subj{n},'_nordic_clv_T1.nii.gz'];
    t1_data = niftiread([mypath,t1_name]);
    t1_data_nordic = niftiread([mypath,t1_nordic_name]);
    t1_diff = t1_data_nordic - t1_data;
    t1_diff(t1_data==0) = NaN;
    
    r2_name = [subj{n},'_clv_R2.nii.gz'];
    r2_nordic_name = [subj{n},'_nordic_clv_R2.nii.gz'];
    r2_data = niftiread([mypath,r2_name]);
    r2_data_nordic = niftiread([mypath,r2_nordic_name]);
    r2_diff = r2_data_nordic - r2_data;
    r2_diff(r2_data==0) = NaN;
    
    % seg 0 = WM, seg 1 = GM, seg 2 = CSF.
    
    t1gm_name = [subj{n},'_clv_T1_seg_0.nii.gz'];
    t1gm_nordic_name = [subj{n},'_nordic_clv_T1_seg_0.nii.gz'];
    t1gm_data = niftiread([mypath, 'fast_n3/', t1gm_name]);
    t1gm_data = double(t1gm_data); % reads in as int32 for some reason
    t1gm_data_nordic = niftiread([mypath,'fast_nordic_n3/',t1gm_nordic_name]);
    t1gm_data_nordic = double(t1gm_data_nordic);
    %t1gm_data(t1gm_data==0) = NaN; % don't NaN here as we need to logical
    %index
    %t1gm_data_nordic(t1gm_data_nordic==0) = NaN;
    
    % we have to mask the T1 maps with the GM maps output from FSL FAST
    t1gm_data_vec = logical(t1gm_data(:));
    t1gm_data_nordic_vec = logical(t1gm_data_nordic(:));
    t1_data_vec = t1_data(:);
    t1_data_nordic_vec = t1_data_nordic(:);
    
    t1_data_vec_GM = t1_data_vec.*t1gm_data_vec; %mask
    t1_data_nordic_vec_GM = t1_data_nordic_vec.*t1gm_data_nordic_vec;
    
    t1gm_data_GM = reshape(t1_data_vec_GM,size(t1_data));
    t1gm_data_nordic_GM = reshape(t1_data_nordic_vec_GM,size(t1_data_nordic));
    
    % now Dan's tiling function
    close all;
    tight_tile(t1_data,'gray',0,3500);
    %t1_fig = [mypath,t1_name(1:length(t1_name)),'_tiled.png'];
    t1_fig = [mypath extractBefore(t1_name,'.'),'_tiled.png'];
    saveas(gcf,t1_fig)

    tight_tile(t1_data_nordic,'gray',0,3500);
    t1_nordic_fig = [mypath,extractBefore(t1_nordic_name,'.'),'tiled.png'];
    saveas(gcf,t1_nordic_fig)
    
    tight_tile(t1_diff,'inferno',-20,20);
    t1_diff_fig = [mypath,extractBefore(t1_nordic_name,'.'),'_difference_tiled.png'];
    saveas(gcf,t1_diff_fig)
    t1fig_position = get(gcf,'position');
    
    tight_tile(r2_data,'gray',0.95,1);
    r2_fig = [mypath,extractBefore(r2_name,'.'),'_R2_tiled.png'];
    saveas(gcf,r2_fig)

    tight_tile(r2_data_nordic,'gray',0.95,1);
    r2_nordic_fig = [mypath,extractBefore(r2_nordic_name,'.'),'_R2_tiled.png'];
    saveas(gcf,r2_nordic_fig)
    
    tight_tile(r2_diff,'inferno',-0.2,0.2);
    r2_diff_fig = [mypath,extractBefore(r2_nordic_name,'.'),'_R2_difference_tiled.png'];
    saveas(gcf,r2_diff_fig)
    
    % show the GM masks
    tight_tile(t1gm_data,'gray',0,1);
    t1gm_fig = [mypath,extractBefore(t1gm_name,'.'),'_T1GM_tiled.png'];
    saveas(gcf,t1gm_fig)
    
    tight_tile(t1gm_data_nordic,'gray',0,1);
    t1gm_nordic_fig = [mypath,extractBefore(t1gm_nordic_name,'.'),'_T1GM_nordic_tiled.png'];
    saveas(gcf,t1gm_nordic_fig)
    
    % create histograms
    [values, edges] = histcounts(t1_data(t1_data~=0));
    centers = (edges(1:end-1)+edges(2:end))/2;
    figure; area(centers, values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    %figure; histogram(t1_data(t1_data~=0),edges)
    ylabel('Count'); xlabel('T1'); xlim([0 5000]); legend('Pre NORDIC');
    t1_histogram = [mypath,extractBefore(t1_name,'.'),'_histogram.png'];
    saveas(gcf,t1_histogram)
 
    [values, edges] = histcounts(t1_data_nordic(t1_data_nordic~=0));
    centers = (edges(1:end-1)+edges(2:end))/2;
    area(centers, values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    %hold on; histogram(t1_data_nordic(t1_data_nordic~=0),edges)
    ylabel('Count'); xlabel('T1'); xlim([0 5000]); legend('Post NORDIC');
    t1_nordic_histogram = [mypath,extractBefore(t1_nordic_name,'.'),'_histogram.png'];
    saveas(gcf,t1_nordic_histogram)
  
    
    [values, edges] = histcounts(r2_data(r2_data~=0),20000);
    centers = (edges(1:end-1)+edges(2:end))/2;
    figure; area(centers, values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('R^2'); xlim([0.98 1.005]); legend('Pre NORDIC');
    r2_histogram = [mypath,extractBefore(r2_name,'.'),'_R2_histogram.png'];
    %saveas(gcf,r2_histogram)
    
    [values, edges] = histcounts(r2_data_nordic(r2_data_nordic~=0),20000);
    centers = (edges(1:end-1)+edges(2:end))/2;
    hold on; area(centers, values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('R^2'); xlim([0.98 1.005]); legend('Pre NORDIC','Post NORDIC');
    r2_nordic_histogram = [mypath,extractBefore(r2_nordic_name,'.'),'_R2_histogram.png'];
    saveas(gcf,r2_nordic_histogram)
    
    [values, edges] = histcounts(t1gm_data_GM(t1gm_data_GM~=0));
    centers = (edges(1:end-1)+edges(2:end))/2;
    figure; area(centers, values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('T1GM'); xlim([0 2500]); legend('Pre NORDIC');
    t1gm_histogram = [mypath,extractBefore(t1gm_name,'.'),'_T1GM_histogram.png'];
    %saveas(gcf,r2_histogram)
    
    [values, edges] = histcounts(t1gm_data_nordic_GM(t1gm_data_nordic_GM~=0));
    centers = (edges(1:end-1)+edges(2:end))/2;
    hold on; area(centers, values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('T1GM'); xlim([0 2500]); legend('Pre NORDIC','Post NORDIC');
    t1gm_nordic_histogram = [mypath,extractBefore(t1gm_nordic_name,'.'),'_T1GM_histogram.png'];
    saveas(gcf,t1gm_nordic_histogram)
   
    
    %Create Powerpoint Slides for each subject
    
    t1map = Picture(t1_nordic_fig);
    t1map.Width = num2str(1.4*t1fig_position(3)); t1map.Height = num2str(1.4*t1fig_position(4));
    t1map.X = '10'; t1map.Y = '140';
    pictureSlide = add(ppt,'Title Only');
    replace(pictureSlide,'Title',[subj{n}, ' T1 Pre-NORDIC']);
    add(pictureSlide,t1map);
    
    t1map_hist = Picture(t1_histogram);
    t1map_hist.Width = '560'; t1map_hist.Height = '420';
    t1map_hist.X = '740'; t1map_hist.Y = '190';
    add(pictureSlide,t1map_hist);

    t1map_nordic = Picture(t1_fig);
    t1map_nordic.Width = num2str(1.4*t1fig_position(3)); t1map_nordic.Height = num2str(1.4*t1fig_position(4));
    t1map_nordic.X = '10'; t1map_nordic.Y = '140';
    pictureSlide2 = add(ppt,'Title Only');
    replace(pictureSlide2,'Title',[subj{n}, ' T1 Post-NORDIC']);
    add(pictureSlide2,t1map_nordic);
    
    t1map_nordic_hist = Picture(t1_nordic_histogram);
    t1map_nordic_hist.Width = '560'; t1map_nordic_hist.Height = '420';
    t1map_nordic_hist.X = '740'; t1map_nordic_hist.Y = '190';
    add(pictureSlide2,t1map_nordic_hist);
    
    t1map_diff = Picture(t1_diff_fig);
    t1map_diff.Width = num2str(1.4*t1fig_position(3)); t1map_diff.Height = num2str(1.4*t1fig_position(4));
    t1map_diff.X = '10'; t1map_diff.Y = '140';
    pictureSlide3 = add(ppt,'Title Only');
    replace(pictureSlide3,'Title',[subj{n}, ' T1 Value difference']);
    add(pictureSlide3,t1map_diff);
    
    r2map_diff = Picture(r2_diff_fig);
    r2map_diff.Width = num2str(1.4*t1fig_position(3)); r2map_diff.Height = num2str(1.4*t1fig_position(4));
    r2map_diff.X = '10'; r2map_diff.Y = '140';
    pictureSlide4 = add(ppt,'Title Only');
    replace(pictureSlide4,'Title',[subj{n}, ' R^2 Value difference']);
    add(pictureSlide4,r2map_diff);
    
    r2_nordic_hist_hist = Picture(r2_nordic_histogram);
    r2_nordic_hist_hist.Width = '560'; r2_nordic_hist_hist.Height = '420';
    r2_nordic_hist_hist.X = '740'; r2_nordic_hist_hist.Y = '190';
    add(pictureSlide4,r2_nordic_hist_hist);
    
    % masks
    t1gm_map = Picture(t1gm_fig);
    t1gm_map.Width = num2str(1.4*t1fig_position(3)); t1gm_map.Height = num2str(1.4*t1fig_position(4));
    t1gm_map.X = '10'; t1gm_map.Y = '140';
    pictureSlide5 = add(ppt,'Title Only');
    replace(pictureSlide5,'Title',[subj{n}, ' T1 GM']);
    add(pictureSlide5,t1gm_map);
    
    t1gm_nordic_map = Picture(t1gm_nordic_fig);
    t1gm_nordic_map.Width = num2str(1.4*t1fig_position(3)); t1gm_nordic_map.Height = num2str(1.4*t1fig_position(4));
    t1gm_nordic_map.X = '10'; t1gm_nordic_map.Y = '140';
    pictureSlide5 = add(ppt,'Title Only');
    replace(pictureSlide5,'Title',[subj{n}, ' T1 GM Nordic']);
    add(pictureSlide5,t1gm_nordic_map);
    
    t1gm_hist = Picture(t1gm_nordic_histogram);
    t1gm_hist.Width = '560'; t1gm_hist.Height = '420';
    t1gm_hist.X = '740'; t1gm_hist.Y = '190';
    add(pictureSlide5,t1gm_hist);
    
    
end

close(ppt);
%rptview(ppt)

disp('Done!')
