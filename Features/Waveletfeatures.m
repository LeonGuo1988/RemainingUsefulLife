function [d1,d2,d3,d4] = Waveletfeatures(Sig)

% This funcation calculate the frequency domain features of the input Signal
% Input:
%   Sig: The input signal
% Output:
%   lmean: The average or mean value of array
%   
% Written by Liang Guo
% 2014-11-26
% guoliang2248@gmail.com

[c,l]=wavedec(Sig, 4, 'db10');

d1 = wrcoef('d',c,l,'db10',1);
d2 = wrcoef('d',c,l,'db10',2);
d3 = wrcoef('d',c,l,'db10',3);
d4 = wrcoef('d',c,l,'db10',4);


