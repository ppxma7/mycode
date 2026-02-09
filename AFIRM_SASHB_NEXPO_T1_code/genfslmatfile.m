%% CHAIN 14 or so subjects - DTI

%groupSizes = [14, 22, 6];
groupSizes = [22, 14, 6];

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

% ages = [
%     58 63 56 57 65 62 61 63 63 57 63 63 56 65 ...
%     75 55 47 39 41 65 69 31 64 70 61 70 72 37 55 41 60 67 49 57 73 49 ...
%     57 57 53 83 68 77 ...
%     ]';
ages = [
    75 55 47 39 41 65 69 31 64 70 61 70 72 37 55 41 60 67 49 57 73 49 ...
    58 63 56 57 65 62 61 63 63 57 63 63 56 65 ...
    57 57 53 83 68 77 ...
    ]';

length(ages)


if length(ages) ~= totalSubs
    error('Number of ages (%d) does not match number of subjects (%d)', length(ages), totalSubs);
end

% Append age column
designMat = [designMat ages];

% ---- 3. Write to design.mat ----
nEVs = nGroups + 1; % group EVs + age covariate
fid = fopen('design.mat','w');
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


% 
%% NEXPO G2 T1 mapping
groupSizes = [45, 21, 4];
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
% ages = [
% 34 35 30 39 31 40 43 38 35 33 49 44 46 31 36 45 30 44 46 31 ...
% 37 39 38 45 34 30 40 43 33 32 41 45 33 49 45 44 42 40 50 50 37 49 49 46 40 ...
% 75 55 47 39 41 65 69 31 64 70 61 70 72 37 55 41 60 67 49 57 73 49 ...
% 57 56 57 ...
% ]';

% remove 16798 age 70 for now as he is outlier
ages = [
34 35 30 39 31 40 43 38 35 33 49 44 46 31 36 45 30 44 46 31 ...
37 39 38 45 34 30 40 43 33 32 41 45 33 49 45 44 42 40 50 50 37 49 49 46 40 ...
75 55 47 39 41 65 69 31 64 70 61 72 37 55 41 60 67 49 57 73 49 ...
57 83 68 77 ...
]';

%length(ages)-22-3

%

if length(ages) ~= totalSubs
    error('Number of ages (%d) does not match number of subjects (%d)', length(ages), totalSubs);
end

% Append age column
designMat = [designMat ages];

% ---- 3. Write to design.mat ----
nEVs = nGroups + 1; % group EVs + age covariate
fid = fopen('design.mat','w');
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

%% for DTI missing some subs - do not use
% 
% groupSizes = [43, 22, 2];
% nGroups = length(groupSizes);
% totalSubs = sum(groupSizes);
% 
% % ---- 1. One-hot encoding for groups ----
% designMat = zeros(totalSubs, nGroups);
% startIdx = 1;
% for g = 1:nGroups
%     designMat(startIdx : startIdx + groupSizes(g) - 1, g) = 1;
%     startIdx = startIdx + groupSizes(g);
% end
% 
% % ---- 2. Add covariate: age ----
% ages = [
% 34;31;43;38;35;33;49;46;36;45;30;44;46;31;37;39;38;45;34;30;31;35;40;43;33;41;45;33;49;45;37;44;42;40;50;50;37;49;47;49;50;46;40;
% 75;55;47;39;41;65;69;31;64;70;61;70;72;37;55;41;60;67;49;57;73;49;
% 57;56
% ];
% 
% 
% if length(ages) ~= totalSubs
%     error('Number of ages (%d) does not match number of subjects (%d)', length(ages), totalSubs);
% end
% 
% % Append age column
% designMat = [designMat ages];
% 
% % ---- 3. Write to design.mat ----
% nEVs = nGroups + 1; % group EVs + age covariate
% fid = fopen('design.mat','w');
% fprintf(fid, '/NumWaves %d\n', nEVs);
% fprintf(fid, '/NumPoints %d\n', totalSubs);
% fprintf(fid, '/PPheights');
% fprintf(fid, repmat(' 1', 1, nEVs));
% fprintf(fid, '\n');
% fprintf(fid, '/Matrix\n');
% 
% for i = 1:totalSubs
%     fprintf(fid, [repmat('%d ', 1, nGroups) '%.2f\n'], designMat(i,1:nGroups), designMat(i,end));
% end
% 
% fclose(fid);
% 
% % ---- 4. Quick check ----
% imagesc(designMat(:,1:end-1)) % only show group columns
% xlabel('EV (groups only)'); ylabel('Subjects')
% title('Design Matrix (Groups)')

%% %% TRY nexpo 1 2 3 4 again - T1 mapping

groupSizes = [46, 45, 45, 44];
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

