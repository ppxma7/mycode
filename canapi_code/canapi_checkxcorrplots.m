close all
run = 4;
subj = 1;

% trace1 = opMatsubs_noconv_sub01fix{run, 1, subj};  % channel 1
% trace2 = opMatsubs_noconv_sub01fix{run, 2, subj};  % channel 2


trace1 = opMatsubs_noconv{run, 1, subj};  % channel 1
trace2 = opMatsubs_noconv{run, 2, subj};  % channel 2

trace1m = trace1 - mean(trace1);
trace2m = trace2 - mean(trace2);

% --- Compute raw (unnormalized) cross-correlation ---
[xc, lags] = xcorr(trace1, trace2);

% --- Find peak (amplitude × synchrony) ---
peakXC = max(abs(xc));

figure
plot(trace1m)
hold on
plot(trace2m)

figure
plot(xc)
title(['Peak XC: ' num2str(peakXC)])

rms1 = rms(trace1m);
rms2 = rms(trace2m);
fprintf('Subject %d Run %d: RMS1=%.3f RMS2=%.3f\n', subj, run, rms1, rms2);

% 
% for subj = 1:nSubjects
%     rms1 = mean(cellfun(@(x) rms(x), opMatsubs_noconv_sub01fix(:,1,subj)));
%     rms2 = mean(cellfun(@(x) rms(x), opMatsubs_noconv_sub01fix(:,2,subj)));
%     fprintf('S%02d: RMS1 = %.3f, RMS2 = %.3f, ratio = %.2f\n', ...
%             subj, rms1, rms2, rms2/rms1);
% end
% 
% for run = 1:4
%     max1 = max(opMatsubs_noconv_sub01fix{run,1,1});
%     max2 = max(opMatsubs_noconv_sub01fix{run,2,1});
%     fprintf('Sub1 Run%d: max1=%.3f  max2=%.3f  ratio=%.2f\n', run, max1, max2, max2/max1);
% end


%%
figure, plot(myupper)
hold on
plot(myupper2)