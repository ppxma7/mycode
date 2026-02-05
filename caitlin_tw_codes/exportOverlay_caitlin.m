function[] = exportOverlay_caitlin()

% if nargin<1
%     error('need to give me a name of the overlay')
% end

%thisPath = '/Volumes/LaCie/digitMap/Map02/';
thisPath = '/Volumes/kratos/caitlin/subset/atlas/';

thisSub = 'Map02/3T/';

thisName = 'co';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
%pathstr = [pwd '/digitatlas/' thisName];

pathstr = fullfile(thisPath,thisSub,thisName);

mrExport2SR_caitlin(viewNum,pathstr,[],1);

thisName = 'ph';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
%pathstr = [pwd '/digitatlas/' thisName];
pathstr = fullfile(thisPath,thisSub,thisName);

mrExport2SR_caitlin(viewNum,pathstr,[],3);

v = viewGet([],'view',1);
myROIs = {'cothr.nii'};
roiNums = 1;
for ii = 1:length(myROIs)
    mlrExportROI_group(v,myROIs{ii},'roiNum',roiNums(ii));
end



% thisName = 'cothr';
% v = viewGet([],'view',1);
% viewNum = viewGet(v,'viewNum');
% %pathstr = [pwd '/digitatlas/' thisName];
% pathstr = fullfile(thisPath,thisSub,thisName);
%
% mrExport2SR_caitlin(viewNum,pathstr,[],4);

end