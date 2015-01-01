function [Y,V,E,D]=leonPCA(X,n)
%% Description of the leonPCA function
% This funcation calculate the n-dimensions feature of the input Signal
% Input:
%   Sig: The input signal
%   n:   The dimensions of the PCA transfer
% Output:
%   Y:   The project matrix of the input data X without whiting
%   V:   Whitening matrix
%   E:   Principal component transformation (orthogonal)
%   D:   Variances of the principal components

% Written by Liang Guo
% 2015-01-01
% guoliang2248@gmail.com

%% Remove the DC part of the input signal
X = X - ones(size(X,1),1)*mean(X);

%% Calculate the eigenvalues and eigenvectors of the new covariance matrix.
covarianceMartix = X*X'/size(X,2);

[E,D]=eig(covarianceMartix);

%% Sort teh eigenvalues and recompute matrices
[dummy, order] = sort(diag(-D));
E = E(:,order);
Y = E'*X;
d = diag(D);
dsqrtinv = real(d.^(-0.5));
Dsqrtinv = diag(dsqrtinv(order));
D = diag(d(order));
V = Dsqrtinv*E';
end