[f, freq] = audioread('normal-noise.wav');
t = (1/freq)*(1:length(f));

NFFT = 2^nextpow2(length(f));
F = fft(f, NFFT);
hz = freq/2*linspace(0,1,NFFT/2+1);

figure;
plot(hz, abs(F(1:length(hz))));