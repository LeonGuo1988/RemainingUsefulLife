function [lmean,lrms,lAmean,lmax,lmin,lppv,lvar,...
    lRA,lKV,lsf,lcf,lif,lclf,lkvi,lautocorr] = TimeFeatures(Sig)
% This funcation calculate the time domain features of the input Signal
% Input:
%   Sig: The input signal
% Output:
%   lmean: The average or mean value of array
%   lautocorr: Autocorrelation function of input signal
%   lrms: Root-mean-square value of input signal
%   lAmean:The average of absolate value of input signal 
%   lmax:The maximum of input signal
%   lmin:The mixmum of input signal
%   lppv:The peak-to-peak value
%   lvar:The cariance of input signal
%   lRA:The root amplitude of input signal
%   lKV:The kurtosis value 
%   lsf:The waveform indicators
%   lcf:The peak metric
%   lif:The impulse factor
%   lclf:The margin index
%   lkvi:the Kurtosis index
% Written by Liang Guo
% 2014-11-26
% guoliang2248@gmail.com

if(nargin==0),
    error('At least one input paramenter is required');
end

Siglen = length(Sig);

%% The average or mean value of array
lmean = sum(Sig)/Siglen;
%% Root-mean-square value of input signal
lrms = rms(Sig);
%% The average of absolate value of input signal
lAmean = sum(abs(Sig))/Siglen;
%% The maximum of input signal
lmax = max(Sig);
%% The mixmum of input signal
lmin = min(Sig);
%% The peak-to-peak value
lppv = lmax - lmin;
%% The cariance of input signal
lvar = var(Sig);
%% The root amplitude of input signal
% RA = 0;
% for i = 1:Siglen
%         RA = RA + abs(Sig(i));
% end
RA = sum(abs(Sig));
lRA = (RA/Siglen)^2;
%% The kurtosis value 
% KV = 0;
% for i = 1:Siglen
%         KV = KV + Sig(i)^4;
% end
KV = sum(Sig.^4);
lKV = KV/Siglen;
%% The waveform indicators
lsf = lrms/lAmean;
%% The peak metric
lcf = lmax/lrms;
%% The impulse factor
lif = lmax/lAmean;
%% The margin index
lclf = lmax/lRA;
%% the Kurtosis index
lkvi = lKV/lrms^4;
%% Autocorrelation function of input signal
lautocorr = autocorr(Sig);
end


