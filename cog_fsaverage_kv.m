clear variables
close all
clc
tic
%thisSub = 'prf1';

% subjects = {'00393_LD_touchmap','00393_RD_touchmap',...
%     '03677_LD', '03677_RD', '03942_LD', '03942_RD', '13172_LD', '13172_RD', ...
%     '13493_Btx_LD', '13493_Btx_RD', '13493_NoBtx_LD', '13493_NoBtx_RD', ...
%     '13658_Btx_LD', '13658_Btx_RD', '13658_NoBtx_LD', '13658_NoBtx_RD', ...
%     '13695_Btx_LD', '13695_Btx_RD', '13695_NoBtx_LD', '13695_NoBtx_RD', ...
%     '14001_Btx_LD', '14001_Btx_RD', '14001_NoBtx_LD', '14001_NoBtx_RD',...
%     '04217_LD', '08740_RD','08966_RD', ...
%     '10875_RD', '11120_LD', '11120_RD',...
%     'HB2_LD', 'HB2_RD', 'HB3_LD', 'HB3_RD', 'HB4_LD', 'HB4_RD', 'HB5_LD', 'HB5_RD',...
%     'sub016_005','sub016_006','sub016_008','sub016_009','sub016_011','sub016_012','sub016_013','sub016_014',...
%     'sub016_015','sub016_017','sub016_018','sub016_020','sub016_021','sub016_022','sub016_023','sub016_024',...
%     'sub016_025','sub016_026','sub016_027','sub016_028','sub016_029','sub016_030','sub016_031','sub016_032',...
%     'sub016_033','sub016_034','sub016_035','sub016_036','sub016_037','sub016_038','sub016_039','sub016_040',...
%     'sub016_041','sub016_042','sub016_043','sub016_045','sub016_046','sub016_047','sub016_049','sub016_050',...
%     'sub016_051','sub016_052','sub016_054','sub016_055','sub016_056','sub016_057','sub016_059','sub016_060',...
%     'sub016_061','sub016_063','sub016_064'};


subjects = {'00393_RD_extra', '03677_RD_extra',...
    '04217_RD_extra', '06447_BH_RD_extra',...
    '08740_RD_extra', '08966_RD_extra',...
    '09621_RD_extra', '10289_RD_extra','10301_RD_extra',...
    '10320_RD_extra', '10329_RD_extra',...
    '10654_RD_extra', '10875_RD_extra','11120_RD_extra',...
    '11240_RD_extra', '11251_RD_extra',...
    '11753_RD_extra', 'HB1_BH_RD_extra','HB2_BH_RD_extra',...
    'HB3_RD_extra',  'HB4_BH_RD_extra','HB5_BH_RD_extra',...
    '13493_Btx_RD', '13493_NoBtx_RD', ...
    '13658_Btx_RD', '13658_NoBtx_RD', ...
    '13695_Btx_RD', '13695_NoBtx_RD', ...
    '14001_Btx_RD', '14001_NoBtx_RD',...
    };


%subjects = {'09621_RD_extra'};


% These people need to rerun Freesurfer I think...
% 09621 not good surf reg
% 10301 also bad LD and RD
% 11240 LD bad
% 11251 bad LD and RD

%subjects = {'10301_RD'};

userName = char(java.lang.System.getProperty('user.name'));

savedirUp = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Touch Remap - General/background_plot/'];


% Define parameters for the sphere marker
sphere_radius = 2;  % Adjust radius as needed for visibility
[sphere_x, sphere_y, sphere_z] = sphere(20);  % Sphere resolution (20x20 grid)

myspherecolors = {'r','g','c','b','m'};

nDigs = 5;

cog_list = zeros(nDigs, 3,length(subjects));  % Array to store each CoG's coordinates

