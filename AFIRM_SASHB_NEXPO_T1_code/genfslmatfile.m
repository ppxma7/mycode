% Group sizes
% groupSizes = [46, 45, 45, 44, 22];

groupSizes = [50, 22, 4];


nGroups = length(groupSizes);
totalSubs = sum(groupSizes);

% Create design matrix: one-hot encoding for each group
designMat = zeros(totalSubs, nGroups);

startIdx = 1;
for g = 1:nGroups
    designMat(startIdx : startIdx + groupSizes(g) - 1, g) = 1;
    startIdx = startIdx + groupSizes(g);
end

% Prepare .mat file text content
fid = fopen('design.mat','w');
fprintf(fid, '/NumWaves %d\n', nGroups);
fprintf(fid, '/NumPoints %d\n', totalSubs);
fprintf(fid, '/PPheights');
fprintf(fid, ' 1'); % Assuming all EVs have height 1
for i = 2:nGroups
    fprintf(fid, ' 1');
end
fprintf(fid, '\n');
fprintf(fid, '/Matrix\n');

% for i = 1:totalSubs
%     fprintf(fid, '%d %d %d %d %d\n', designMat(i,1), designMat(i,2), designMat(i,3), designMat(i,4), designMat(i,5));
% end

for i = 1:totalSubs
    fprintf(fid, [repmat('%d ', 1, nGroups) '\n'], designMat(i,:));
end


fclose(fid);

imagesc(designMat)
xlabel('Groups'); ylabel('Subjects')
title('Design Matrix')

%%
% groupSizes = [46, 45, 45, 44, 22];
% grp = [];
% 
% for g = 1:length(groupSizes)
%     grp = [grp; repmat(g, groupSizes(g), 1)];
% end
% 
% % Save to design.grp file
% fid = fopen('design.grp', 'w');
% fprintf(fid, '%d\n', grp);
% fclose(fid);
% 
%%
groupSizes = [50, 22, 4];
nGroups = length(groupSizes);
totalSubs = sum(groupSizes);

% ---- 1. One-hot encoding for groups ----
designMat = zeros(totalSubs, nGroups);
startIdx = 1;
for g = 1:nGroups
    designMat(startIdx : startIdx + groupSizes(g) - 1, g) = 1;
    startIdx = startIdx + groupSizes(g);
end

% ---- 2. Add covariate: age ----
ages = [
34;35;30;39;31;40;43;38;35;33;49;44;46;31;36;45;30;44;46;31;37;39;38;45;34;30;31;35;40;43;33;32;41;45;33;49;45;37;44;42;40;50;50;37;49;47;49;50;46;40;
75;55;47;39;41;65;69;31;64;70;61;70;72;37;55;41;60;67;49;57;73;49;
53;57;56;57
];

if length(ages) ~= totalSubs
    error('Number of ages (%d) does not match number of subjects (%d)', length(ages), totalSubs);
end

% Append age column
designMat = [designMat ages];

% ---- 3. Write to design.mat ----
nEVs = nGroups + 1; % group EVs + age covariate
fid = fopen('design.mat','w'
fprintf(fid, '/NumWaves %d\n', nEVs);
fprintf(fid, '/NumPoints %d\n', totalSubs);
fprintf(fid, '/PPheights');
fprintf(fid, repmat(' 1', 1, nEVs));
fprintf(fid, '\n');
fprintf(fid, '/Matrix\n');

for i = 1:totalSubs
    fprintf(fid, [repmat('%d ', 1, nGroups) '%.2f\n'], designMat(i,1:nGroups), designMat(i,end));
end

fclose(fid);

% ---- 4. Quick check ----
imagesc(designMat(:,1:end-1)) % only show group columns
xlabel('EV (groups only)'); ylabel('Subjects')
title('Design Matrix (Groups)')
