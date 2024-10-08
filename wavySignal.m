% Define parameters
n_timepoints = 100;  % Total number of timepoints
TR = 1.5;            % Time resolution in seconds
time = (1:n_timepoints) * TR;  % Time vector from 1 to 150 seconds

% Define ON periods (in seconds)
on_times = [21, 51, 81, 111, 141];  % Onset times of the blocks
block_duration = 9;  % Each block lasts 9 seconds

% Create a signal of zeros
signal = zeros(n_timepoints, 1);

% Generate wavy, noisy blocks at the on times
for ii = 1:length(on_times)
    % Find start and end index for each block
    start_idx = round(on_times(ii) / TR);
    %start_idx = on_times(ii);
    %end_idx = start_idx + block_duration;

    end_idx = start_idx + round(block_duration / TR) - 1;
    
    % Create a sine wave for the block
    t = linspace(0, block_duration, end_idx - start_idx + 1);
    wave = sin(2 * pi * (1 / block_duration) * t);  % Wavy pattern
    
    % Add more noise to the wave
    noise = 0.5 * randn(size(wave));  % Increased noise level (0.5)
    wavy_block = wave + noise;
    
    % Insert the noisy, wavy block into the signal
    signal(start_idx:end_idx) = wavy_block;
end

% Plot the resulting signal
figure;
plot(time, signal);
xlabel('Time (s)');
ylabel('Signal');
title('Wavy, Noisy Block Signal');
grid on;
