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

% Can't do this for one subject

%blurringMetric_SURF_TM
clear variables
close all
close all hidden

shallisave=1;
doMPM = 1;
%mymagicnumber = 9; % subject 9 is 13447 who has no righ thand
%clc


%surface_type = {'white', 'pial', 'sphere', 'inflated'};
surface_type = {'pial'}';

cull5 =[];
%
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
    mypath = '/Volumes/ares/PFS/7T/digitatlas/';
    
    cd(mypath)
    
    %     subjects = {'HB1', 'HB2', 'HB3', 'HB4', 'HB5', '11120', '10301', '00393', '03677', '08966','09621', ...
    %         '10289', '10320', '10329', '10654', '06447', '11251', '11753', '08740', '04217', '11240', '13676'};
    
    subjects = {'PFS'};
    
    %subjects = {'13695_pre', '13493_pre', '13382_pre', '13658_pre','14001_pre', '13654_pre'};
    
    subnumber = length(subjects);
    tic
    %
    for iSub = 1:length(subjects)
        
        %         myfolder = fullfile(mypath,subjects(iSub));
        %         cd(char(myfolder))
        
        
        for iDigit = 1:5
            %theFile = MRIread(['LD' sprintf('%d',iDigit) '_manual_binarised' '.mgz']); %read in the nii.gz file
            %theFile = MRIread(['LD' num2str(iDigit) '_' subjects{iSub} '.mgh']);
            theFile = MRIread([mypath subjects{iSub} '/LD' num2str(iDigit) '_' 'fsaverage.mgh']);

            LD = theFile.vol;
            LD_full(:,iDigit,iSub) = LD > 0;
            %             lidx = find(LD_full(:,iDigit,iSub));
            %LD_bin = LD_full;
            %             LD_full(lidx,iDigit,iSub) = 1;
            
        end
    end
    
    
    for iDigit = 1:5
        %pooledtest = size(nonzeros(sum(LD_full(:,iDigit),2)),1);
        
        %keyboard
        
        %bla = sum(LD_full(:,iDigit),2);
        bloop = LD_full(:,iDigit,:);
        bla = sum(bloop,3);
        
        % copy the wang et al paper, if fpm is less than 5% for that
        % vertex, cull for pooled area.
        if cull5
            bla(bla<2) = 0;
        end
        %blan = nonzeros(bla);
        idv = find(bla>0);
        %idv_fiveprc = (find(bla>0.05.*size(LD_full,2))); % try removing those that have less than 5% overlap!
        idt = find(sum(ismember(faces_rh+1,idv),2)==3); % very compact code! We are finding which triangles have all three vertices in the pool
        %idt_fiveprc = find(sum(ismember(faces_rh+1,idv_fiveprc),2)==3);
        pooledLD = sum(area_rh(idt));
        %pooledLD = sum(area_rh(idt_fiveprc));
        
        % for area
        %fudge(iDigit).righthemi = area_rh(idt);
        
        for iSub = 1:length(subjects) % need to find mean across all subjects separately here, hence for loop
            tmp = LD_full(:,iDigit,iSub);
            %tmp = squeeze(tmp);
            idv = find(tmp==1);
            idt = find(sum(ismember(faces_rh+1,idv),2)==3);
            subLD(iSub) = sum(area_rh(idt));
        end
        ALD = mean(subLD); % this is the mean area of the digit across subs
        % do 100.* Apooled - mean(A) ./ mean(A)
        myblurL(iDigit) = 100 .*  (pooledLD - ALD) ./ ALD;
        
        fudge(iDigit).righthemi = subLD;
        %fudge(iDigit).righthemi_sd = std(subLD);
    end
    
    
    
    %% repeat for right digits
