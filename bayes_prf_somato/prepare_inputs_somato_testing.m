% We have 4 digit levels (d=1..4) and 4 within-digit positions (p=1..4).
numDigits   = 4;
numPositions = 4;
numConds     = numDigits * numPositions;

names     = cell(1, numConds);
onsets    = cell(1, numConds);
durations = cell(1, numConds);

condIndex = 1;
for d = 1:numDigits
    for p = 1:numPositions
        names{condIndex} = sprintf('Digit%d_Pos%d', d, p);
        onsets{condIndex} = [];
        durations{condIndex} = [];
        condIndex = condIndex + 1;
    end
end

%%
stim_files = {'fwd1.mat'};
stim_data = load(fullfile(data_root_dir, thisDSet, stim_files{ii}));  % Load each stimulus file

TR = 2.0;  % example repetition time
stim_duration = 4.0;  % example event duration
N = size(ApFrm, 3);   % total number of time points

for t = 1:N
    % 4x4 binary matrix at time t
    frame_4x4 = ApFrm(:,:,t);

    % Find active locations
    [row_idx, col_idx] = find(frame_4x4==1);

    % If none active, skip
    if isempty(row_idx)
        continue;
    end
    
    % For each active stimulator, figure out which (digit, position)
    for i = 1:numel(row_idx)
        d = col_idx(i);  % "digit"
        p = row_idx(i);  % "within-digit"
        
        % Convert (d, p) -> condition index
        condIndex = (d-1)*numPositions + p;  
        % e.g., Digit1_Pos1 => condIndex=1, Digit1_Pos2=>2 ... Digit2_Pos1=>5, etc.
        
        % Onset is (t-1)*TR
        onsets{condIndex}    = [onsets{condIndex}, (t-1)*TR];
        durations{condIndex} = [durations{condIndex}, stim_duration];
    end
end

ii = 1;
save(fullfile(out_dir, sprintf('onsets_run%d.mat', ii)), 'names', 'onsets', 'durations');
