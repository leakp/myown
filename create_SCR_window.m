%% search windows
subs = find(sum(p.getMask('SCR'),2)==3);

for sub = subs(:)'
    f=figure(100);
    clf
    SetFearGenColors;
    subplot(1,2,1)
    s = Subject(sub);
    s.scr.cut(s.scr.findphase('cond$'));
    s.scr.run_ledalab;
    plot(s.scr.ledalab.mean(1:800,1),'Color','r','LineWidth',2);hold on;
    plot(s.scr.ledalab.mean(1:800,2),'Color','c','LineWidth',2);
    plot(s.scr.ledalab.mean(1:800,3),'Color','k','LineWidth',2);
    line([250 250],ylim)
    line([500 500],ylim,'LineStyle',':');
    line([550 550],ylim)
    clear s
    s = Subject(sub);
    s.scr.cut(s.scr.findphase('test$'));
    s.scr.run_ledalab;
    subplot(1,2,2)
    plot(s.scr.ledalab.mean(1:800,1:9),'LineWidth',2);hold on;
    line([250 250],ylim)
    line([500 500],ylim,'LineStyle',':');
    line([550 550],ylim)
    clear s
    supertitle('sub %d',sub)
    pause
end
%% look at graphs for B-C-T and mean([1:8 11]), and mean([1:8 11])-null
for ns =1:1000;
    clf
    for n = 1:3;
        SetFearGenColors;
        subplot(3,3,n)
        plot(squeeze(scr_data(ns,:,[1:9],n)));
        hold on;
    end;
    subplot(3,3,4:6)
    for n = 1:3
    plot(squeeze(nanmean(scr_data(ns,:,[1:8 11],n),3)),'color',[n/3 0 1-n/3]);
    hold on
    end
    ylabel('mean [1:8 11]')
    subplot(3,3,7:9)
    for n = 1:3
        data = squeeze(nanmean(scr_data(ns,:,[1:8 11],n),3));
        null = squeeze(nanmean(scr_data(ns,:,[9],n),3));
        bla = data - null;
        plot(bla,'color',[n/3 0 1-n/3]);
        hold on
    end
    ylabel('mean [1:8 11] - null')
    supertitle(mat2str(subjects(ns)));    
    pause;
end

%%
mask = NaN(65,800);
a=...
[1   NaN NaN;
2   NaN NaN;
3   NaN NaN;
4   NaN NaN;
5   NaN NaN;
6   300 600;
7   260 600;
8   250 550;
9   250 550;
10  280 520;
11  250 550;
12  250 550;
13  250 550;
14  300 550;
15  200 600;
16  300 550;
17  300 600;
18  300 600;
19  250 550;
20  NaN NaN;
21  300 650;
22  250 500;
23  300 600;
24  250 550;
25  250 550;
26  250 550;
27  200 500;
28  300 550;
29  250 600;
30  300 600;
31  250 550;
32  300 600;
33  250 550;
34  250 550;
35  200 550;
36  NaN NaN;
37  150 500;
38  200 500;
39  300 600;
40  230 530;
41  250 550;
42  250 550;
43  150 500;
44  250 600;
45  150 500;
46  250 550;
47  150 500;
48  150 450;
49  150 450;
50  200 500;
51  250 550;
52  200 500;
53  200 520;
54  200 550;
55  200 550;
56  200 550;
57  200 550;
58  200 550;
59  200 500;
60  150 500;
61  200 520;
62  150 500;
63  150 500;
64  200 550;
65  150 500];
for n= 1:length(a)
    if ~isnan(a(n,2))
    mask(a(n,1),a(n,2)+1:a(n,3))=1;
    end
end
scr_bars_new = NaN(length(subjects),9,3);
for ph=1:3
    for n=1:58
        scr_bars_new(n,:,ph)= mean(scr_data(n,logical(mask(subjects(n),:)),1:9,ph),2);
    end
end

figure;
dendros = find(ismember(subjects0,subjects));
sc=0;
for ind=dendros(:)'
    sc=sc+1;
    subplot(5,6,sc)
    b=bar(1:8,scr_bars_new(ind,1:8,3));
    SetFearGenBarColors(b);
end

scr_bars_dendro = scr_bars_new(dendros,:,:);



