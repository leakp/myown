function ana_treatgen_calib(subject)
%ana_calib
[p,target_temp,bsig,est_sig,est_lin] = ana_treatgen_gettemps(subject);
figure(100)
subplot(1,4,1)
x = p.log.ratings(:,1);
y = p.log.ratings(:,3);
ind = or((p.log.ratings(:,4) == 1),(p.log.ratings(:,3) ~= p.log.ratings(:,6)));
plot(x,y,'ko','MarkerFaceColor','k')
ylabel('VAS Relief / Pain')
xlabel('Temp C')
title('Raw Ratings','FontSize',14)
box off
%%
subplot(1,4,2)
ys = (y + 100)./(100+100); %transform it to [0 1] so that sigfun can deal with it
plot(x,ys,'ko','MarkerFaceColor','k');hold on;

% set params
target_vas = [60 -30 -50];
target_vass = (target_vas -(-(p.rating.division - 1)./2))./(p.rating.division-1);xplot = linspace(min(x),max(x),100);
ind = ~isnan(p.log.ratings(:,3));
blin = [ones(numel(x(ind)),1) x(ind)]\ys(ind);

xplot = linspace(min(x),max(x),100);
plot(xplot,localsigfun(bsig,xplot),'r',...
    est_sig,localsigfun(bsig,est_sig),'ro',est_lin,target_vass,'bd',...
    xplot,blin(1)+xplot.*blin(2),'b--');
xlim([min(xplot)-.5 max(xplot)+.5]);
title('Fit','FontSize',14)
box off
%% file from exp phase == 0
path.experiment             = 'C:\Users\Lea\Documents\Experiments\Treatgen\';
finalfile                   = [sprintf('%s',path.experiment) 'data\sub' sprintf('%03d',subject) '_p00\stimulation\data.mat'];
bla = load(finalfile); p = bla.p;
subplot(1,4,3)
plot([1 1],p.log.ratings.tensdemo([1 3],3),'bo','MarkerFaceColor','b')
hold on;
errorbar(1,mean(p.log.ratings.tensdemo([1 3],3)),std(p.log.ratings.tensdemo([1 3],3)),'bx','LineWidth',2)
plot([2 2],p.log.ratings.tensdemo([2 4],3),'bo','MarkerFaceColor','b')
errorbar(2,mean(p.log.ratings.tensdemo([2 4],3)),std(p.log.ratings.tensdemo([2 4],3)),'bx','LineWidth',2)
ylim([-100 100])
ylabel('VAS Relief')
set(gca,'XTick',[1 2],'YTick',-100:20:0,'XTickLabel',{'Tens off' 'Tens on'})
title('TENS Demo','FontSize',14)
xlim([0 3])
box off

subplot(1,4,4)
plot([0 nan(1,6) 9],p.log.ratings.pain(:,3),'ro','MarkerFaceColor','r');
hold on
plot(p.log.ratings.relief(:,2),p.log.ratings.relief(:,3),'b-o','MarkerFaceColor','b');
ylabel('VAS Relief / Pain')
xlabel('Trial')
title('Face Demo','FontSize',14)
box off

supertitle('subject %03d',subject)

    function xsigpred = sigreverse(bsig1,ytarget)
        v=.5; a1 = bsig1(1); b1 = bsig1(2); L1 = bsig1(3); U1 = bsig1(4);
        xsigpred = a1 + 1/-b1 * log((((U1-L1)/(ytarget-L1))^v-1)./v);
    end

    function xlinpred = linreverse(blin1,ytarget)
        a1 = blin1(1); b1 = blin1(2);
        xlinpred = (ytarget - a1) / b1;
    end

end