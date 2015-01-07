clear
clc;

SampFreq = 30;
t=0:1/SampFreq:4;
sig = sin(12*pi*t);
sig(1:end/2) = sig(1:end/2) + sin(6*pi*t(1:end/2));
sig(end/2+1:end) = sig(end/2+1:end) + sin(18*pi*t(end/2+1:end));
WinLen = 8;
[WT, FreqBins, Scales] = CWT_Morlet(sig,WinLen,512);

FreqBins = FreqBins * SampFreq;
clf
% set(gcf,'Position',[20 100 300 220]);            
set(gcf,'Color','w');                                            
pcolor(t,FreqBins,abs(WT));
colormap jet;
shading interp;
axis([min(t) max(t) min(FreqBins) max(FreqBins)]);
colorbar;
ylabel('Frequency / Hz');
xlabel('Time / sec');