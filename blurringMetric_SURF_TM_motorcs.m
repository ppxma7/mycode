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

%

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
    fspath = '/Users/caitlinsmith/freesurfer/subjects/fsaverage/';
    
    
    
    %[verts, faces_rh] = read_surf([fspath 'surf/rh.' surface_type{gg}]);
    %faces = faces_rh+1; %start from 1 not zero for counting
    % calculate area of every triangle using A = 0.5*|cross(AB,AC)|
    %AB = verts(faces(:,2),:) - verts(faces(:,1),:);
    %AC = verts(faces(:,3),:) - verts(faces(:,1),:);
    %xABAC = cross(AB,AC);
    %area_rh = 0.5*sqrt(sum(xABAC.*xABAC,2));
    
    [verts, faces_lh] = read_surf([fspath 'surf/lh.' surface_type{gg}]);
    faces = faces_lh+1;
        
    AB = verts(faces(:,2),:) - verts(faces(:,1),:);
    AC = verts(faces(:,3),:) - verts(faces(:,1),:);
    
    xABAC = cross(AB,AC);
    area_lh = 0.5*sqrt(sum(xABAC.*xABAC,2));
    
    %cd '/Users/ppxma7/data/DigitAtlas/fsaveragePhBindDigits'
    % cd '/Volumes/research/7T_fMRI/DigitAtlas/ayanData/SBA_digit_ROIs/exploded/'
    %mypath = '/Volumes/data/Research/TOUCHMAP/digitAtlas_2019/digitmap/maps_mni/surf/';
    %mypath = '/Volumes/ares/nemosine/DigitAtlasv2/fsaverage_2mm/';
    
    mypath = '/Users/caitlinsmith/freesurfer/subjects/-mapping/motortopy/';
    cd(mypath)
    
     subs = {'Pre01' 'Pre02' 'Pre03' 'Pre04' 'Pre05' 'Pre06' 'Pre07' 'Pre08' 'Pre09' 'Pre10' 'Pre11' 'Pre12' 'Pre13' 'Pre14' 'Pre15' 'Pre17' 'Pre18' 'Pre19' 'Pre20' 'Pre21'};
   %POST subs = {'Post01' 'Post02' 'Post03' 'Post04' 'Post05' 'Post06' 'Post07' 'Post08' 'Post09' 'Post10' 'Post11' 'Post12' 'Post13' 'Post14' 'Post15' 'Post18' 'Post19' 'Post20' 'Post21'};
    %Prevtx subs = {'Pre05' 'Pre06' 'Pre07' 'Pre10' 'Pre14' 'Pre17' 'Pre18' 'Pre20' 'Pre21'};
    %PostVtx subs = {'Post05' 'Post06' 'Post07' 'Post10' 'Post14' 'Post18' 'Post20' 'Post21'};
    %M1Pre subs = {'Pre01' 'Pre02' 'Pre03' 'Pre04' 'Pre08' 'Pre09' 'Pre11' 'Pre12' 'Pre13' 'Pre15' 'Pre19'};
    %M1Post subs = {'Post01' 'Post02' 'Post03' 'Post04' 'Post08' 'Post09' 'Post11' 'Post12' 'Post13' 'Post15' 'Post19'};
   
    subdir = '/Users/caitlinsmith/freesurfer/subjects/-mapping/motortopy/';

  %  subjects = {'13382','13447proj','13493', '13654','13658', '13695', '14001'};
    
    subnumber = length(subs);
    tic
    
    %% for right digits
 for ii = 1:size(subs,2)
     
     cd([subdir])
     disp(['Working through subject ' subs{ii}])

     
          for iDigit = 1:5      
                theFile = MRIread([subs{ii} '_RD' num2str(iDigit) '_fsaverage'  '.mgh']); %read in the nii.gz file
         
             RD = theFile.vol;
       
             RD_full(:,iDigit,ii) = RD > 0;
          end
  
 
   
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
        
        for ii = 1:length(tmpSubs) % need to find mean across all subjects separately here, hence for loop
            tmp = RD_full(:,iDigit,ii);
            idv = find(tmp==1);
            idt = find(sum(ismember(faces_lh+1,idv),2)==3);
            subRD(ii) = sum(area_lh(idt));
        end
        ARD = mean(subRD); % this is the mean area of the digit across subs
        % do 100.* Apooled - mean(A) ./ mean(A)
        myblurR(iDigit) = 100 .*  (pooledRD - ARD) ./ ARD;
        
        fudge(iDigit).lefthemi = subRD;
        %fudge(iDigit).lefthemi_sd = std(subRD);
    end
 end
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
  
    %% Plots
    
    h(gg) = figure;
