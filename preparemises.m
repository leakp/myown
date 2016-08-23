p = Project;
g = Group(sort([Project.subjects_1500 Project.subjects_600]));
g.getSI(8);
valid = prod([g.tunings.rate{3}.pval;g.tunings.rate{4}.pval] > -log10(.05)); %both fits have to be accurate
sum(valid)
misesmat = nan(65,5);
for n = find(valid)
    misesmat(g.ids(n),1) = g.tunings.rate{3}.singlesubject{n}.Est(2);
    misesmat(g.ids(n),2) = g.tunings.rate{4}.singlesubject{n}.Est(2);
    misesmat(g.ids(n),3) = g.tunings.rate{4}.singlesubject{n}.Est(2) - g.tunings.rate{3}.singlesubject{n}.Est(2);
    misesmat(g.ids(n),4) = g.tunings.rate{3}.singlesubject{n}.Est(3);
    misesmat(g.ids(n),5) = g.tunings.rate{4}.singlesubject{n}.Est(3);
end
subjects = g.ids;
[mat tags] = g.parameterMat;
mat = [mat g.loadmises];
invalid = ~ismember(subjects,find(sum(p.getMask('PMF'),2) == 4));
mat(invalid,1:11) = NaN;
mat = [mat nan(length(mat),4)];

mat(:,17) = mean(mat(:,[1 3]),2);
for n = 1:length(mat)
    if ~isnan(mat(n,12))
        mat(n,18) = vM2FWHM(mat(n,12));
    end
    if ~isnan(mat(n,13))
        mat(n,19) = vM2FWHM(mat(n,13));
    end
    mat(n,20) = mat(n,18) - mat(n,19);
end

%now kill ~rate
ind = isnan(mat(:,12));mat(ind,:)=[];subjects(ind) = [];
subs15 = logical(ismember(subjects,p.subjects_1500));
subs6 = logical(ismember(subjects,p.subjects_600));


%% new alphas
clear all
p = Project;
subjects = intersect(sort([Project.subjects_1500 Project.subjects_600]),find(sum(p.getMask('PMF'),2)==4));
g = Group(subjects);

crit = .5;
params = nan(4,4,length(g.ids));
alpha  = nan(length(g.ids),4);
for sub = 1:length(g.ids)
    fprintf('sub %d \n',sub)
    for n = 1:4
    guess = g.subject{sub}.pmf.params1(n,3);
    lapse = g.subject{sub}.pmf.params1(n,4);
    alpha(sub,n) = PAL_Weibull(g.subject{sub}.pmf.params1(n,:),(1-lapse-guess)*crit+guess,'inverse');
    end
%     params(:,:,sub) = g.subject{sub}.pmf.params1;
end

%sanity check: is this alpha (put crit = .63)
[r,pval] = corr(alpha(:,1),g.pmf.csp_before_alpha);
init_alpha = mean(alpha(:,1:2),2);


%% load any matrix
load('C:\Users\Lea\Documents\Experiments\FearCloud_Eyelab\data\midlevel\rate2pmf_N54.mat')
%add the new alphas.
g = Group(subjects);
crit = .5;
alpha  = nan(length(subjects),4);
for sub = 1:length(g.ids)
    for n = 1:4
    guess = g.subject{sub}.pmf.params1(n,3);
    lapse = g.subject{sub}.pmf.params1(n,4);
    alpha(sub,n) = PAL_Weibull(g.subject{sub}.pmf.params1(n,:),(1-lapse-guess)*crit+guess,'inverse');
    end
end
%resort to our usual logic
alpha = alpha(:,[1 3 2 4]);
tags{21} = 'CSP_before_a50';
tags{22} = 'CSP_after_a50';
tags{23} = 'CSN_before_a50';
tags{24} = 'CSN_after_a50';

mat = [mat alpha];
%take away nans
ind = isnan(mat(:,1));
mat(ind,21:end) = nan;
