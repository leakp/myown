function r=inverse_fisherz(z);

% R=inverse_fisherz(Z)
%
% this function performs the inverse of a fisher Z-transform of vector Z
% and ouput a transformed vector R in the limit [-1;+1].
%
% see fisherz.m for the z to r transform
%
% Vincent MORON
% feb. 2005

r=(exp(2*z)-1)./(exp(2*z)+1);

