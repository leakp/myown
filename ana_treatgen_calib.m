function ana_treatgen_calib(subject)
%ana_calib
run = 1;
path.baselocation       = 'C:\Users\Lea\Documents\Experiments\';
path.experiment             = [path.baselocation 'Treatgen\'];
subID                       = sprintf('sub%03d',subject);
finalfile                   = [path.experiment 'data\calibration\' subID '_Session' num2str(run) '\stimulation\param_phase_0' num2str(run) '.mat'];
bla = load(finalfile);
p = bla.p;
subplot(1,3,1)
x = p.log.ratings(:,1);
y = p.log.ratings(:,3);
ind = or((p.log.ratings(:,4) == 1),(p.log.ratings(:,3) ~= p.log.ratings(:,6)));
plot(x,y,'bo','MarkerFaceColor','b')
ylim([0 100])
set(gca,'YColor','r')
ylabel('VAS Pain')
xlabel('Temp C')
a = mean(x); b = 1; % L = 0; U = 100; % l/u bounds to be fitted
beta0 = [a b];
options = statset('Display','final','Robust','on','MaxIter',10000);
[bsig,~] = nlinfit(x,y,@localsigfun,beta0,options);
est_sig(1) = sigreverse([bsig 0 100],70);
est_sig(2) = sigreverse([bsig 0 100],50);
est_sig(3) = sigreverse([bsig 0 100],30);
hold on;
xplot = linspace(min(x),max(x),100);
plot(xplot,localsigfun(bsig,xplot),'r',...
    est_sig,localsigfun(bsig,est_sig),'ro','LineWidth',2);
xlim([min(xplot)-.5 max(xplot)+.5]); ylim([0 100]);
title('Calibration','FontSize',14)
box off
%% file from exp phase == 0
finalfile                   = [sprintf('%s',path.experiment) 'data\sub' sprintf('%03d',subject) '_p00\stimulation\data.mat'];
bla = load(finalfile); p = bla.p;
subplot(1,3,2)
plot([1 1],p.log.ratings.tensdemo([1 3],3),'bo','MarkerFaceColor','b')
hold on;
errorbar(1,mean(p.log.ratings.tensdemo([1 3],3)),std(p.log.ratings.tensdemo([1 3],3)),'bx','LineWidth',2)
plot([2 2],p.log.ratings.tensdemo([2 4],3),'bo','MarkerFaceColor','b')
errorbar(2,mean(p.log.ratings.tensdemo([2 4],3)),std(p.log.ratings.tensdemo([2 4],3)),'bx','LineWidth',2)
ylim([0 100])
ylabel('VAS Relief')
set(gca,'YColor','b')
set(gca,'XTick',[1 2],'YTick',0:20:100,'XTickLabel',{'Tens off' 'Tens on'})
title('TENS Demo','FontSize',14)
xlim([0 3])
box off

subplot(1,3,3)
[ax h1 h2] = plotyy(p.log.ratings.pain(:,2),p.log.ratings.pain(:,3),p.log.ratings.relief(:,2),p.log.ratings.relief(:,3));
set(h1(1),'Color','r','Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',2)
set(h2(1),'Color','b','Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',2)
set(ax(1),'YColor','r','XLim',[0 9],'XTick',1:8,'YLim',[0 100],'YTick',0:20:100)
set(get(gca,'YLabel'),'String','VAS Pain','FontSize',12)
set(ax(2),'YColor','b','XLim',[0 9],'XTick',1:8,'YLim',[0 100],'YTick',0:20:100)
set(get(ax(2),'YLabel'),'String','VAS Relief','FontSize',12)
xlabel('Trial')
title('Face Demo','FontSize',14)


    function xsigpred = sigreverse(bsig1,ytarget)
        v=.5; a1 = bsig1(1); b1 = bsig1(2); L1 = bsig1(3); U1 = bsig1(4);
        xsigpred = a1 + 1/-b1 * log((((U1-L1)/(ytarget-L1))^v-1)./v);
    end

    function xlinpred = linreverse(blin1,ytarget)
        a1 = blin1(1); b1 = blin1(2);
        xlinpred = (ytarget - a1) / b1;
    end

end