function [imf] = EMDfeatures(Sig,n)

% This funcation calculate the frequency domain features of the input Signal
% Input:
%   Sig: The input signal
% Output:
%   lmean: The average or mean value of array
%   
% Written by Liang Guo
% 2014-11-26
% guoliang2248@gmail.com
imf = emd_n(Sig,n);


