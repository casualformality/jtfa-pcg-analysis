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

% Separate the heart sounds, and put them in an array.
% This is a pre-processing step before we can take the
% average of the wavelet transforms
[pks,locs] = findpeaks(abs_f, ...
        'MinPeakHeight', max(abs_f) * 0.3, ...
        'MinPeakDistance', dec_fs * 0.3);

% Take the average of the distance between each set of sounds
% so when we do the calculations, all the peaks line up correctly
first_peaks = locs(1:2:end);
second_peaks = locs(2:2:end);

first_offset = floor(mean(first_peaks(2:end) - second_peaks(1:length(first_peaks) - 1)) / 2);
second_offset = floor(mean(second_peaks - first_peaks(1:length(second_peaks))) / 2);

first_locs = first_peaks - first_offset;
first_locs = first_locs(first_locs > 0);
second_locs = second_peaks - second_offset;
second_locs = second_locs(second_locs > first_locs(1));

% Take the average of the CWTs of each of the sets of recorded heart sounds
first_cwt_tmp = cwt(dec_f(first_locs(1):(first_locs(1)+(first_offset*2))), 1:32, 'db8');
first_cwt_width = size(first_cwt_tmp, 1);
first_cwt_depth = size(first_cwt_tmp, 2);
first_cwts = zeros(first_cwt_width, first_cwt_depth, length(second_locs));
for i = 1:length(second_locs)
    first_cwts(:,:,i) = cwt(dec_f(first_locs(i):(first_locs(i)+(first_offset*2))), 1:32, 'db8');
end

second_cwt_tmp = cwt(dec_f(second_locs(1):(second_locs(1)+(second_offset*2))), 1:32, 'db8');
second_cwt_width = size(second_cwt_tmp, 1);
second_cwt_depth = size(second_cwt_tmp, 2);
second_cwts = zeros(second_cwt_width, second_cwt_depth, length(second_locs)-1);
for i = 1:(length(first_locs)-1)
    second_cwts(:,:,i) = cwt(dec_f(second_locs(i):(second_locs(i)+(second_offset*2))), 1:32, 'db8');
end

% This returns a 1xMxN matrix, make this an MxN matrix!
mean_first_cwt = mean(first_cwts, 3);
mean_second_cwt = mean(second_cwts, 3);

% Plot the output
figure;
subplot(3, 1, 1);
plot(dec_t, dec_f);
title('Full Recording');

subplot(3, 2, 3);
plot(dec_t(first_locs(1):(first_locs(1)+(first_offset*2))), dec_f(first_locs(1):(first_locs(1)+(first_offset*2))));
title('First Heart Sound');

subplot(3, 2, 4);
plot(dec_t(second_locs(1):(second_locs(1)+(second_offset*2))), dec_f(second_locs(1):(second_locs(1)+(second_offset*2))));
title('Second Heart Sound');

subplot(3, 2, 5);
imagesc(abs(mean_first_cwt));
title('CWT of First Heart Sounds');

subplot(3, 2, 6);
imagesc(abs(mean_second_cwt));
title('CWT of Second Heart Sounds');