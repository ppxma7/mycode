function [upperHigh, isOutlier] = outlierTest(x)
%outlierTest - microfunc to do the 1.5IQR rule on a vector of data
%            - prints out a logical index of which values are considered
%            outliers by this rule
% 
% Michael Asghar - 17/9/2020

if size(x,2)>1 % error check
    error('must be a 1D vector')
end

p = 3; % quantiles

y = quantile(x,p); % split into 25,50,75

upperHigh = y(3) + (1.5 .* iqr(x)); % Find the upper threshold

isOutlier = x<upperHigh; % logical indexing instead of loop
% flip this so that 1 means it isn't an outlier, 0 is yes outlier. This
% makes indexing in other functions easier.

disp(isOutlier)

end