%     for iSub = 1:length(subjects)
%         
%         %         myfolder = fullfile(mypath,subjects(iSub));
%         %         cd(char(myfolder))
%         
%         
%         for iDigit = 1:5
%             
%             
%             %theFile = MRIread(['LD' sprintf('%d',iDigit) '_fnirt' '.nii.gz']); %read in the nii.gz file
%             if strcmpi(subjects{iSub},'13447')
%                 %keyboard
%                 RD_full(:,iDigit,iSub) = 0;
%             else
%                 
%                 theFile = MRIread(['RD' num2str(iDigit) '_' subjects{iSub} '.mgh']); %read in the nii.gz file
%                 RD = theFile.vol;
%                 RD_full(:,iDigit,iSub) = RD > 0;
%             end
%             %             lidx = find(RD_full(:,iDigit,iSub));
%             %LD_bin = LD_full;
%             %             RD_full(lidx,iDigit,iSub) = 1;
%             
%         end
%     end
%     %RD_full(:,:,mymagicnumber) = []; % remove 13447 magic number
%     tmpSubs = size(RD_full,3);
%     disp(tmpSubs)
%     for iDigit = 1:5
%         %pooledtest = size(nonzeros(sum(LD_full(:,iDigit),2)),1);
%         
%         %keyboard
%         
%         %bla = sum(LD_full(:,iDigit),2);
%         bloop = RD_full(:,iDigit,:);
%         bla = sum(bloop,3);
%         
%         % copy the wang et al paper, if fpm is less than 5% for that
%         % vertex, cull for pooled area.
%         if cull5
%             bla(bla<2) = 0;
%         end
%         
%         %blan = nonzeros(bla);
%         idv = find(bla>0);
%         %idv_fiveprc = (find(bla>0.05.*size(RD_full,2))); % try removing those that have less than 5% overlap!
%         idt = find(sum(ismember(faces_lh+1,idv),2)==3); % very compact code! We are finding which triangles have all three vertices in the pool
%         %idt_fiveprc = find(sum(ismember(faces_lh+1,idv_fiveprc),2)==3);
%         pooledRD = sum(area_lh(idt));
%         %pooledRD = sum(area_lh(idt_fiveprc));
%         
%         % for area
%         %fudge(iDigit).lefthemi = area_lh(idt);
%         
%         for iSub = 1:tmpSubs % need to find mean across all subjects separately here, hence for loop
%             tmp = RD_full(:,iDigit,iSub);
%             idv = find(tmp==1);
%             idt = find(sum(ismember(faces_lh+1,idv),2)==3);
%             subRD(iSub) = sum(area_lh(idt));
%         end
%         ARD = mean(subRD); % this is the mean area of the digit across subs
%         % do 100.* Apooled - mean(A) ./ mean(A)
%         myblurR(iDigit) = 100 .*  (pooledRD - ARD) ./ ARD;
%         
%         fudge(iDigit).lefthemi = subRD;
%         %fudge(iDigit).lefthemi_sd = std(subRD);
%     end
    
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


    %%
    h(gg) = figure;
    h1 = plot([1:5], myblurL, '-o','color','r','markerfacecolor','r','linewidth',2);
%     hold on
%     h2 = plot([1:5], myblurR, '-o','color','k','markerfacecolor','k','linewidth',2);
    legd = legend('Left Digits','location','ne');
    ylim([0 1200])
    xlim([0.1 5.9])
    title(surface_type{gg})
    xlabel('Digits')
    ylabel('Blurring metric %')
    axis square
    set(gcf,'color','w')
    grid ON
    
    if shallisave
%         filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
%             ['BlurringMetric_surface_' num2str(gg)]);

        filename = fullfile('/Users/ppzma/The University of Nottingham/Pain Relief Grant - General/PFP_results/pRF_redo_june23/', ...
            ['BlurringMetric_surface_' num2str(gg)]);


        print(filename,'-dpdf')
    end
    %%
    
    if doMPM == 1
        %% try loading in MPMs for bar chart
        %mpmpath = '/Volumes/data/Research/TOUCHMAP/digitAtlas_2019/digitmap/maps_mni/surf/MPM/';
        mpmath = '/Volumes/nemosine/';
        thempm = load([mpmath 'digatlas_touchmap_subs.mat'], 'mpm_L_TM','mpm_R_TM');
%         LDmpm = MRIread([mpmpath, 'LD_all.mgz']);
%         RDmpm = MRIread([mpmpath, 'RD_all.mgz']);
        LDmpm = thempm.mpm_L_TM;
        RDmpm = thempm.mpm_R_TM;