for thisSub = 1:length(subjects)
    tstart = tic;

    disp(['Running ' subjects{thisSub} ' now...'])

    if contains(subjects{thisSub},'Btx')
        %mypath = ['/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016/231108_share/' subjects{thisSub} '/resultsSummary/atlas/'];
        %mypath = ['/Volumes/DRS-Touchmap/ma_ares_backup/prf_fsaverage/' subjects{thisSub} '/'];
        mypath = ['/Volumes/styx/prf_fsaverage/' subjects{thisSub} '/'];
    else
        %mypath = ['/Volumes/styx/prf_fsaverage/' subjects{thisSub} '/'];
        mypath = ['/Volumes/r15/DRS-7TfMRI/DigitAtlas/TWmaps_masks/' subjects{thisSub} '/'];
    end
    %mypath = ['/Volumes/DRS-Touchmap/ma_ares_backup/prf_fsaverage/' subjects{thisSub} '/'];

    savedir = [savedirUp subjects{thisSub} '/'];

    if ~isfolder(savedir)
        mkdir(savedir)
    end

    % Define paths

    %     if ~contains(subjects{thisSub},'sub016')
    %         if thisSub<13
    %             subjects_dir = '/Volumes/r15/DRS-Touchmap/ma_ares_backup/subs/';  % Update to actual path
    %         elseif thisSub>12 && thisSub<21
    %             subjects_dir = '/Volumes/r15/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/';
    %         end
    %         %elseif thisSub > 20
    %     else
    %         subjects_dir = '/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/TOUCH_REMAP/exp016/freesurfer';
    %     end
    if contains(subjects{thisSub},'Btx')
        subjects_dir = '/Volumes/DRS-Touchmap/ma_ares_backup/subs/';
    else
        subjects_dir = '/Volumes/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/';

    end
    disp(subjects_dir)

    %subjects_dir = '/Volumes/DRS-7TfMRI/DigitAtlas/FreeSurferDigitAtlas/';

    subject = 'fsaverage';

    if contains(subjects(thisSub), '_LD')
        hemisphere = 'r';  % Change to 'r' for right hemisphere
    elseif contains(subjects(thisSub),'_RD')
        hemisphere = 'l';
    else
        hemisphere = 'l';
    end

    % Load the inflated surface vertices for visualization
    [vertices, faces] = read_surf(fullfile(subjects_dir, ...
        subject, 'surf', strcat(hemisphere, 'h.inflated')));


    % Define thresholded phase-binned images and a list for CoG storage


    %     if ~contains(subjects{thisSub},'sub016')
    %         threshold_files = {
    %             [mypath 'co_masked_0_1_256_co_thresh_fsaverage.mgh'], ...
    %             [mypath 'co_masked_1_256_2_512_co_thresh_fsaverage.mgh'], ...
    %             [mypath 'co_masked_2_512_3_768_co_thresh_fsaverage.mgh'], ...
    %             [mypath 'co_masked_3_768_5_024_co_thresh_fsaverage.mgh'],...
    %             [mypath 'co_masked_5_024_6_28_co_thresh_fsaverage.mgh'],...
    %             };
    %     else

    if contains(subjects{thisSub},'Btx')
        threshold_files = {
            [mypath 'co_masked_0_1_256_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_1_256_2_512_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_2_512_3_768_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_3_768_5_024_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_5_024_6_28_co_thresh_fsaverage.mgh'],...
            };
    else

        threshold_files = {
            [mypath 'co_masked_bin1_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_bin2_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_bin3_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_bin4_co_thresh_fsaverage.mgh'],...
            [mypath 'co_masked_bin5_co_thresh_fsaverage.mgh'],...
            };

    end





    % Plot the surface using go_paint_freesurfer function without any intensity data
    % figure;
    % [h, cm] = go_paint_freesurfer(zeros(size(vertices, 1), 1), subject, hemisphere, ...
    %     'subjects_dir', subjects_dir, 'surface', ...
    %     'inflated', 'colormap', 'jet', 'range', [0.1 1], 'alpha', 1);
    % hold on;

    % Loop through each thresholded image and calculate the adjusted CoG
    for ii = 1:length(threshold_files)
        % Load intensity data for the current thresholded ROI
        intensity_data = load_mgh(threshold_files{ii});

        % Define the ROI using a minimum intensity threshold

        % catch bad ones
        if sum(intensity_data) == 0
            disp(['all zeros in bin ' num2str(ii) ' subject ' subjects{thisSub} ' mgh file, skipping...'])
            %disp(['subject ' subjects{thisSub} ' completed in ' num2str(telapsed) ' seconds'])
            cog_list(ii, :, thisSub) = [0 0 0];

        else

            if sum(intensity_data)<0.3
                threshold = 0.001;
            else
                threshold = 0.3;  % Adjust as needed
            end
            roi_mask = intensity_data >= threshold;

            % Apply the mask to exclude non-ROI vertices
            roi_intensity_data = intensity_data .* roi_mask;

            if length(find(roi_intensity_data))<10
                roi_intensity_data = intensity_data;
            end

            % Calculate the initial CoG based on intensity values
            weighted_coords = bsxfun(@times, vertices, roi_intensity_data);
            sum_weights = sum(roi_intensity_data);
            initial_cog = sum(weighted_coords, 1) / sum_weights;

            % Find the nearest vertex in the ROI to ensure CoG is within ROI bounds
            roi_vertices = vertices(roi_mask, :);
            nearest_idx = knnsearch(roi_vertices, initial_cog);
            adjusted_cog = roi_vertices(nearest_idx, :);

            % Store the adjusted CoG coordinates
            if isempty(adjusted_cog)
                cog_list(ii, :, thisSub) = [0 0 0];
                disp(['bin ' num2str(ii) ' subject ' subjects{thisSub} 'intensity was not zero, but cog is, skipping... bin '])

            else
                cog_list(ii, :, thisSub) = adjusted_cog;



                % Plot the thresholded image on the surface using go_paint_freesurfer
                figure;
                go_paint_freesurfer(roi_intensity_data, subject, hemisphere, ...
                    'subjects_dir', subjects_dir, 'surface',...
                    'inflated', 'colormap',...
                    'jet', 'range', [0.001 max(intensity_data)], 'alpha', 1);

                hold on;

                % Plot the adjusted CoG as a green sphere on the surface
                surf(sphere_radius * sphere_x + adjusted_cog(1), ...
                    sphere_radius * sphere_y + adjusted_cog(2), ...
                    sphere_radius * sphere_z + adjusted_cog(3), ...
                    'FaceColor', myspherecolors{ii}, 'EdgeColor', 'none', 'FaceAlpha', 0.8);  % Green sphere for each CoG


                if length(intensity_data) ~= size(vertices, 1)
                    error('Mismatch between data points and surface vertices.');
                end
                title(sprintf('Center of Gravity for Phase Bin %d on Inflated Brain Surface', ii));
                hold off;

                % Save the figure as a PDF using exportgraphics
                pdf_filename = fullfile(savedir, sprintf('CoG_Phase_Bin_%d.pdf', ii));
                exportgraphics(gcf, pdf_filename, 'ContentType', 'image', 'Resolution', 300);
            end

        end



    end

    close all

    telapsed = toc(tstart);
    disp(['subject ' subjects{thisSub} ' completed in ' num2str(telapsed) ' seconds'])