%% Lea's manual windows
mask = NaN(65,800,3);
a=[
1   NaN NaN NaN NaN;
2   NaN NaN NaN NaN;
3   NaN NaN NaN NaN;
4   NaN NaN NaN NaN;
5   NaN NaN NaN NaN;
6   300 600 250 550;
7   250 550 300 600;
8   250 550 250 550;
9   250 550 250 550;
10  250 550 250 550;
11  200 500 200 500;
12  250 550 250 550;
13  250 550 250 550;
14   50 350  50 350;
15  250 550 250 550;
16  250 550 250 550;
17  250 550 250 550;
18  100 400 150 450;
19  250 550 250 550;
20  NaN NaN NaN NaN;
21  300 600 300 600;
22  250 550 250 550;
23   50 350  50 350;
24  250 550 250 550;
25  200 500 200 500;
26  250 550 250 550;
27  200 500 200 500;
28  250 550 250 550;
29  250 550 250 550;
30  250 550 350 650;
31  250 550 250 550;
32   70 370  70 370;
33  250 550 250 550;
34  250 550 250 550;
35  200 500 200 500;
36  NaN NaN NaN NaN;
37  200 500 200 500;
38  200 500 250 550;
39  250 550 250 550;
40  200 500 200 500;
41  250 550 250 550;
42  250 550 250 550;
43  200 500 200 500;
44  250 550 250 550;
45  180 480 180 480;
46  250 550 300 600;
47  150 450 150 450;
48  150 450 150 450;
49  150 450 150 450;
50  170 470 250 550;
51  250 550 250 550;
52  200 500 200 500;
53  200 500 200 500;
54  200 500 200 500;
55  200 500 250 550;
56  200 500 200 500;
57  200 500 200 500;
58  250 550 250 550;
59  200 500 200 500;
60  200 500 200 500;
61  200 500 200 500;
62  200 500 200 500;
63  150 450 150 450;
64  250 550 250 550;
65  150 450 170 470];
for n= 1:length(a)
    if ~isnan(a(n,2))
    mask(a(n,1),a(n,2)+1:a(n,3),2)=1;
    mask(a(n,1),a(n,4)+1:a(n,5),3)=1;
    end
end

%check again
subs = [6 7 12 16 17 18 21 22 23 32 39 41 47 51 57 65];

%% see if windows (in a) fit the curves well
load('C:\Users\user\Documents\Experiments\FearCloud_Eyelab\data\midlevel\scr_fordendroN27.mat','subjects')
subjects = subjects(1:end-1);%bc last one without SCR
figure;
for n=1:26
    subplot(5,6,n)
    s = Subject(subjects(n));
    fprintf('Working on subject %d .. \n',n)
    s.scr.cut(s.scr.findphase('cond$'));
    s.scr.run_ledalab;
    plot(s.scr.ledalab.mean(1:800,1),'Color','r','LineWidth',2);hold on;
    plot(s.scr.ledalab.mean(1:800,2),'Color','c','LineWidth',2);hold on;
    plot(s.scr.ledalab.mean(1:800,3),'Color','k','LineWidth',2);hold on;
    ha=area([a(subjects(n),2) a(subjects(n),3)],[max(ylim) max(ylim)]);alpha(.5);%testphase    
    title(sprintf('sub %d',subjects(n)))
end
    
figure;
for n=1:26
    subplot(5,6,n)
    s = Subject(subjects(n));
    fprintf('Working on subject %d .. \n',n)
    s.scr.cut(s.scr.findphase('test$'));
    s.scr.run_ledalab;
    SetFearGenColors;
    plot(s.scr.ledalab.mean(1:800,1:8),'LineWidth',2);hold on;
    plot(s.scr.ledalab.mean(1:800,9),'k','LineWidth',2);
    ha=area([a(subjects(n),4) a(subjects(n),5)],[max(ylim) max(ylim)]);alpha(.5);%testphase    
    title(sprintf('sub %d',subjects(n)))
end

%%
phasenames = {'base$' 'cond$' 'test$'};
phaseconds = [11 5 11];
subjects = find(sum(p.getMask('SCR'),2)==3);
scr_data = NaN(length(subjects),800,11,3);

for ph = 1:3
    sc = 0;
    for sub = subjects(:)'
        fprintf('Working on phase %d, subject %d .. \n',ph,sub)
        sc=sc+1;
        s = Subject(sub);
        s.scr.cut(s.scr.findphase(phasenames{ph}));
        s.scr.run_ledalab;        
        if ph==1
            scr_data(sc,:,:,ph) = s.scr.ledalab.mean(1:800,1:11);
        elseif ph==2
            scr_data(sc,:,[4 8 9 10 11],ph) = s.scr.ledalab.mean(1:800,1:5);
        elseif ph==3
            scr_data(sc,:,:,ph) = s.scr.ledalab.mean(1:800,1:11);
        end
        close all
        clear s
    end
end

%%
phasenames = {'base$' 'cond$' 'test$'};
phaseconds = [9 3 9];
scr_bars = NaN(length(subjects),9,3);
for ph = 1:3
    sc = 0;
    for sub = subjects(:)'
        fprintf('Working on phase %d, subject %d .. \n',ph,sub)
        sc=sc+1;
        s = Subject(sub);
        s.scr.cut(s.scr.findphase(phasenames{ph}));
        s.scr.run_ledalab;        
        if ph==1
            scr_bars(sc,:,ph) = mean(s.scr.ledalab.mean(mask(sub,:,1)));
        elseif ph==2
            scr_bars(sc,[4 8 9],ph) = mean(s.scr.ledalab.mean(mask(sub,:,2)));
        elseif ph==3
            scr_bars(sc,:,ph) = mean(s.scr.ledalab.mean(mask(sub,:,3)));
        end
        close all
        clear s
    end
end