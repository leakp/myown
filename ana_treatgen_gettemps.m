function [p,target_temp,bsig,est_sig,est_lin] = ana_treatgen_gettemps(subject)

mustbeconfirmed = 0;
%% load calib data
[~, hostname] = system('hostname');
hostname                    = deblank(hostname);
if strcmp(hostname,'triostim1')
    path.baselocation       = 'C:\USER\kampermann\Experiments\';
elseif strcmp(hostname,'isn3464a9d59588')%Lea's HP
    path.baselocation       = 'C:\Users\Lea\Documents\Experiments\';
else
    error('Unknown PC found, please define it for folder structure.')
end

y     = [];
x     = [];
trial = [];

path.experiment             = [path.baselocation 'Treatgen\'];
subID                       = sprintf('sub%03d',subject);
finalfile                   = [path.experiment 'data\calibration\' subID '_Session1\stimulation\param_phase_01.mat'];
try
    dummy = load(finalfile);
    p = dummy.p;
catch
    fprintf('Calibration data not found.\n')
end
if mustbeconfirmed
    ind = p.log.ratings(:,4) == 1;
else
    ind   = or((p.log.ratings(:,4) == 1),(p.log.ratings(:,4) ~= p.log.ratings(:,6))); %response must not have been confirmed, but shouldn't be init
end
y = p.log.ratings(ind,3);
x = p.log.ratings(ind,1);
trial = p.log.ratings(ind,2);

trialnum = length(y);
fprintf('Identified %g valid trials. \n',trialnum)

ys = (y + 100)./(100+100); %transform it to [0 1] so that sigfun can deal with it
plot(x,ys,'bo','MarkerFaceColor','b');hold on;
%%
% set params
target_vas = [60 -30 -50];
target_vass = (target_vas -(-(p.rating.division - 1)./2))./(p.rating.division-1);

% estimate linear function
ind = ~isnan(p.log.ratings(:,3));
blin = [ones(numel(x(ind)),1) x(ind)]\ys(ind);
est_lin(1) = linreverse(blin,target_vass(1));
est_lin(2) = linreverse(blin,target_vass(2));
est_lin(3) = linreverse(blin,target_vass(3));


% estimate sigmoid function
a = mean(x); b = 1; L = min(ys); U = max(ys); % l/u bounds to be fitted
beta0 = [a b L U];
options = statset('Display','final','Robust','on','MaxIter',10000);
[bsig,~] = nlinfit(x,ys,@localsigfun,beta0,options);
est_sig(1) = sigreverse(bsig,target_vass(1));
est_sig(2) = sigreverse(bsig,target_vass(2));
est_sig(3) = sigreverse(bsig,target_vass(3));
imagind = find(imag(est_sig));
if any(imagind)
    warning('Complext Est Sig detected!')
end
% plot
xplot = linspace(min(x),max(x),100);
plot(xplot,localsigfun(bsig,xplot),'r',...
    est_sig,localsigfun(bsig,est_sig),'ro',est_lin,target_vass,'bd',...
    xplot,blin(1)+xplot.*blin(2),'b--');
xlim([min(xplot)-.5 max(xplot)+.5]);
ylim([0 1]);

% display
target_temp = est_sig; %clc;
results = [trial x y];
disp(results);
fprintf(1,'estimates from sigmoidal fit (n=%d)\n\n',trialnum);
fprintf(1,'%g : %2.1f °C \tlinear: %2.1f °C\n',target_vas(1),target_temp(1),est_lin(1));
fprintf(1,'%g : %2.1f °C \tlinear: %2.1f °C\n',target_vas(2),target_temp(2),est_lin(2));
fprintf(1,'%g : %2.1f °C \tlinear: %2.1f °C\n',target_vas(3),target_temp(3),est_lin(3));

p.presentation.calib_est = [est_sig; est_lin];
p.presentation.calib_target_vas;
    function xsigpred = sigreverse(bsig1,ytarget)
        v=.5; a1 = bsig1(1); b1 = bsig1(2); L1 = bsig1(3); U1 = bsig1(4);
        xsigpred = a1 + 1/-b1 * log((((U1-L1)/(ytarget-L1))^v-1)./v);
    end

    function xlinpred = linreverse(blin1,ytarget)
        a1 = blin1(1); b1 = blin1(2);
        xlinpred = (ytarget - a1) / b1;
    end
end