end

toc

% Finalize plot
% title('Centers of Gravity for Thresholded ROIs on Inflated Brain Surface');
% hold off;
%%
zero_slices = [];
% Loop through the 3rd dimension
for k = 1:size(cog_list, 3)
    if any(cog_list(:,:,k) == 0, 'all')
        zero_slices = [zero_slices, k]; % Append index of slice with zeros
    end
end

% Logical indexing approach
keep_mask = true(1, size(cog_list, 3)); % Initialize mask to keep all slices
keep_mask(zero_slices) = false; % Set slices to remove as false

% Rebuild the matrix by keeping only the slices with true in the mask
shortened_cog_list = cog_list(:,:,keep_mask);

shortened_subjects = subjects(keep_mask);

%% Display calculated CoGs
%disp('Adjusted CoGs for each thresholded image:');
%disp(cog_list);

% Calculate the total Euclidean distance between each consecutive CoG
%total_distance = 0;
clc
totalDistCogs = zeros(size(shortened_cog_list,3),1);
%totalDistCogsNames = cell(size(cog_list,3),1);

for loopSub = 1:size(shortened_cog_list,3)

    total_distance = 0;
    thisCog = shortened_cog_list(:,:,loopSub);

    for jj = 1:size(thisCog, 1) - 1
        % Calculate Euclidean distance between consecutive CoGs
        dist = norm(thisCog(jj+1, :) - thisCog(jj, :));
        total_distance = total_distance + dist;
    end

    totalDistCogs(loopSub) = total_distance; % save each subject's D1-D5 distance here
    %totalDistCogsNames{loopSub} = subjects{loopSub};

    % Display the total distance
    fprintf('Subject: %s \n', shortened_subjects{loopSub});
    fprintf('Total Euclidean distance between CoGs: %.2f mm\n', total_distance);


