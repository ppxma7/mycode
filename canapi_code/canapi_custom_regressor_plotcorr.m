mypath='/Volumes/hermes/canapi_full_run_111024/EMG/Export/';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/canapi_full_run_111024/plots/'];
dataset = 'canapi_full_run_111024';

Xlen = length(X);
Xlen2 = length(X).*2;
Xlen3 = length(X).*3;
X1 = SPM.xX.X(1:Xlen,2:7);
X2 = SPM.xX.X(Xlen+1:Xlen2,9:14);
X3 = SPM.xX.X(Xlen2+1:Xlen3,16:21);

mX1 = mean(X1,2);
mX2 = mean(X2,2);
mX3 = mean(X3,2);

X1_boxcar = SPM.xX.X(1:Xlen,1);
X2_boxcar = SPM.xX.X(Xlen+1:Xlen2,8);
X3_boxcar = SPM.xX.X(Xlen2+1:Xlen3,15);

[RHO1,PVAL1] = corr(X1_boxcar, mX1);
[RHO2,PVAL2] = corr(X2_boxcar, mX2);
[RHO3,PVAL3] = corr(X3_boxcar, mX3);

 
% motionParams = X(:,2:end);
% meanMotionParams = mean(motionParams,2);
titlename = 'EMG-Boxcar';
figure
tiledlayout(3,2)
nexttile(1)
imagesc(X1_boxcar)
title([titlename ' 1bar'])
colormap(gray)
nexttile(3)
imagesc(X2_boxcar)
title([titlename ' 30%'])
colormap(gray)
nexttile(5)
imagesc(X3_boxcar)
title([titlename ' 50%'])
colormap(gray)


nexttile(2)
imagesc(mX1)
title(['mean motion 1bar ' sprintf('r: %.2f p: %.3f',RHO1,PVAL1)])
colormap(gray)
nexttile(4)
imagesc(mX2)
title(['mean motion 30% ' sprintf('r: %.2f p: %.3f',RHO2,PVAL2)])
colormap(gray)
nexttile(6)
imagesc(mX3)
title(['mean motion 50% ' sprintf('r: %.2f p: %.3f',RHO3,PVAL3)])
colormap(gray)



% nexttile
% imagesc(meanMotionParams)
% 
% [RHO,PVAL] = corr(X(:,1), meanMotionParams);

%title(['mean motion ' sprintf('r: %.2f p: %.3f',RHO,PVAL)])

t = datetime('now','TimeZone','local','Format','dd-MM-yyyy-HH-mm-ss');
filename = [savedir 'corr_matrix-' titlename dataset '-' char(t)];

h = gcf;
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'inches');
set(h, 'PaperSize', [8 12]);  % Increase the paper size to 20x12 inches
set(h, 'PaperPosition', [0 0 8 12]);  % Adjust paper position to fill the paper size
print(h, '-dpdf', filename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI


