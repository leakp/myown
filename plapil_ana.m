csps = g.getcsp;
csps = Vectorize(repmat(csps,[3 1]));
M = fix.maps;
figure
for n = 1:18
    subplot(6,3,n);
    imagesc(imread(p.find_stim(csps(n))));
    hold on;
    axis square
    axis off
    [d u] = GetColorMapLimits(M(:,:,n),7)
    h = imagesc(M(:,:,n),[d u])
    set(h,'alphaData',Scale(abs((M(:,:,n))))*.9+.1);
end


%% PMF
p = Project;
subjects = 1:6;
tsubs = length(subjects);
NumPos = nan(16,2,tsubs);
OutOfNum = nan(16,2,tsubs);
pdiff = nan(16,2,tsubs);

figure;
sc = 0;
for sub = subjects(:)'
    sc = sc + 1;
    fprintf('Working on Subject No %d, %d / %d...\n',sub,sc,tsubs)
    s = Subject(sub);
    for chain = 1:2
        i = ~isnan(s.load_paradigm(5).psi.log.xrounded(1:16,1,chain));
        NumPos(i,chain,sc) = nansum(s.load_paradigm(5).psi.log.xrounded(i,:,chain),2);
        OutOfNum(i,chain,sc)  = nansum(~isnan(s.load_paradigm(5).psi.log.xrounded(i,:,chain)),2);
        pdiff(:,chain,sc) = NumPos(:,chain,sc)./OutOfNum(:,chain,sc);
        alpha(chain,sc) = s.load_paradigm(5).psi.log.alpha(chain,end);
        beta(chain,sc) = s.load_paradigm(5).psi.log.alpha(chain,end);
        gamma(chain,sc) = s.load_paradigm(5).psi.log.gamma(chain,end);
        lambda(chain,sc) = s.load_paradigm(5).psi.log.lambda(chain,end);
    end
    subplot(6,1,sc)
    xhd = linspace(0,90,1000);
    plot(s.load_paradigm(5).psi.stimRange,pdiff(:,1,sc),'ro','MarkerFaceColor','r')
    hold on;
    plot(xhd,PAL_Weibull([alpha(1,sc) beta(1,sc) gamma(1,sc) lambda(1,sc)],xhd),'r','LineWidth',2)
    plot(s.load_paradigm(5).psi.stimRange,pdiff(:,2,sc),'co','MarkerFaceColor','c')
    plot(xhd,PAL_Weibull([alpha(2,sc) beta(2,sc) gamma(2,sc) lambda(2,sc)],xhd),'c','LineWidth',2)
    xlim([min(xhd)-10 max(xhd)+10])
    ylim([0 1])
    ylabel('p(different')
    %     xlabel('Stim Intensity (deg)')
    %     title(sprintf('subject %d',s.id))
    set(gca,'XTick',s.load_paradigm(5).psi.stimRange(1:9),'YTick',0:.5:1)
    savepath = sprintf('%spmf%s',p.pathfinder(s.id,5),filesep);
    if exist(savepath)==0
        mkdir(savepath)
    end
    hold off
    %     SaveFigure(sprintf('%sPAlsPMF_90.png',savepath))
    % close all
end
xlabel('Stim Intensity (deg)')

%% show fixmat for phase 5, only CS+
% v=[];c=0;for sub = 1:6;for ph = [5];c=c+1;v{c} = {'subject' sub 'phase' ph 'deltacsp' 18000};end;end

figure
for s = 1:6
    cs = g.subject{s}.csn;
    cond = 18000;
    fix.getmaps({'subject' s 'phase' 5 'deltacsp' cond})
    subplot(6,1,s);
    imagesc(imread(p.find_stim(cs)));
    hold on;
    axis image;
    axis off
    box off
    [d u] = GetColorMapLimits(fix.maps,7);
    if any(isnan([d u]))
        d = 0;
        u = 1;
    end
    h     = imagesc(fix.maps,[d u]);
    set(h,'alphaData',Scale(abs((fix.maps)))*.9+.1);
end

%% correct incorrect (CS+ only)
p = Project;
figure
for sub = [1 2 3 4 6 6];
    s = Subject(sub);
    cond = 0;
    cs = s.csp;
    dummy = [s.load_paradigm(5).psi.log.response(1,:)' s.load_paradigm(5).psi.log.signal(1,:)' s.load_paradigm(5).psi.log.globaltrial(1,:)'];
    cortrials = dummy(dummy(:,1)~=dummy(:,2),3);
    fixtrial = [cortrials(:)*2;cortrials(:)*2-1];
    fix = Fixmat(sub,5);
    fix.getmaps({'deltacsp' cond 'trialid' fixtrial})
    subplot(6,1,sub);
    imagesc(imread(p.find_stim(cs)));
    hold on;
    axis image;
    axis off
    box off
    [d u] = GetColorMapLimits(fix.maps,7);
    if any(isnan([d u]))
        d = 0;
        u = 1;
    end
    h     = imagesc(fix.maps,[d u]);
    set(h,'alphaData',Scale(abs((fix.maps)))*.9+.1);
end