end

%% Get 5x5 matrix of distances

% Initialize a 5x5x70 matrix to store distances for all subjects
% Output explanation
% distMatrix(:,:,n) contains the 5x5 distance matrix for subject n
% distMatrix(ii,jj,n) is the distance between digit ii and digit jj for subject n
distMatrix = zeros(5, 5, size(shortened_cog_list, 3));
for loopSub = 1:size(shortened_cog_list,3)
    thisCog = shortened_cog_list(:,:,loopSub);
    for ii = 1:5
        for jj = 1:5
            distMatrix(ii,jj,loopSub) = norm(thisCog(ii,:) - thisCog(jj,:));
        end
    end
end

%% plot matrices
close all

% subsAtlas = [1 3 4 13 14 15 17 18 19 20];
% subsKV = 21:70;
% subsPat = [5 6 7 8 9 10 11 12];
%
% subsAtlasDists = distMatrix(:,:,subsAtlas);
% subsKVDists = distMatrix(:,:,subsKV);
% subsPatDists = distMatrix(:,:,subsPat);
badSub = 7;
cutSubs = true(1, size(distMatrix, 3)); % Initialize mask to keep all slices
cutSubs(badSub) = false; % Set slices to remove as false

% Rebuild the matrix by keeping only the slices with true in the mask
distMatrix_cutSubs = distMatrix(:,:,cutSubs);

shortened_subjects_cutSubs = shortened_subjects(cutSubs);

