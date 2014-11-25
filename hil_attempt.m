% The purpose of this script is to find the locations of the
% heart sounds in a given PCG recording.

% Ideally, this should find an envelope that encompasses the original
% signal, allowing us to perform simple peak detection to extract the
% locations of the heart sounds amidst the noise and possible murmurs.

% Load the file
[f, fs] = audioread('heart sounds/ps.wav');
t = (1/fs)*(1:length(f));

% Take the hilbert transform of the original signal
hil_f = hilbert(f);

% Decimate the resulting waveform with a 100 Hz low-pass filter
dec_factor = 441;
dec_f = decimate(hil_f, dec_factor);
dec_t = (1/(fs/dec_factor))*(1:length(dec_f));
dec_fs = fs / dec_factor;

abs_f = abs(dec_f);

[pks,locs] = findpeaks(abs_f, ...
        'MinPeakHeight', max(abs_f) * 0.3, ...
        'MinPeakDistance', dec_fs * 0.3);

figure;
subplot(2,1,1);
plot(t, f);

subplot(2,1,2);
hold on;
plot(dec_t, abs_f);
% Plot the peaks
plot(locs/dec_fs, abs_f(locs), 'g+');
hold off;