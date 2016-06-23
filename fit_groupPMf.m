out.params1    = NaN(4,4);
out.Likelihood = NaN(4,1);
out.ExitFlag   = NaN(4,1);
figure

cr=0;
for run = [1 2];
    for chain   = [1 2];        
        StimLevels = 0:11.25:170;
        x          = linspace(min(StimLevels),max(StimLevels),1000); % for plotting it later
        PropCorrectData = squeeze(nanmean(pdiff(:,chain,:,run),3));
        NumPosG   = round(PropCorrectData*100);%squeeze(nansum(NumPos(:,chain,:,run),3))';
        OutOfNumG = repmat(100,[16 1]);%squeeze(nansum(OutOfNum(:,chain,:,run),3))';
        % set initial params (taken from individual fits)
        searchGrid.alpha = 80;
        searchGrid.beta  = 2;%10.^pmf.beta(chain);
        searchGrid.gamma = PropCorrectData(1);% guessing rate at zero
        searchGrid.lambda = 1-PropCorrectData(end); %1 - final pdiff
        params0 = [ searchGrid.alpha  searchGrid.beta searchGrid.gamma searchGrid.lambda];
        
        PF         = @PAL_Weibull;
        
        %% run the Fit!
        options             = PAL_minimize('options');
        options.MaxIter     = 10.^6;
        options.MaxFunEvals = 10.^6;
        options.Display     = 'On';
        options.TolX        = 10.^-4;
        options.TolFun      = 10.^-4;
      
        funny = @(params) sum(-log (binopdf(NumPosG,OutOfNumG,PF(params,StimLevels))));       
        
        options         = optimset('Display','iter','maxfunevals',10000,'tolX',10^-12,'tolfun',10^-12,'MaxIter',10000,'Algorithm','interior-point');
        
        [o.params1, o.Likelihood, o.ExitFlag]  = fmincon(funny, params0, [],[],[],[],[-Inf -Inf 0 0],[Inf Inf 1 1],[],options);
        
        out.params1(chain+cr,:)    = o.params1;
        out.Likelihood(chain+cr,1) = o.Likelihood;
        out.ExitFlag(chain+cr,1)   = o.ExitFlag ;
%         out.subInd                 = subject;
        %% plot the Fit
        Fit = PF(o.params1,x);
%         maxn = 50; minn = 5;
%         dotsize  = squeeze(Scale(OutOfNumG)*(maxn-minn)+minn);

        subplot(2,2,chain+cr)
        hold on;
        plot(x,PF([searchGrid.alpha searchGrid.beta searchGrid.gamma searchGrid.lambda],x),'k:','Linewidth',3);
        plot(x,Fit,'r-','Linewidth',3);
        xlim([-5 180]);
        legend('InitialValues','New Fit','location','southeast')
        title(sprintf('Run %g, Chain %g, L = %03g',run,chain,o.Likelihood))
        for i = 1:length(StimLevels)
            plot(StimLevels(i),NumPosG(i)./OutOfNumG(i),'b.','Markersize',20,'MarkerFaceColor','b');
            hold on;
        end
        hold off;
        axis square
    end
cr=cr+2;
end