mapCol = 'plasma';
figure('Position', [100 100 1400 600])
%figure
tiledlayout(3,8)
for ii = 1:length(distMatrix_cutSubs)
    nexttile
    imagesc(distMatrix_cutSubs(:,:,ii))
    % Replace underscores with spaces
    % Remove the last 5 characters and replace underscores
    trimmed_name = shortened_subjects_cutSubs{ii}(1:end-5); % Remove last 5 characters
    cleaned_name = strrep(trimmed_name, '_', ' '); % Replace underscore
    title(cleaned_name)
    colormap(mapCol)
    colorbar
    xticks(1:5)
    yticks(1:5)
    xticklabels({'RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    c = colorbar;
    c.Label.String = 'Digit Distance (mm)';
    ax = gca;
    ax.FontSize = 10;
    set(gcf,'color', 'w');
    axis square
    clim([0 22])
end
filename = fullfile(savedirUp, 'Dists');
print(filename,'-dpng')
%%
meanDistMat = mean(distMatrix_cutSubs(:,:,1:13),3);
meanDistPat = mean(distMatrix_cutSubs(:,:,14:end),3);

bloop = cat(3,meanDistMat,meanDistPat);
groups = {'Atlas','BTX Patients'};

mapCol = 'plasma';
figure('Position', [100 100 800 400])
tiledlayout(1,2)
for ii = 1:2
    nexttile
    imagesc(bloop(:,:,ii))
    % Replace underscores with spaces
    % Remove the last 5 characters and replace underscores

    title([groups(ii) ' mean'])
    colormap(mapCol)
    colorbar
    xticks(1:5)
    yticks(1:5)
    xticklabels({'RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    c = colorbar;
    c.Label.String = 'Digit Distance (mm)';
    ax = gca;
    ax.FontSize = 12;
    set(gcf,'color', 'w');
    axis square
    clim([0 22])
end
filename = fullfile(savedirUp, 'Dists_mean');
print(filename,'-dpng')




%%
csv_filename = [savedirUp 'full_cog.csv'];  % Update with your desired path

% Get the size of the array
[numRows, numCols, numSubjects] = size(cog_list);

% Preallocate a cell array for reshaping the data (for text and numeric data)
csvData = cell(numRows * numSubjects, numCols + 1);

% Populate the 2D cell array for CSV output
for ix = 1:numSubjects
    startIdx = (ix - 1) * numRows + 1;
    endIdx = ix * numRows;
    csvData(startIdx:endIdx, 1:numCols) = num2cell(cog_list(:, :, ix));  % Copy data as cells
    csvData(startIdx:endIdx, numCols + 1) = subjects(ix);  % Add subject name
end

% Convert to table and add column names
csvTable = cell2table(csvData, 'VariableNames', {'X', 'Y', 'Z', 'Subject'});

% Save as CSV
writetable(csvTable, csv_filename);

% also save out distances
csv_filename2 = [savedirUp 'total_cog.csv'];  % Update with your desired path
distanceTable = table(subjects', totalDistCogs, 'VariableNames', {'Subject', 'Distance'});
writetable(distanceTable, csv_filename2);

%% once this is all done, need to plot
% plot LD and RD separately
% and plot healthies (incl. atlas subs) vs touchmap BTX vs. touchmap NoBTX
% Just plot total distance, so one number for each subject.
close all
subGrp = subjects(:);

handGrp = cell(size(subGrp));
LDx = contains(subGrp, '_LD');
handGrp(LDx) = {'LD'};
RDx = contains(subGrp, '_RD');
handGrp(RDx) = {'RD'};

patGrp = cell(size(subGrp));
BTx = contains(subGrp,'_Btx_');
patGrp(BTx) = {'BTX'};
NBTx = contains(subGrp,'_NoBtx_');
patGrp(NBTx) = {'NoBTX'};
HVx = ~(BTx+NBTx);
patGrp(HVx) = {'HV'};

% testing
% a = 10;
% b = 30;
% totalDistCogs = (b-a).*rand(length(subGrp),1) + a;

[p, tbl, stats] = anovan(totalDistCogs, {patGrp, handGrp}, 'model', 'interaction', 'varnames', {'PATIENT', 'HAND'});
writecell(tbl,[savedirUp 'anova_cog'],'FileType','spreadsheet')

% Display the results
disp('ANOVA Table:');
disp(tbl);
[COMPARISON,~,~,GNAMES] = multcompare(stats,'Dimension',1);
tbldom = array2table(COMPARISON,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedirUp 'mult_anova_dim1_cog'],'FileType','spreadsheet')

[COMPARISON,~,~,GNAMES] = multcompare(stats,'Dimension',2);
tbldom = array2table(COMPARISON,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedirUp 'mult_anova_dim2_cog'],'FileType','spreadsheet')

%% yes but in each hand, is there a difference?
totalDistCogs_LDonly = totalDistCogs(LDx);
totalDistCogs_RDonly = totalDistCogs(RDx);

patGrp_LDonly = patGrp(LDx);
patGrp_RDonly = patGrp(RDx);

[P, ANOVATAB, STATS_L] = anova1(totalDistCogs_LDonly,patGrp_LDonly);

[COMPARISON_L,MEANS,H,GNAMES] = multcompare(STATS_L);
tbldom = array2table(COMPARISON_L,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedirUp 'mult_anova_LDonly_cog'],'FileType','spreadsheet')


[P, ANOVATAB, STATS_R] = anova1(totalDistCogs_RDonly,patGrp_RDonly);

[COMPARISON_R,MEANS,H,GNAMES] = multcompare(STATS_R);
tbldom = array2table(COMPARISON_R,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedirUp 'mult_anova_RDonly_cog'],'FileType','spreadsheet')




%% now plot
close all
clear g
thisFont='Helvetica';
myfontsize=14;
figure('Position',[100 100 700 600])
%figure
g = gramm('x',patGrp,'y',totalDistCogs,'color',handGrp);
g.stat_boxplot2('alpha', 1,'linewidth', 1, 'drawoutlier',0)
%g.stat_boxplot()
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Group', 'y', 'Total distance D1-D5')
g.set_order_options('x',0,'color',0)
g.axe_property('XGrid','on','YGrid','on')
g.draw()
g.update('y',totalDistCogs) %,'color',subGrp)
g.geom_jitter2('dodge',0.8,'alpha',1,'edgecolor',[0 0 0])
%g.geom_jitter('dodge',0.8,'alpha',1)
g.set_point_options('base_size',5)
g.no_legend
g.set_order_options('x',0,'color',0)
g.draw()
filename = 'cog_plot';
g.export('file_name',filename, ...
    'export_path',...
    savedirUp,...
    'file_type','pdf')




