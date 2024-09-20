% this code fills in some dynamics with mean of a preivous (good dyn)
clear variables
clc

cd /Volumes/ares/data/HDREMODEL/PA/motion_corrected/aligned_to_structural/

% subjects = {'001_v1_1', '001_v1_4', '001_v2_1', '001_v2_4',...
% 	'002_v1_1',...
%     '003_v1_2',...
% 	'005_v1_1', '005_v1_4', '005_v2_1', '005_v2_4',...
%  	'006_v1_1', '006_v1_4', '006_v2_1', '006_v2_4',...
%  	'007_v1_1', '007_v1_4', '007_v2_1', '007_v2_4',...
% 	'008_v1_1', '008_v1_4', '008_v2_1', '008_v2_4',...
%     '010_v1_1', '010_v1_4', '010_v2_1', '010_v2_4',...
%     '011_v1_1', '011_v1_4',...
%     '012_v1_1',...
%     '013_v1_1',...
%     '014_v1_1', '014_v1_4', '014_v2_1', '014_v2_4',...
%     '015_v1_1', '015_v1_4', '015_v2_1', '015_v2_4',...
%     '016_v1_1', '016_v1_4', '016_v2_1',...
%     '017_v1_1', '017_v1_4', '017_v2_1', '017_v2_4'};
% bad subjects
subjects = {'017_v2_4'};

mydimStart = [10 100 130]; % last good dynamic
mydimEnd = [20 110 140]; % where to stop
clear mn_vol
%counter=1;

for ii = 1:length(subjects)
    
    for nC = 1:length(mydimStart)
        
        mydims = (mydimEnd(nC)-mydimStart(nC))+1;
        mn_vol = zeros(80,80,40,length(mydims)); % make space
        
        if nC>1
            data = data2;
        else    
            [data,hdr] = cbiReadNifti(['HDREMODEL_' subjects{ii} '_RCR_mc_shft_al.nii']);
        end
        
        %for n = 1:5 % how mnay dynamics do you want to cleave
        
        
        %mn_vol = mean(data(:,:,:,mydimStart),4); % mean in 4th dimension
        mn_vol1 = data(:,:,:,mydimStart(nC));
        mn_vol2 = data(:,:,:,mydimEnd(nC));
        
        mn_vol = (mn_vol1 + mn_vol2 ) ./ 2;
        
        
        
        %mn_slc = mean(data(:,:,:,mydimStart),3); % get mean of one slice
        %mn_slc = zeros(80,80);
        mn_voldy = repmat(mn_vol,1,1,1,mydims);
        %mn_vol(:,:,:,n) = repmat(mn_slc,1,1,size(data,3)); % copy to volume volume
        %counter = counter+1;
        %end
        
        
        
        %     a = data(:,:,:,1:mydims(1)-1);
        %     b = data(:,:,:,mydims(end)+1:end);
        a = data(:,:,:,1:mydimStart(nC)-1);
        b = data(:,:,:,mydimEnd(nC)+1:end);
        
        data2 = cat(4, a, mn_voldy, b);
        
        %data2 = data;
        
        
    end
    
    cbiWriteNifti(['HDREMODEL_' subjects{ii} '_RCR_mc_shft_al_fixed.nii'],data2,hdr);
    
    
end