%         LDmpm = LDmpm.vol(:);
%         RDmpm = RDmpm.vol(:);
        for ii = 1:5
            idv_mpm = find(LDmpm==ii);
            idv_mpmR = find(RDmpm==ii);
            idt_mpm = find(sum(ismember(faces_rh+1,idv_mpm),2)==3);
            idt_mpmR = find(sum(ismember(faces_lh+1,idv_mpmR),2)==3);
            pooledLD_mpm(ii) = sum(area_rh(idt_mpm));
            pooledRD_mpm(ii) = sum(area_lh(idt_mpmR));
        end
        
       
        
        
        % plot volumes of ROIs
        
        ld1 = repmat({'D1'},length(getfield(fudge(1),'righthemi')),1);
        ld2 = repmat({'D2'},length(getfield(fudge(2),'righthemi')),1);
        ld3 = repmat({'D3'},length(getfield(fudge(3),'righthemi')),1);
        ld4 = repmat({'D4'},length(getfield(fudge(4),'righthemi')),1);
        ld5 = repmat({'D5'},length(getfield(fudge(5),'righthemi')),1);
        rd1 = repmat({'D1'},length(getfield(fudge(1),'lefthemi')),1);
        rd2 = repmat({'D2'},length(getfield(fudge(2),'lefthemi')),1);
        rd3 = repmat({'D3'},length(getfield(fudge(3),'lefthemi')),1);
        rd4 = repmat({'D4'},length(getfield(fudge(4),'lefthemi')),1);
        rd5 = repmat({'D5'},length(getfield(fudge(5),'lefthemi')),1);
        myld = [ld1; ld2; ld3;ld4;ld5];
        myrd = [rd1; rd2; rd3;rd4;rd5];
        
        % comma instead of semi colon otherwise the getfield messes everything
        % up
        fudgetaculaR = [getfield(fudge(1),'lefthemi'),getfield(fudge(2),'lefthemi'),...
            getfield(fudge(3),'lefthemi'), getfield(fudge(4),'lefthemi'),getfield(fudge(5),'lefthemi')];
        fudgetaculaL = [getfield(fudge(1),'righthemi'),getfield(fudge(2),'righthemi'),...
            getfield(fudge(3),'righthemi'),getfield(fudge(4),'righthemi'),getfield(fudge(5),'righthemi')];
        
        fudgetaculaR = fudgetaculaR(:);
        fudgetaculaL = fudgetaculaL(:);
        
        
        blick = [repmat(pooledLD_mpm(1),subnumber,1); repmat(pooledLD_mpm(2),subnumber,1); repmat(pooledLD_mpm(3),subnumber,1); ...
            repmat(pooledLD_mpm(4),subnumber,1); repmat(pooledLD_mpm(5),subnumber,1)];
        brick = [repmat(pooledRD_mpm(1),subnumber,1); repmat(pooledRD_mpm(2),subnumber,1); repmat(pooledRD_mpm(3),subnumber,1); ...
            repmat(pooledRD_mpm(4),subnumber,1); repmat(pooledRD_mpm(5),subnumber,1)];
        
        ind1 = [repmat({'Subject ROIs'},subnumber.*5,1);  repmat({'MPMs'},subnumber.*5,1)];
        
        
        mycmapX = [5 113 176; 146 197 222];
        mycmapX = mycmapX ./ 256;
        
        mysize = 16;
        figure('Position', [100 100 1000 400])
        g(1,1) = gramm('x', [myld;myld],'y', [fudgetaculaL;blick], 'color', ind1); % *8 since we are 2x2x2 voxels
        g(1,1).stat_summary('type','sem','geom', {'bar', 'black_errorbar'});
        %g(1,1).geom_bar('stacked', 'false')
        g(1,1).set_names('x', 'Digit', 'y', 'Surface Area (mm^2) + SE');
        g(1,1).set_text_options('font', 'Helvetica', 'base_size', mysize)
        g(1,1).set_order_options('color',0)
        %g(1,1).axe_property('YLim',[-10 250], 'PlotBoxAspectRatio',[1 1 1])
        g(1,1).no_legend()
        
        g(1,2) = gramm('x', [myrd;myrd],'y', [fudgetaculaR;brick],'color', ind1);
        %g(1,2).geom_bar('stacked', 'false')
        g(1,2).stat_summary('type','sem','geom', {'bar', 'black_errorbar'});
        g(1,2).set_names('x', 'Digit', 'y', 'Surface Area (mm^2) + SE');
        g(1,2).set_text_options('font', 'Helvetica', 'base_size', mysize)
        g(1,2).set_order_options('color',0)
        %g(1,2).axe_property('YLim',[-10 250], 'PlotBoxAspectRatio',[1 1 1])
        
        g.draw()
        
%         g.export('file_name','MPM_TM', ...
%             'export_path',...
%             '/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/',...
%             'file_type','pdf')
        g.export('file_name','MPM_PFS',...
            'export_path',...
            '/Users/ppzma/The University of Nottingham/Pain Relief Grant - General/PFP_results/pRF_redo_june23/', ...
            'file_type','pdf')
        
    end
    
    
    %     g.export('file_name', 'ROIsurface_V2',...
    %         'export_path', '/Users/ppxma7/Google Drive/postPhD/digitatlasfiguresmarch/', ...
    %         'file_type', 'pdf')
    
    
    %g.draw()
    %
    %     g.export('file_name',['ROIvolume_surface_' sprintf('%d',gg)], ...
    %         'export_path','/Users/ppxma7/Google Drive/postPhD/digitatlasfiguresmarch/' ,'file_type','pdf')
    
    
    
end



toc

