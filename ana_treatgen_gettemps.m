function [target_temp,bsig] = ana_treatgen_gettemps(subject)
figure

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
nruns = 0;

for run = 1
    dummy = [];
    dummy_x = [];
    dummy_y = [];
    dummy_trial = [];
    path.experiment             = [path.baselocation 'Treatgen\'];
    subID                       = sprintf('sub%02d',subject);
    finalfile                   = [path.experiment 'data\calibration\' subID '_Session' num2str(run) '\stimulation\param_phase_0' num2str(run) '.mat'];
    try
        dummy = load(finalfile);
        nruns = nruns + 1;
        if mustbeconfirmed
            ind = dummy.p.log.ratings(:,4) == 1;
        else
            ind   = or((dummy.p.log.ratings(:,4) == 1),(dummy.p.log.ratings(:,4) ~= dummy.p.log.ratings(:,6))); %response must not have been confirmed, but shouldn't be init
        end
        dummy_y = dummy.p.log.ratings(ind,3);
        dummy_x = dummy.p.log.ratings(ind,1);
        dummy_trial = dummy.p.log.ratings(ind,2);
        if nruns ==1
            plot(dummy_x,dummy_y,'bo','MarkerFaceColor','b')
            hold on;
        elseif nruns ==2
            plot(dummy_x,dummy_y,'bs','MarkerFaceColor','b')
            hold on;
        end
    catch
        fprintf('Run %g not found.\n',run)
    end
    y = [y; dummy_y(:)];
    x = [x; dummy_x(:)];
    trial = [trial; dummy_trial(:)];
end
trialnum = length(y);
fprintf('Identified %g valid trials from %g run(s). \n',trialnum,nruns)
%%
% set params
target_vas = [30; 50; 70];

% estimate linear function
blin = [ones(numel(x),1) x]\y;
est_lin(1) = linreverse(blin,target_vas(1));
est_lin(2) = linreverse(blin,target_vas(2));
est_lin(3) = linreverse(blin,target_vas(3));


% estimate sigmoid function
a = mean(x); b = 1; % L = 0; U = 100; % l/u bounds to be fitted
beta0 = [a b];
options = statset('Display','final','Robust','on','MaxIter',10000);
[bsig,~] = nlinfit(x,y,@localsigfun,beta0,options);
est_sig(1) = sigreverse([bsig 0 100],target_vas(1));
est_sig(2) = sigreverse([bsig 0 100],target_vas(2));
est_sig(3) = sigreverse([bsig 0 100],target_vas(3));

% plot
xplot = linspace(min(x),max(x),100);
plot(xplot,localsigfun(bsig,xplot),'r',...
    est_sig,localsigfun(bsig,est_sig),'ro',est_lin,target_vas,'bd',...
    xplot,blin(1)+xplot.*blin(2),'b--');
xlim([min(xplot)-.5 max(xplot)+.5]); ylim([0 100]);

% display
target_temp = est_sig; %clc;
results = [trial x y];
disp(results);
fprintf(1,'estimates from sigmoidal fit (n=%d)\n\n',trialnum);
fprintf(1,'%g : %2.1f °C \tlinear: %2.1f °C\n',target_vas(1),target_temp(1),est_lin(1));
fprintf(1,'%g : %2.1f °C \tlinear: %2.1f °C\n',target_vas(2),target_temp(2),est_lin(2));
fprintf(1,'%g : %2.1f °C \tlinear: %2.1f °C\n',target_vas(3),target_temp(3),est_lin(3));

    function xsigpred = sigreverse(bsig1,ytarget)
        v=.5; a1 = bsig1(1); b1 = bsig1(2); L1 = bsig1(3); U1 = bsig1(4);
        xsigpred = a1 + 1/-b1 * log((((U1-L1)/(ytarget-L1))^v-1)./v);
    end

    function xlinpred = linreverse(blin1,ytarget)
        a1 = blin1(1); b1 = blin1(2);
        xlinpred = (ytarget - a1) / b1;
    end
    
end