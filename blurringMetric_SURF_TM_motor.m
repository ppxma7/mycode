%blurring_metric_area
%
% Find the blurring metric across digits/subjects using the fsaverage area
% of triangles, rather than just numel(vertices)
% see Wang2014
%
% Coded by George O'Neill, observed by [ma]
%
% dec2018%
%
% can i retrofit this for touchmap subjects?
% ma november 2021

% ma MARCH 2022 - fixed for motor only

%blurringMetric_SURF_TM
clear variables
close all
shallisave=1;
doMPM = 1;
%mymagicnumber = 9; % subject 9 is 13447 who has no righ thand
%clc


%surface_type = {'white', 'pial', 'sphere', 'inflated'};
surface_type = {'pial'}';

cull5 =[];

for gg = 1:length(surface_type)
    
    %surface_type = 'white'; %choose either pial, sphere, inflated or white
    
    %fspath = '~/data/subjects/fsaverage/';
    fspath = '/Applications/freesurfer/subjects/fsaverage/';
    [verts, faces_rh] = read_surf([fspath 'surf/rh.' surface_type{gg}]);
    faces = faces_rh+1; %start from 1 not zero for counting
    
    % calculate area of every triangle using A = 0.5*|cross(AB,AC)|
    
    AB = verts(faces(:,2),:) - verts(faces(:,1),:);
    AC = verts(faces(:,3),:) - verts(faces(:,1),:);
    
    xABAC = cross(AB,AC);
    area_rh = 0.5*sqrt(sum(xABAC.*xABAC,2));
    
    [verts, faces_lh] = read_surf([fspath 'surf/lh.' surface_type{gg}]);
    faces = faces_lh+1;
    
    % calculate area of every triangle using A = 0.5*|cross(AB,AC)|
    
    AB = verts(faces(:,2),:) - verts(faces(:,1),:);
    AC = verts(faces(:,3),:) - verts(faces(:,1),:);
    
    xABAC = cross(AB,AC);
    area_lh = 0.5*sqrt(sum(xABAC.*xABAC,2));
    
    %cd '/Users/ppxma7/data/DigitAtlas/fsaveragePhBindDigits'
    % cd '/Volumes/research/7T_fMRI/DigitAtlas/ayanData/SBA_digit_ROIs/exploded/'
    %mypath = '/Volumes/data/Research/TOUCHMAP/digitAtlas_2019/digitmap/maps_mni/surf/';
    %mypath = '/Volumes/ares/nemosine/DigitAtlasv2/fsaverage_2mm/';
    
    mypath = '/Volumes/nemosine/fsaverage_motor/';
    cd(mypath)
    
    %     subjects = {'HB1', 'HB2', 'HB3', 'HB4', 'HB5', '11120', '10301', '00393', '03677', '08966','09621', ...
    %         '10289', '10320', '10329', '10654', '06447', '11251', '11753', '08740', '04217', '11240', '13676'};
    
    subjects = {'03942', '00393', '03677', '13287proj','13945', '13172',...
        '13382','13447proj','13493', '13654','13658', '13695', '14001'...
        '13695_pre', '13493_pre', '13382_pre', '13658_pre','14001_pre', '13654_pre'};

% 03677 is a problem here as motor was not in same session here.
%     
    %subjects = {'13382','13447proj','13493', '13654','13658', '13695', '14001'};
    
    subnumber = length(subjects);
    
    
    %% repeat for right digits
    for iSub = 1:length(subjects)
        
        %         myfolder = fullfile(mypath,subjects(iSub));
        %         cd(char(myfolder))
        % here we have five digits in one
        %theFile = MRIread([subjects{iSub} '_RD.mgh']);
        for iDigit = 1:5
                %theFile = MRIread(['RD' num2str(iDigit) '_' subjects{iSub} '.mgh']); %read in the nii.gz file