%     h1 = plot([1:5], myblurL, '-o','color','r','markerfacecolor','r','linewidth',2);
%     hold on
    h1 = plot([1:5], myblurR, '-o','color','k','markerfacecolor','k','linewidth',2);
    legd = legend('PreAll-iTBS Right Digits','location','nw');
    ylim([0 1800])
    xlim([0.1 5.9])
    title(['motor ' surface_type{gg}])
    xlabel('Digits')
    ylabel('Blurring metric %')
    axis square
    set(gcf,'color','w')
    
    if shallisave
        filename = fullfile('/Users/caitlinsmith/freesurfer/subjects/-mapping/subject_digits/blurring/', ...
    ['BlurringMetric_surface_PreAll_' num2str(gg)]);  
    %['BlurringMetric_surface_PreVtx_' num2str(gg)]);
        %['BlurringMetric_surface_PreVtx_' num2str(gg)]);    
        %['BlurringMetric_surface_PreM1_' num2str(gg)]);
        %['BlurringMetric_surface_PostM1_' num2str(gg)]);
        print(filename,'-dpdf')
    end
    %%
    
    if doMPM == 1
        %% try loading in MPMs for bar chart
        %mpmpath = '/Volumes/data/Research/TOUCHMAP/digitAtlas_2019/digitmap/maps_mni/surf/MPM/';
        mpmpath = '/Users/caitlinsmith/freesurfer/subjects/-mapping/subject_digits/';
        thempm = load([mpmpath 'mpms.mat']);
%         LDmpm = MRIread([mpmpath, 'LD_all.mgz']);
       %RDmpm = MRIread([mpmpath, 'RD_all.mgz']);
        %LDmpm = thempm.mLD(:);
        RDmpm = thempm.mRD(:);
%         LDmpm = LDmpm.vol(:);
     %    RDmpm = RDmpm.vol(:);
        for impm = 1:5
            %idv_mpm = find(LDmpm==impm);
            idv_mpmR = find(RDmpm==impm);
            %idt_mpm = find(sum(ismember(faces_rh+1,idv_mpm),2)==3);
            idt_mpmR = find(sum(ismember(faces_lh+1,idv_mpmR),2)==3);
            %pooledLD_mpm(impm) = sum(area_rh(idt_mpm));
            pooledRD_mpm(impm) = sum(area_lh(idt_mpmR));
        end
        
        % plot volumes of ROIs
        
        
        rd1 = repmat({'D1'},length(getfield(fudge(1),'lefthemi')),1);
        rd2 = repmat({'D2'},length(getfield(fudge(2),'lefthemi')),1);
        rd3 = repmat({'D3'},length(getfield(fudge(3),'lefthemi')),1);
        rd4 = repmat({'D4'},length(getfield(fudge(4),'lefthemi')),1);
        rd5 = repmat({'D5'},length(getfield(fudge(5),'lefthemi')),1);

        myrd = [rd1; rd2; rd3; rd4;rd5];
        
        % comma instead of semi colon otherwise the getfield messes everything
        % up
        fudgetaculaR = [getfield(fudge(1),'lefthemi'),getfield(fudge(2),'lefthemi'),...
            getfield(fudge(3),'lefthemi'), getfield(fudge(4),'lefthemi'),getfield(fudge(5),'lefthemi')];
        
        fudgetaculaR = fudgetaculaR(:);
        
        
        brick = [repmat(pooledRD_mpm(1),subnumber,1); repmat(pooledRD_mpm(2),subnumber,1); repmat(pooledRD_mpm(3),subnumber,1); ...
            repmat(pooledRD_mpm(4),subnumber,1); repmat(pooledRD_mpm(5),subnumber,1)];
        
        ind1 = [repmat({'Subject ROIs'},subnumber.*5,1);  repmat({'MPMs'},subnumber.*5,1)];
        
        
        mycmapX = [5 113 176; 146 197 222];
        mycmapX = mycmapX ./ 256;
        
        mysize = 16;
        figure('Position', [100 100 1000 400])
        g(1,1) = gramm('x', [myrd;myrd],'y', [fudgetaculaR;brick], 'color', ind1); % *8 since we are 2x2x2 voxels
        g(1,1).stat_summary('type','sem','geom', {'bar', 'black_errorbar'});
        %g(1,1).geom_bar('stacked', 'false')
        g(1,1).set_names('x', 'Digit', 'y', 'Surface Area (mm^2) + SE');
        g(1,1).set_text_options('font', 'Helvetica', 'base_size', mysize)
        g(1,1).set_order_options('color',0)
        g(1,1).axe_property('YLim',[-10 250], 'PlotBoxAspectRatio',[1 1 1])
        g(1,1).no_legend()
        
        g.draw()
        
        g.export('file_name','MPM_preVtx', ...
            'export_path',...
            '/Users/caitlinsmith/freesurfer/subjects/-mapping/subject_digits/blurring/figuresApril/',...
            'file_type','pdf')
        
    end
    
    
    %     g.export('file_name', 'ROIsurface_V2',...
    %         'export_path', '/Users/ppxma7/Google Drive/postPhD/digitatlasfiguresmarch/', ...
    %         'file_type', 'pdf')
    
    
    %g.draw()
    %
    %     g.export('file_name',['ROIvolume_surface_' sprintf('%d',gg)], ...
    %         'export_path','/Users/ppxma7/Google Drive/postPhD/digitatlasfiguresmarch/' ,'file_type','pdf')
    
    
    




toc

