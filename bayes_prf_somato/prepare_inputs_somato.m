function U = prepare_inputs_somato(ApFrm, TR, nmicrotime, stim_duration, varargin)
% PREPARE_INPUTS_SOMATO
%   Prepares the input structure for pRF analysis for a 4x4 somatosensory grid.
%
% Inputs:
%   ApFrm         - [rows, cols, time] binary matrix of stimulated locations.
%                   (Here rows = 4, cols = 4)
%   TR            - Repetition time (2 s in your case)
%   nmicrotime    - Bins per TR (e.g. 16)
%   stim_duration - Duration of each stimulation event (4 s)
%   (Optional parameters can be added if needed.)
%
% Returns:
%   U             - A structure array with fields for location and timing

% You can include any optional parameters here (e.g., pmin, rmin) if needed.
% For now, we will simply create the stimulus input structure.

n = size(ApFrm, 3);

% Define grid coordinates for a 4x4 array. Adjust these as needed for your scaling.
% For example, center the grid on 0.
col_positions = linspace(-12, 12, 4);  % x-coordinate for columns (digits)
row_positions = linspace(-12, 12, 4);  % y-coordinate for rows (within-digit)
% Optionally, if you wish "up" to be positive, you might want to flip the row coordinates:
% row_positions = fliplr(row_positions);

U = repmat(struct('x', [], 'y', [], 'ons', [], 'dur', [], 'dt', []), n, 1);

for t = 1:n
    % Get the binary 4x4 stimulation pattern at time t
    im = ApFrm(:,:,t);
    
    % Skip if baseline (no stimulation)
    if ~any(im(:))
        continue;
    end
    
    % Find indices where the stimulator is active
    [row_idx, col_idx] = find(im);
    
    % Map indices to your coordinate space.
    % (Assumes that row 1 corresponds to row_positions(1) etc.)
    x = col_positions(col_idx);
    y = row_positions(row_idx);
    
    % (Optionally, if you need polar coordinates, you can compute them:)
    % dist  = sqrt(x.^2 + y.^2);
    % angle = atan2(y, x);
    
    % Create the structure for this time point.
    U(t).x   = x;         % x-coordinates (between-digit)
    U(t).y   = y;         % y-coordinates (within-digit)
    U(t).ons = TR * (t-1); % Onset time in seconds
    U(t).dur = stim_duration;  % Duration (4 s)
    U(t).dt  = TR / nmicrotime; % Temporal resolution
end

end
