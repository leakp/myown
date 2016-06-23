clear all
p = Project;
subs = intersect(p.subjects_1500,find(p.getMask('ET_feargen')));
fix = Fixmat(subs,[2 4]);

correct = 1;
tfix = 5;
corrmat = nan(80,80,length(subs));

sc = 0;
for sub = unique(fix.subject)
    sc = sc+1;
    v = [];
    c = 0;
    for ph = unique(fix.phase)
        
        for nfix = 1:tfix
            for cond = fix.realcond
                c = c+1;
                v{c} = {'subject' sub 'phase' ph 'deltacsp' cond 'fix' nfix};
                
            end
        end
    end
    fix.getmaps(v{:})
     if correct == 1
        %correct phase specific cocktail blank
        fix.maps(:,:,1:40) = fix.maps(:,:,1:40) - repmat(mean(fix.maps(:,:,1:40),3),[1 1 40]);
        fix.maps(:,:,41:end) = fix.maps(:,:,41:end) - repmat(mean(fix.maps(:,:,41:end),3),[1 1 40]);
    end
    corrmat(:,:,sc) = fix.corr;
end

imagesc(reshape(ifisherz(nanmedian(reshape(fisherz( corrmat),[80 80 length(unique(fix.subject))]),3)),[80 80]))
axis square
box off
set(gca,'XTick',[4:8:80],'XTickLabel',{'1' '2' '3' '4' '5' '1' '2' '3' '4' '5'})
set(gca,'YTick',[4:8:80],'YTickLabel',{'1' '2' '3' '4' '5' '1' '2' '3' '4' '5'})