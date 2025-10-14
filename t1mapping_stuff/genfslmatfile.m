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
