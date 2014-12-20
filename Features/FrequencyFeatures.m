function [LFFT] = FrequencyFeatures(Sig,fsamples)

% This funcation calculate the frequency domain features of the input Signal
% Input:
%   Sig: The input signal
% Output:
%   lmean: The average or mean value of array
%   
% Written by Liang Guo
% 2014-11-26
% guoliang2248@gmail.com

if (nargin==0),
    error('At least one parameter is required');
end

Siglen = length(Sig);
%% FFT of the input signal
LFFT = abs(fft(Sig));
f = (0:Siglen/2-1)/(fsamples*Siglen);
figure(1);
subplot(311)
plot(f(1:Siglen/2),LFFT(1:Siglen/2));
xlabel('Frequency');
ylabel('Amplitude');
title('FFT of the input signal');

%%  Real cepstrum of the input signal
LRC = rceps(Sig);
t=(1:Siglen)*fsamples;
subplot(312);
plot(t,LRC);
xlabel('Frequency');
ylabel('Amplitude');
title('Real cepstrum of the input signal');

%% Plural cepstrum of the input signal
LPC = cceps(Sig);
t=(1:Siglen)*fsamples;
subplot(313);
plot(t,LPC);
xlabel('Frequency');
ylabel('Amplitude');
title('Plural cepstrum of the input signal');

%% Envelop spectr of input signal
y=Sig;
N=length(Sig);
NFFT=1;
while (NFFT<N)
        NFFT=2*NFFT;
end
 NFFT=NFFT/2;
Fs = 1/fsamples;
y1=hilbert(y);
A=abs(y1);
A=A-mean(A);%最好加上去均值
Y = fft(A,NFFT)/N;
X = Fs/2*linspace(0,1,NFFT/2+1);
Y=2*abs(Y(1:NFFT/2+1));
if nargin<3
figure(2)
subplot(311);
plot(X,Y) 
title('包络谱')
xlabel('f(Hz)')
ylabel('|Y(f)|')
end
end