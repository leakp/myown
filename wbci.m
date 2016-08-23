function out = wbci(variable,varargin)
% computes a credible interval from samples drawn by Winbugs
% LK, 16 August 2016, winbugs/jags course
if nargin < 2
    cred = .95;
else
    cred = varargin{:};
end

b1 = (1-cred)/2;b2=1-b1;
val = sort(reshape(variable,1,[]));
out(1) = val(round(b1*length(variable(:))));
out(2) = val(round(b2*length(variable(:))));
disp(sprintf('%d percent credible interval is [%1.2f, %1.2f]',cred*100,out(1),out(2)));

end
