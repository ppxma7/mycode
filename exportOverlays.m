%exportOverlays()
savedir = '/Volumes/styx/prf_fsaverage/03677_RD_prf4x4/';

v = viewGet([],'view',1);
mlrExportROI(v,[savedir 'mask.nii'])
disp('complete')

%%

%savedir = '/Volumes/styx/prf3/';

thisName = 'prefDigit';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
pathstr = [savedir thisName];
mrExport2SR_caitlin(viewNum,pathstr,[],2);

thisName = 'prefPD';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
pathstr = [savedir thisName];
mrExport2SR_caitlin(viewNum,pathstr,[],3);

thisName = 'rfx';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
pathstr = [savedir thisName];
mrExport2SR_caitlin(viewNum,pathstr,[],4);

thisName = 'rfy';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
pathstr = [savedir thisName];
mrExport2SR_caitlin(viewNum,pathstr,[],5);

% thisName = 'rf';
% v = viewGet([],'view',1);
% viewNum = viewGet(v,'viewNum');
% pathstr = [savedir thisName];
% mrExport2SR_caitlin(viewNum,pathstr,[],4);

thisName = 'adjr2';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
pathstr = [savedir thisName];
mrExport2SR_caitlin(viewNum,pathstr,[],6);

disp('complete')

%%
thisName = 'co';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
pathstr = [savedir thisName];
mrExport2SR_caitlin(viewNum,pathstr,[],1);

thisName = 'ph';
v = viewGet([],'view',1);
viewNum = viewGet(v,'viewNum');
pathstr = [savedir thisName];
mrExport2SR_caitlin(viewNum,pathstr,[],3);
disp('complete')

