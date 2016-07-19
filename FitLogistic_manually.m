function [o] = FitLogistic_manually(X,Y)
%there should be no NaN values on the X and Y vectors.
%%
visualization = 0;

%% make sure we have columns
X        = X(:);
Y        = Y(:);
CONSTANT = 0;%will be add to all the data points 

PF         = @PAL_CumulativeNormal;
%% set initial params
o.fitfun = @(X,p) PF(p,X);%alpha,beta,gamma,lapse
o.L             = [ 0     .01      0        0          eps];
o.U             = [ 80    .2       1        1        std(Y)];
o.dof    = 3;
o.funname= 'PAL_CumulativeNormal';
   
%% set the objective function
o.funny  = @(params) sum(-log( normpdf(Y - o.fitfun( X,params(1:end-1)) , 0,params(end)) ));

%% Initial estimation of the parameters
%make a grid-estimatation
o.Init = RoughEstimator(X,Y,o.funname,o.L,o.U)';
o.Init = o.Init + eps;
%
%% once we have the rough parameter values, create a sigma grid, and
% estimate the sigma as well.
tsample = 10000;
sigmas  = linspace(0.001,std(Y)*3,tsample);
% alternative method: based on the likelihood of sigma given the data points assuming a Gaussian normal distribution.
PsigmaGiveny = sigmas.^-length(Y) .* exp( - (1./(2.*sigmas.^2) ) .* sum((Y - o.fitfun(X,o.Init)).^2) );
[m i]        = max(PsigmaGiveny);
o.Init   = [o.Init sigmas(i)];
%
%% Optimize!
%fmincon is preferable as it minimizes the function and not its square
%as lsqnonln etc...

%set optim options
options         = optimset('Display','off','maxfunevals',1000,'tolX',10^-12,'tolfun',10^-12,'MaxIter',1000,'Algorithm','interior-point');
try
    [o.Est, o.Likelihood, o.ExitFlag]  = fmincon(o.funny, o.Init, [],[],[],[],o.L,o.U,[],options);
    o.Likelihood = o.funny(o.Est);
catch
    o.Est         = o.Init;
    o.Likelihood = o.funny(o.Est);
    o.ExitFlag   = 1;   
end


%% produce the fit with the estimated parameters

o.xsup                = linspace(o.L(1),o.U(1),1000);
o.fitup             = o.fitfun( o.xsup   , o.Est)+CONSTANT;

if visualization
    plot(X,Y,'o')
    hold on;
    plot(o.xsup,o.fitfun(o.xsup,o.Est),'r')
    hold off
    drawnow;
end