function [WT, FreqBins, Scales] = CWT_Morlet(Sig, WinLen, nLevel)

%============================================================%
%  Continuous Wavelet Transform using Morlet function               
%            Sig : 信号                                          
%    WinLen : 小波函数在尺度参数a=1时的长度   （默认为 10）                 
%      nLevel : 频率轴划分区间数   （默认为1024）      
%
%           WT:  返回的小波变换计算结果
%  FreqBins :  返回频率轴划分结果（归一化频率，最高频率为0.5）
%       Scales:   返回与频率轴划分值相对应的尺度划分 （频率0.5对应的尺度为1）
%============================================================%

if (nargin == 0),
     error('At least 1 parameter required');
end;

if (nargin < 4),
     iShow = 1;
elseif (nargin < 3),
     nLevel = 1024;
elseif (nargin < 2),
     WinLen = 10;
end;

Sig = hilbert(real(Sig));                     % 计算信号的解析信号
SigLen = length(Sig);                        % 获取信号的长度
fmax = 0.5;                                         % 设置最高分析频率
fmin = 0.005;                                      % 设置最低分析频率
FreqBins = logspace(log10(fmin),log10(0.5),nLevel);    % 将频率轴在分析范围内等对数坐标划分
Scales = fmax*ones(size(FreqBins))./ FreqBins;             % 计算响应的尺度参数
omg0 = WinLen / 6;                            % 按给定的小波长度计算相应的小波函数中心频率
WT = zeros(nLevel, SigLen);              % 分配计算结果的存储单元

wait = waitbar(0,'Under calculation, please wait...');
for m = 1:nLevel,
   
    waitbar(m/nLevel,wait);
    a = Scales(m);                                   % 提取尺度参数                              
    t = -round(a*WinLen):1:round(a*WinLen);   
    Morl = pi^(-1/4)*exp(i*2*pi*0.5*t/a).*exp(-t.^2/2/(2*omg0*a)^2);   % 计算当前尺度下的小波函数
    temp = conv(Sig,Morl) / sqrt(a);                                                           % 计算信号与小波函数的卷积  
    WT(m,:) = temp(round(a*WinLen)+1:length(temp)-round(a*WinLen));  
   
end;
close(wait);

WT = WT / WinLen;