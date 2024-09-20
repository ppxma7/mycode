clear all; close all; clc;

subj = {'SUB01', 'SUB02', 'SUB03', 'SUB04', 'SUB05', 'SUB06', 'SUB07', 'SUB08', 'SUB09', 'SUB10'};

import mlreportgen.ppt.*;
ppt_path = 'R:\DRS-Laminar-Layers\Dan\VASO_Layers\';
cd(ppt_path)
ppt = Presentation("T1maps.pptx"); %ppt_path,
open(ppt);
slide1 = add(ppt,"Title Slide");
replace(slide1,"Title","T1 maps");
    
for n=1:length(subj)

    mypath = ['R:\DRS-Laminar-Layers\Dan\VASO_Layers\',subj{n},'\Structural\NIFTI\'];
    t1_name = [subj{n},'_T1map_clv_T1map.nii.gz'];
    t1_nordic_name = [subj{n},'_T1map_nordic_clv_T1map.nii.gz'];
    t1_data = niftiread([mypath,t1_name]);
    t1_data_nordic = niftiread([mypath,'NORDIC\',t1_nordic_name]);
    t1_diff = t1_data - t1_data_nordic;
    t1_diff(t1_data==0) = NaN;
    
    r2_name = [subj{n},'_T1map_clv_R2map.nii.gz'];
    r2_nordic_name = [subj{n},'_T1map_nordic_clv_R2map.nii.gz'];
    r2_data = niftiread([mypath,r2_name]);
    r2_data_nordic = niftiread([mypath,'NORDIC\',r2_nordic_name]);
    r2_diff = r2_data - r2_data_nordic;
    r2_diff(r2_data==0) = NaN;
    
    close all;
    tight_tile(t1_data,'gray',0,3500);
    t1_fig = [mypath,t1_name(1:11),'_tiled.png'];
    saveas(gcf,t1_fig)

    tight_tile(t1_data_nordic,'gray',0,3500);
    t1_nordic_fig = [mypath,'NORDIC\',t1_nordic_name(1:18),'tiled.png'];
    saveas(gcf,t1_nordic_fig)
    
    tight_tile(t1_diff,'jet',-20,20);
    t1_diff_fig = [mypath,'NORDIC\',t1_nordic_name(1:18),'_difference_tiled.png'];
    saveas(gcf,t1_diff_fig)
    t1fig_position = get(gcf,'position');
    
    tight_tile(r2_data,'gray',0.95,1);
    r2_fig = [mypath,r2_name(1:11),'_R2_tiled.png'];
    saveas(gcf,r2_fig)

    tight_tile(r2_data_nordic,'gray',0.95,1);
    r2_nordic_fig = [mypath,'NORDIC\',r2_nordic_name(1:18),'_R2_tiled.png'];
    saveas(gcf,r2_nordic_fig)
    
    tight_tile(r2_diff,'jet',-0.01,0.01);
    r2_diff_fig = [mypath,'NORDIC\',r2_nordic_name(1:18),'_R2_difference_tiled.png'];
    saveas(gcf,r2_diff_fig)
    
    [values, edges] = histcounts(t1_data(t1_data~=0));
    centers = (edges(1:end-1)+edges(2:end))/2;
    figure; area(centers, values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('T1'); xlim([0 5000]); legend('Pre NORDIC');
    t1_histogram = [mypath,t1_name(1:11),'_histogram.png'];
    saveas(gcf,t1_histogram)
    
    [values, edges] = histcounts(t1_data_nordic(t1_data_nordic~=0));
    centers = (edges(1:end-1)+edges(2:end))/2;
    figure; area(centers, values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('T1'); xlim([0 5000]); legend('Post NORDIC');
    t1_nordic_histogram = [mypath,'NORDIC\',t1_nordic_name(1:18),'_histogram.png'];
    saveas(gcf,t1_nordic_histogram)
    
    [values, edges] = histcounts(r2_data(r2_data~=0),20000);
    centers = (edges(1:end-1)+edges(2:end))/2;
    figure; area(centers, values, 'EdgeColor', [256, 0, 0]./256,'FaceColor', [256, 0, 0]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('R^2'); xlim([0.98 1.005]); legend('Pre NORDIC');
    r2_histogram = [mypath,r2_name(1:11),'_R2_histogram.png'];
    saveas(gcf,r2_histogram)
    
    [values, edges] = histcounts(r2_data_nordic(r2_data_nordic~=0),20000);
    centers = (edges(1:end-1)+edges(2:end))/2;
    hold on; area(centers, values, 'EdgeColor', [0, 0, 256]./256,'FaceColor', [0, 0, 256]./256, 'FaceAlpha', 0.4);
    ylabel('Count'); xlabel('R^2'); xlim([0.98 1.005]); legend('Pre NORDIC','Post NORDIC');
    r2_nordic_histogram = [mypath,'NORDIC\',r2_nordic_name(1:18),'_R2_histogram.png'];
    saveas(gcf,r2_nordic_histogram)
    
    
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
end

close(ppt);
rptview(ppt)