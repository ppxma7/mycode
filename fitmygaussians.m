function[yhat, curve_fits]=fitmygaussians(varargin)
% this is a fancy code I found here: https://uk.mathworks.com/matlabcentral/fileexchange/74408-fit-multiple-gaussians?s_tid=prof_contriblnk
% this uses fminsearch to fit multiple Gaussians to a curve 
% for a demo version, See Also fit_multiple_gaussians.m
%
% I've wrapped the functionality of the code into a useful function that
% can be called
%
% x is your xdata
% y is your ydata
% numGaussians is how many Gaussians you want to fit to your data
% initial Guess. Each column is a Gaussian, so the first row is your mean,
% the second is the width and so on for the next column. For 2 Gaussians,
% your guess could be initialGuesses = [1000,300;1000,500];
%
% MA Nov 2022

clear globals
if size(varargin,2) ~= 4
    error('Need x, y, howmanyGs, and your guesses')
end

x = varargin{1};
y = varargin{2};
numGaussians = varargin{3};
initialGuesses = varargin{4};

fontSize = 12;

% First specify how many Gaussians there will be.
%numGaussians = 2;
% if nargin < 3, numGaussians = 6; end
% 
% 
% if 

% Fit Gaussian Peaks:

startingGuesses = reshape(initialGuesses', 1, []);

global c %NumTrials TrialError
% 	warning off

% Initializations
%NumTrials = 0;  % Track trials
%TrialError = 0; % Track errors
% t and y must be row vectors.
tFit = reshape(x, 1, []);
y = reshape(y, 1, []);

%-------------------------------------------------------------------------------------------------------------------------------------------
% Perform an iterative fit using the FMINSEARCH function to optimize the height, width and center of the multiple Gaussians.
options = optimset('TolX', 1e-4, 'MaxFunEvals', 10^12);  % Determines how close the model must fit the data
% First, set some options for fminsearch().
options.TolFun = 1e-4;
options.TolX = 1e-4;
options.MaxIter = 100000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEAVY LIFTING DONE RIGHT HERE:
% Run optimization
[parameter, fval, flag, output] = fminsearch(@(lambda)(fitgauss(lambda, tFit, y)), startingGuesses, options);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%----------------------------------------------------------------------------------------------------------------
% Now plot results.
[yhat,curve_fits] = PlotComponentCurves_lite(x, y, tFit, c, parameter);
% Compute the residuals between the actual y and the estimated y and put that into the graph's title.
meanResidual = mean(abs(y - yhat));
fprintf('The mean of the absolute value of the residuals is %f.\n', meanResidual);
caption = sprintf('Estimation of %d Gaussian Curves that will fit data.  Mean Residual = %f.', numGaussians, meanResidual);
title(caption, 'FontSize', fontSize, 'Interpreter', 'none');
drawnow;

% Make table for the fitted, estimated results.
% First make numGaussians row by 3 column matrix: Column 1 = amplitude, column 2 = mean, column 3 = width.
% 	parameter % Print to command window.
estimatedMuSigma = reshape(parameter, 2, [])';
gaussianParameters = [c, estimatedMuSigma];
% Now sort parameters in order of increasing mean
gaussianParameters = sortrows(gaussianParameters, 2);
%tActual % Display actual table in the command window.
% Create table of the output parameters and display it below the actual, true parameters.
tEstimate = table((1:numGaussians)', c(:), estimatedMuSigma(:, 1), estimatedMuSigma(:, 2), 'VariableNames', {'Number', 'Amplitude', 'Mean', 'Width'});

% Plot the error as a function of trial number.
% hFigError = figure();
% hFigError.Name = 'Errors';
% plot(TrialError, 'b-');
% % hFigError.WindowState = 'maximized';
% grid on;
% xlabel('Trial Number', 'FontSize', fontSize)
% ylabel('Error', 'FontSize', fontSize)
% 
% caption = sprintf('Errors for all %d trials.', length(TrialError));
% title(caption, 'FontSize', fontSize, 'Interpreter', 'none');

message = sprintf('Done!\nHere is the result!\nNote: there could be multiple ways\n(multiple sets of Gaussians)\nthat you could achieve the same sum (same test curve).');
fprintf('Done running %s.m.\n', mfilename);
%msgboxw(message);


end
