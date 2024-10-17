function[convolved_signal, signal] = wavySignal(noise_val, no_wave)


if nargin==1
    %noise_val = 0.5;
    no_wave = 0;
elseif nargin==0
    noise_val = 0.5;
    no_wave = 0;
end
% Define parameters
n_timepoints = 114;  % Total number of timepoints
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
    noise = noise_val * randn(size(wave));  % Increased noise level (0.5)
    wavy_block = wave + noise;

    if no_wave == 1
        wavy_block = ones(1,length(wavy_block));
    end
    
    % Insert the noisy, wavy block into the signal
    signal(start_idx:end_idx) = wavy_block;
end

% Plot the resulting signal
% figure;
% plot(time, signal);
% xlabel('Time (s)');
% ylabel('Signal');
% title('Wavy, Noisy Block Signal');
% grid on;


% SPM Canonical HRF (hemodynamic response function)
hrf = spm_hrf(TR);  % Get the canonical HRF for convolution

% Convolve the EMG-modulated neural signal with the HRF
convolved_signal = conv(signal, hrf);
convolved_signal = convolved_signal(1:n_timepoints);  % Trim to match original length

% figure
% plot(time, convolved_signal);
% xlabel('Time (s)');
% ylabel('Signal');
% title('Wavy, Noisy Block Signal');
% grid on;


%% try editing realign files to create matrix
% 
% mypath = '/Volumes/hermes/canapi_full_run_111024/spm_analysis/';
% 
% myFiles = {'rp_parrec_WIP1bar_20241011131601_4_nordic_clv.txt',...
%     'rp_parrec_WIP1bar_20241011131601_10_nordic_clv.txt',...
%     'rp_parrec_WIP30prc_20241011131601_5_nordic_clv.txt',...
%     'rp_parrec_WIP30prc_20241011131601_11_nordic_clv.txt',...
%     'rp_parrec_WIP50prc_20241011131601_6_nordic_clv.txt',...
%     'rp_parrec_WIP50prc_20241011131601_12_nordic_clv.txt',...
%     'rp_parrec_WIP70prc_20241011131601_13_nordic_clv.txt'};
% 
% 
% for ii = 1:length(myFiles)
%     thisFile = load(myFiles{ii});
%     newSignal = [signal thisFile];
%     thisFile_noExt = extractBefore(myFiles{ii},'.');
%     writematrix(newSignal,[mypath thisFile_noExt '_wavy.txt'])
% end



end










