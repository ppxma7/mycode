x = 1:0.1:10;

% Number of phase-shifted sinusoids
N = 5;

figure; hold on;

for k = 0:N-1
    phase = k * (2*pi/N);      % shift = 0, 2π/5, 4π/5, 6π/5, 8π/5
    y = sin(x + phase);
    plot(x, y, 'LineWidth', 2);
end

xlabel('Time');
ylabel('Amplitude');
title('Phase-shifted sinusoids');

%%
phase = linspace(0, 2*pi, 500);
N = 5;   % number of phase-shifted curves

figure; hold on;

for k = 0:N-1
    shift = k * (2*pi/N);
    y = sin(phase + shift);
    plot(phase, y, 'LineWidth', 2);
end

xlabel('Phase (radians)');
ylabel('Amplitude');
title('Phase-shifted sinusoids over 0–2\pi');
xlim([0 2*pi]);
%%
N = 5;
phases = linspace(0, 2*pi, N+1); 
phases(end) = []; % drop repeated 2pi point

figure;
polarplot(phases, ones(1,N), 'o', 'LineWidth', 2);
title('Five evenly spaced phases (0–2\pi)');
%%
t = linspace(0, 2*pi, 500);
N = 5; % digits

fig = figure; hold on;

for d = 1:N
    phase = (2*pi/N) * (d-1);   % 0, 2π/5, 4π/5, ...
    y = sin(t + phase);
    plot(t, y, 'LineWidth', 2);
end

xlabel('Time');
ylabel('Amplitude');
title('Digit-to-Phase Mapping (2π/5 steps)');
legend({'Digit 1','Digit 2','Digit 3','Digit 4','Digit 5'});

%h = gcf;
orient(fig,'landscape')
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-TheUniversityofNottingham/TEACHING/'];
thisFilename = [savedir 'phaseplot'];
print(fig, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI
