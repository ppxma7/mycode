cd /Volumes/ares/data/HDREMODEL/PA/test_which_moco/

subjects = {'HDREMODEL_001_v1_1_RCR_mcf.par',...
    'HDREMODEL_001_v1_1_RCR.1D'};

for ii = 1:length(subjects)
    %a = load(['HDREMODEL_' subjects{ii} '_RCR.1D']);
    a = load(subjects{ii});
    a = a - mean(a); %demean
    a = fliplr(a); % now it is AP RL IS Yaw Pitch Roll
    
    if strcmpi(subjects{ii},'HDREMODEL_001_v1_1_RCR_mcf.par')
        fixed_a = [a(:,2) a(:,3) a(:,1) a(:,5) a(:,6) a(:,4)];
        
        my_rot = fixed_a(:,4:6);
        my_rot_fixed = my_rot .* (180./pi); % convert mcflirt rotations
        a = [fixed_a(:,1:3) my_rot_fixed];
    end
    
    amat(:,:,ii) = a;
    
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
    
    AP = repmat({'A-P (mm)'},length(a),1);
    RL = repmat({'R-L (mm)'},length(a),1);
    IS = repmat({'I-S (mm)'},length(a),1);
    ya = repmat({'Yaw (o)'},length(a),1);
    pI = repmat({'Pitch (o)'},length(a),1);
    ro = repmat({'Roll (o)'},length(a),1);
    
    mygroup = cat(2,AP,RL,IS,ya,pI,ro);
    %mygroup = mygroup;
    
    timepoints = 1:160;
    timepoints = timepoints(:);
    timepointsG = cat(2,timepoints,timepoints,timepoints,timepoints,timepoints,timepoints);
    
    
    figure('Position',[100 100 1000 800])
    g = gramm('x',timepointsG(:),'y',a(:),'color',mygroup(:));
    g.facet_grid(mygroup(:),[],'space','fixed')
    g.geom_line()
    g.set_order_options('x',0,'color',0,'row',0)
    g.set_line_options('base_size',4)
    %g.set_text_options('font','Helvetica', 'base_size',10)
    g.set_names('x','time (dynamics)','row',[])
    g.axe_property('XMinorTick','on','YLim',[-5 5],'XGrid', 'on')
    g.draw
    
    
    
end



%% color code this