%                 RD = theFile.vol;
%                 RD_full(:,iDigit,iSub) = theFile.vol(:,iDigit);
%                 RD_full(:,iDigit,iSub) = RD_full(:,iDigit,iSub) > 0; 
%                 
                
                theFile = MRIread(['RD' num2str(iDigit) '_' subjects{iSub} '.mgh']); %read in the nii.gz file
                RD = theFile.vol;
                RD_full(:,iDigit,iSub) = RD > 0;
                
        end
    end
    %RD_full(:,:,mymagicnumber) = []; % remove 13447 magic number
    tmpSubs = size(RD_full,3);
    disp(tmpSubs)
    for iDigit = 1:5
        %pooledtest = size(nonzeros(sum(LD_full(:,iDigit),2)),1);
        
        %keyboard
        
        %bla = sum(LD_full(:,iDigit),2);
        bloop = RD_full(:,iDigit,:);
        bla = sum(bloop,3);
        
        % copy the wang et al paper, if fpm is less than 5% for that
        % vertex, cull for pooled area.
        if cull5
            bla(bla<2) = 0;
        end
        
        %blan = nonzeros(bla);
        idv = find(bla>0);
        %idv_fiveprc = (find(bla>0.05.*size(RD_full,2))); % try removing those that have less than 5% overlap!
        idt = find(sum(ismember(faces_lh+1,idv),2)==3); % very compact code! We are finding which triangles have all three vertices in the pool
        %idt_fiveprc = find(sum(ismember(faces_lh+1,idv_fiveprc),2)==3);
        pooledRD = sum(area_lh(idt));
        %pooledRD = sum(area_lh(idt_fiveprc));
        
        % for area
        %fudge(iDigit).lefthemi = area_lh(idt);
        
        for iSub = 1:tmpSubs % need to find mean across all subjects separately here, hence for loop
            tmp = RD_full(:,iDigit,iSub);
            idv = find(tmp==1);
            idt = find(sum(ismember(faces_lh+1,idv),2)==3);
            subRD(iSub) = sum(area_lh(idt));
        end
        ARD = mean(subRD); % this is the mean area of the digit across subs
        % do 100.* Apooled - mean(A) ./ mean(A)
        myblurR(iDigit) = 100 .*  (pooledRD - ARD) ./ ARD;
        
        lh_triangles_allsubs(iDigit).lefthemi = subRD;
        %fudge(iDigit).lefthemi_sd = std(subRD);
    end
    
    %     h(gg) = figure;
    %     h1 = plot([1:5], myblurL, 'r','linewidth',2);
    %     hold on
    %     h2 = plot([1:5], myblurR, 'k','linewidth',2);
    %     legd = legend('Left Digits', 'Right Digits');
    %     ylim([0 1600])
    %     title(surface_type{gg})
    %     xlabel('Digits')
    %     ylabel('Blurring metric %')
    %     axis square
    %% BLURRING METRIC
    h(gg) = figure;
%     h1 = plot([1:5], myblurL, '-o','color','r','markerfacecolor','r','linewidth',2);
%     hold on
    h1 = plot([1:5], myblurR, '-o','color','k','markerfacecolor','k','linewidth',2);
    legd = legend('Right Digits','location','nw');
    ylim([0 1200])
    xlim([0.1 5.9])
    title(['motor ' surface_type{gg}])
    xlabel('Digits')
    ylabel('Blurring metric %')
    axis square
    set(gcf,'color','w')
    grid ON
    
    if shallisave
        filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
            ['MOTORBlurringMetric_surface_' num2str(gg)]);
        print(filename,'-dpdf')
    end
    %% LOOK AT ROI SIZES / VOLUMES
    
    if doMPM == 1
        %% try loading in MPMs for bar chart
        %mpmpath = '/Volumes/data/Research/TOUCHMAP/digitAtlas_2019/digitmap/maps_mni/surf/MPM/';
        mpmath = '/Volumes/nemosine/';
        thempm = load([mpmath 'digatlas_touchmap_subs_motor.mat'],'mpm_R_TM'); % needed to remake this from compare2atlas_motor.m
%         LDmpm = MRIread([mpmpath, 'LD_all.mgz']);
%         RDmpm = MRIread([mpmpath, 'RD_all.mgz']);
        %LDmpm = thempm.mLD(:);
        RDmpm = thempm.mpm_R_TM;
        
        for ii = 1:5
            idv_mpmR = find(RDmpm==ii);
            idt_mpmR = find(sum(ismember(faces_lh+1,idv_mpmR),2)==3);
            pooledRD_mpm(ii) = sum(area_lh(idt_mpmR));
        end
        
        
        
        % issue here is MPM is all logicals
        
        % separate by digit
