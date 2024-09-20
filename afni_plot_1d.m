cd /Volumes/ares/data/HDREMODEL/PA/motion_corrected/1D/

subjects = {'001_v1_1', '001_v1_4', '001_v2_1', '001_v2_4',...
	'002_v1_1',... 
    '003_v1_2',... 
	'005_v1_1', '005_v1_4', '005_v2_1', '005_v2_4',... 
 	'006_v1_1', '006_v1_4', '006_v2_1', '006_v2_4',... 
 	'007_v1_1', '007_v1_4', '007_v2_1', '007_v2_4',... 
	'008_v1_1', '008_v1_4', '008_v2_1', '008_v2_4',... 
    '010_v1_1', '010_v1_4', '010_v2_1', '010_v2_4',... 
    '011_v1_1', '011_v1_4',... 
    '012_v1_1',... 
    '013_v1_1',... 
    '014_v1_1', '014_v1_4', '014_v2_1', '014_v2_4',... 
    '015_v1_1', '015_v1_4', '015_v2_1', '015_v2_4',... 
    '016_v1_1', '016_v1_4', '016_v2_1',... 
    '017_v1_1', '017_v1_4', '017_v2_1', '017_v2_4'};

subjects = {'001_v1_1'};

% scan 1 and 4
myIdx = [1 4 1 4,...
    1,...
    1,...
    1 4 1 4,...
    1 4 1 4,...
    1 4 1 4,...
    1 4 1 4,...
    1 4 1 4,...
    1 4,...
    1,...
    1,...
    1 4 1 4,...
    1 4 1 4,...
    1 4 1,...
    1 4 1 4]';
    

for ii = 1:length(subjects)
    
    
    a = load(['HDREMODEL_' subjects{ii} '_RCR.1D']);
    a = a - mean(a); %demean
    a = fliplr(a); % now it is AP RL IS Yaw Pitch Roll
    
    % euclidean distance
    % https://doi.org/10.1016/j.neuroimage.2011.07.044
    mydist = sqrt( (a(:,1).^2) + (a(:,2).^2) + (a(:,3).^2) );
    maxMotion(ii) = max(mydist);
    meanMotion(ii) = rms(mydist);
    phi = a(:,4);
    theta = a(:,5);
    psi = a(:,6);
    
    % https://doi.org/10.1016/j.neuroimage.2011.07.044
    myeuler = acos((cos(phi).*cos(theta) + cos(phi).*cos(psi) + cos(theta).*cos(psi) + sin(phi).*sin(psi).*sin(theta) - 1)/2);
    meanEuler(ii) = rms(myeuler);
    
    
end

%figure, scatter(meanMotion, maxMotion)
%figure, scatter(meanMotion, meanEuler)

maxMotion = maxMotion(:);
meanMotion = meanMotion(:);
meanEuler = meanEuler(:);
subjects = subjects(:);
%% want to compare mean motion between scan1s and scan4s

% color code this

clear g
figure
g(1,1) = gramm('x',meanMotion,'y',maxMotion,'color',myIdx);
g(1,1).geom_point()
g(1,1).set_point_options('markers',{'o'},'base_size',10)
g(1,1).set_order_options('x',0)
g(1,1).set_names('x','Mean motion (mm)', 'y', 'Maximum motion (mm)','color','Scan');

g(1,2) = gramm('x',meanMotion,'y',meanEuler,'color',myIdx);
g(1,2).geom_point()
g(1,2).set_point_options('markers',{'o'},'base_size',10)
g(1,2).set_order_options('x',0)
g(1,2).set_names('x','Mean motion (mm)', 'y', 'Mean Euler (rads)','color','Scan');

%g.axe_property('YLim', [0 100])
%g.set_text_options('base_size',8)
g.draw()
shallisave=0;
if shallisave == 1
    g.export('file_name', 'motion_plots',...
        'export_path','/Users/ppzma/Google Drive/PhD/latex/affinity/3T_RCKD/',...
        'file_type','pdf')
end
%set(g.results.geom_jitter_handle,'MarkerEdgeColor',g.results.draw_data.color,'MarkerFaceColor','none')
%xtickangle(45)

%%
% print out which subjects have more than 1mm
myidx1mm = meanMotion>1;
myidx2mmMax = maxMotion>2;
myidx1rad = meanEuler>1;

meanMotionOut = subjects(myidx1mm)
maxMotionOut = subjects(myidx2mmMax)
myidx1rad = subjects(myidx1rad)

%%
% 
% myparams = cat(2,meanMotion,maxMotion,meanEuler);
% myparamsCell = num2cell(myparams);
% mycsv = cat(2,subjects,myparamsCell);
% writecell(mycsv,'headmotion.csv')



%%

% a = load('HDREMODEL_001_v1_1_RCR.1D');
% a = a - mean(a); % subtract columnwise means
% a = fliplr(a);
% 
% AP = repmat({'A-P (mm)'},length(a),1);
% RL = repmat({'R-L (mm)'},length(a),1);
% IS = repmat({'I-S (mm)'},length(a),1);
% ya = repmat({'Yaw (o)'},length(a),1);
% pi = repmat({'Pitch (o)'},length(a),1);
% ro = repmat({'Roll (o)'},length(a),1);
% 
% mygroup = cat(2,AP,RL,IS,ya,pi,ro);
% %mygroup = mygroup;
% 
% timepoints = 1:160;
% timepoints = timepoints(:);
% timepointsG = cat(2,timepoints,timepoints,timepoints,timepoints,timepoints,timepoints); 
% 
% clear g
% figure('Position',[100 100 1000 800])
% g = gramm('x',timepointsG(:),'y',a(:),'color',mygroup(:));
% g.facet_grid(mygroup(:),[],'space','fixed')
% g.geom_line()
% g.set_order_options('x',0,'color',0,'row',0)
% g.set_line_options('base_size',4)
% %g.set_text_options('font','Helvetica', 'base_size',10)
% g.set_names('x','time (dynamics)','row',[])
% g.axe_property('XMinorTick','on','YLim',[-5 5],'XGrid', 'on')
% g.draw

% 



