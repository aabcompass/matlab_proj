clear all;
%parameters
T=0.001; % sampling period
N=2^8; % number of samples
t=T:T:T*N; % decrete time (milliseconds)
f=8.5/(T*N) % cycle frequancy in Hz
omega=2*pi*f; % Angular frequency
A=1; % Amplitude
sig=A*sin(omega*t); % pure sine signal
plot(sig);

fft_sig=fft(sig); % FFT transform
abs_fft_sig=abs(fft_sig); % Absolut value
plot(abs_fft_sig);

db_abs_fft_sig=20*log(abs_fft_sig); % Absolut value in dB
plot(db_abs_fft_sig);

% signal + noise

rng('default'); % run randomizer
noise = randn(1,N); % generate random signal (noise)
sig = sig + noise;
plot(sig);

% FFT of rectangular signal
sig = zeros(1, N);
sig(1:N/8) = 1;
plot(sig);