%         RDmpm_D1 = RDmpm(:,1,:);
%         RDmpm_D2 = RDmpm(:,2,:);
%         RDmpm_D3 = RDmpm(:,3,:);
%         RDmpm_D4 = RDmpm(:,4,:);
%         RDmpm_D5 = RDmpm(:,5,:);
%         
%         % look at this explicitly
%         idv_mpmR_D1 = find(RDmpm_D1==1);
%         idt_mpmR_D1 = find(sum(ismember(faces_lh+1,idv_mpmR_D1),2)==3);
%         pooledRD_mpm(1) = sum(area_lh(idt_mpmR_D1));
%         
%         idv_mpmR_D2 = find(RDmpm_D2==1);
%         idt_mpmR_D2 = find(sum(ismember(faces_lh+1,idv_mpmR_D2),2)==3);
%         pooledRD_mpm(2) = sum(area_lh(idt_mpmR_D2));
%         
%         idv_mpmR_D3 = find(RDmpm_D3==1);
%         idt_mpmR_D3 = find(sum(ismember(faces_lh+1,idv_mpmR_D3),2)==3);
%         pooledRD_mpm(3) = sum(area_lh(idt_mpmR_D3));
%         
%         idv_mpmR_D4 = find(RDmpm_D4==1);
%         idt_mpmR_D4 = find(sum(ismember(faces_lh+1,idv_mpmR_D4),2)==3);
%         pooledRD_mpm(4) = sum(area_lh(idt_mpmR_D4));
%         
%         idv_mpmR_D5 = find(RDmpm_D5==1);
%         idt_mpmR_D5 = find(sum(ismember(faces_lh+1,idv_mpmR_D5),2)==3);
%         pooledRD_mpm(5) = sum(area_lh(idt_mpmR_D5));
%         
%         LDmpm = LDmpm.vol(:);
%         RDmpm = RDmpm.vol(:);
%         for impm = 1:5
%             %idv_mpm = find(LDmpm==impm);
%             idv_mpmR = find(RDmpm==impm);
%             %idt_mpm = find(sum(ismember(faces_rh+1,idv_mpm),2)==3);
%             idt_mpmR = find(sum(ismember(faces_lh+1,idv_mpmR),2)==3);
%             %pooledLD_mpm(impm) = sum(area_rh(idt_mpm));
%             pooledRD_mpm(impm) = sum(area_lh(idt_mpmR));
%         end
        
        % plot volumes of ROIs
        % stacking here for GRAMM

        rd1 = repmat({'D1'},length(getfield(lh_triangles_allsubs(1),'lefthemi')),1);
        rd2 = repmat({'D2'},length(getfield(lh_triangles_allsubs(2),'lefthemi')),1);
        rd3 = repmat({'D3'},length(getfield(lh_triangles_allsubs(3),'lefthemi')),1);
        rd4 = repmat({'D4'},length(getfield(lh_triangles_allsubs(4),'lefthemi')),1);
        rd5 = repmat({'D5'},length(getfield(lh_triangles_allsubs(5),'lefthemi')),1);
        myrd = [rd1; rd2; rd3;rd4;rd5];
        
        % comma instead of semi colon otherwise the getfield messes everything
        % up
        lh_triangles_allsubs_stacked = [getfield(lh_triangles_allsubs(1),'lefthemi'),getfield(lh_triangles_allsubs(2),'lefthemi'),...
            getfield(lh_triangles_allsubs(3),'lefthemi'), getfield(lh_triangles_allsubs(4),'lefthemi'),getfield(lh_triangles_allsubs(5),'lefthemi')];
        
        lh_triangles_allsubs_stacked = lh_triangles_allsubs_stacked(:);
        
        
  
        pooledRD_mpm_stacked = [repmat(pooledRD_mpm(1),subnumber,1); repmat(pooledRD_mpm(2),subnumber,1); repmat(pooledRD_mpm(3),subnumber,1); ...
            repmat(pooledRD_mpm(4),subnumber,1); repmat(pooledRD_mpm(5),subnumber,1)];
        
        roimpmIDX = [repmat({'Subject ROIs'},subnumber.*5,1);  repmat({'MPMs'},subnumber.*5,1)];
        
        
        mycmapX = [5 113 176; 146 197 222];
        mycmapX = mycmapX ./ 256;
        
        % double up here [bla;bla], to make roimpmIDX happy
        mysize = 16;
        figure('Position', [100 100 600 400])
        g(1,1) = gramm('x', [myrd;myrd],'y', [lh_triangles_allsubs_stacked;pooledRD_mpm_stacked], 'color', roimpmIDX); % *8 since we are 2x2x2 voxels
        g(1,1).stat_summary('type','sem','geom', {'bar', 'black_errorbar'});
        %g(1,1).geom_bar('stacked', 'false')
        g(1,1).set_names('x', 'Digit', 'y', 'Surface Area (mm^2) + SE');
        g(1,1).set_text_options('font', 'Helvetica', 'base_size', mysize)
        g(1,1).set_order_options('color',0)
        %g(1,1).axe_property('YLim',[0 800], 'PlotBoxAspectRatio',[1 1 1])
        %g(1,1).no_legend()
        
        g.draw()
        
        g.export('file_name','MPM_TM_motor', ...
            'export_path',...
            '/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/',...
            'file_type','pdf')
        
    end
    
    
end