ages = [19 18 19 19 18 18 18 19 19 19 19 19 18 19 18 19 18 18 18 19 18 19 19 19 19 18 18 19 19 18 ...
        19 19 19 19 19 18 18 18 19 18 18 18 18 18 18 18 34 35 30 39 31 40 43 38 35 33 49 44 46 31 ...
        36 45 30 44 46 31 37 39 38 45 34 30 40 43 33 32 41 45 33 49 45 44 42 40 50 50 37 49 49 46 ...
        40 39 46 41 32 40 33 35 31 31 37 44 31 33 45 43 47 45 49 45 39 38 32 30 38 46 38 46 38 43 ...
        50 43 47 31 37 47 41 36 41 38 47 35 43 49 48 46 35 47 45 31 46 48 48 47 49 37 49 37 44 45 ...
        31 50 50 34 36 32 34 39 39 49 40 49 30 49 35 34 32 40 43 42 40 36 43 38 33 31 38 30 38 35]';


length(ages)


if length(ages) ~= totalSubs
    error('Number of ages (%d) does not match number of subjects (%d)', length(ages), totalSubs);
end

% Append age column
designMat = [designMat ages];

% ---- 3. Write to design.mat ----
nEVs = nGroups + 1; % group EVs + age covariate
fid = fopen('design.mat','w');
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

%% NEXPO DTI 191 subj

groupSizes = [48, 46, 48, 49];
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

% ages = [19 18 19 19 19 18 18 18 19 19 19 19 19 18 19 18 18 18 18 19 18 19 ...
%         19 19 19 18 18 19 19 18 19 18 19 19 19 19 19 18 18 18 19 18 18 18 18 19 18 18 18 ...
%         34 31 43 38 35 33 49 46 36 45 30 44 46 31 37 39 38 45 34 30 31 35 40 43 33 41 45 ...
%         33 49 45 37 44 42 40 50 50 37 49 47 49 50 46 40 ...
%         39 46 41 32 40 33 35 31 31 37 43 44 33 31 32 33 45 43 47 45 49 45 42 39 38 32 30 ...
%         38 46 38 46 38 43 50 43 47 31 47 41 36 41 38 47 35 43 49 48 46 ...
%         35 47 45 31 46 48 48 47 49 37 49 37 44 45 45 31 50 50 34 36 32 34 39 39 49 40 49 ...
%         45 30 41 49 35 34 32 40 43 42 40 36 43 38 33 33 31 38 30 38 41 35]';

% ages = [19	18	19	19	19	18	18	18	19	19	19	19	19	18	19	18	18	18	19	18	19	...
%         19	19	19	18	18	19	19	18	19	18	19	19	19	19	19	18	18	18	19	18	18	...
%         18	18	19	18	18	18	34	31	43	38	35	33	49	46	36	45	30	44	46	31	37	... 
%         39	38	45	34	30	31	35	40	43	33	41	45	33	49	45	37	44	42	40	50	50	...
%         37	49	47	49	50	46	40	39	46	41	32	40	33	35	31	31	37	43	44	33	31	...
%         32	33	45	43	47	45	49	45	42	39	38	32	30	38	46	38	46	38	43	50	43	...
%         47	31	47	41	36	41	38	47	35	43	49	48	46	47	45	31	46	48	48	47	49	...
%         37	49	37	44	45	45	31	50	50	34	36	32	34	39	39	49	40	49	45	30	41	...
%         49	35	34	32	40	43	42	40	36	43	38	33	33	31	38	30	38	41	35]';

ages = [19	18	19	19	19	18	18	18	19	19	19	19	19	18	19	18	18	18	19	18	19 ...
        19	19	19	18	18	19	19	18	19	18	19	19	19	19	19	18	18	18	19	18	18 ...
        18	18	19	18	18	18	34	35	30	31	43	38	35	33	49	46	36	45	30	44	46 ...
    	31	37	39	38	45	34	30	31	35	40	43	33	32	41	45	33	49	45	37	44	42 ...
        40	50	50	37	49	47	49	50	46	40	39	46	41	32	40	33	35	31	31	37	43 ...
        44	33	31	32	33	45	43	47	45	49	45	42	39	38	32	30	38	46	38	46	38 ... 
        43	50	43	47	31	47	41	36	41	38	47	35	43	49	48	46	47	45	31	46	48 ...
        48	47	49	37	49	37	44	45	45	31	50	50	34	36	32	34	39	39	49	40	49 ...
        45	30	41	49	35	34	32	40	43	42	40	36	43	38	33	33	31	38	30	38	41	44	35]';

length(ages)


if length(ages) ~= totalSubs
    error('Number of ages (%d) does not match number of subjects (%d)', length(ages), totalSubs);
end

% Append age column
designMat = [designMat ages];

% ---- 3. Write to design.mat ----
nEVs = nGroups + 1; % group EVs + age covariate
fid = fopen('design.mat','w');
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
