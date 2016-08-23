clear all;
p = Project;
load('C:/Users/Lea/Dropbox/feargen_hiwi/EthnoMaster/data/midlevel/rate_and_pmf_N48.mat')
load('C:\Users\Lea\Documents\Experiments\FearCloud_Eyelab\data\midlevel\scr_beneficial_locations.mat')
subs = intersect(find(p.getMask('ET_feargen').*p.getMask('ET_discr')),subjects(subs15));
fix  = Fixmat(subs,1:5);

g = Group(subs);
mat = g.parameterMat; mises = g.loadmises;
mat = [mat mises nan(length(mat),4)];
mat(:,17) = mean(mat(:,[1 3]),2);
for n = 1:length(mat)
    mat(n,18) = vM2FWHM(mat(n,12));
    mat(n,19) = vM2FWHM(mat(n,13));
    mat(n,20) = mat(n,18)-mat(n,19);
end
%
M = [];
for ns = unique(fix.subject)    
    query = {'subject' ns 'phase' 1:5 'deltacsp' [0 180 18000]};    
    fix.getmaps(query);
    M     = cat(3,M,fix.maps);
end
%

a    = mat(:,17);
b    = mat(:,19);
c    = [scrz(4,:) - scrz(8,:)]';
d    = mat(:,11);
e    = mat(:,20);
f    = mean(scr)';
% % exclude sub 46 bc no usable eye data
% a(8) = [];
% b(8) = [];
%
fix.maps = M;
type = 'Spearman';
[r_a, p_a]     = corr(fix.vectorize_maps',a,'Type',type);
[r_b, p_b]     = corr(fix.vectorize_maps',b,'Type',type);
[r_c, p_c]     = corr(fix.vectorize_maps',c,'Type',type);

[r_d, p_d]     = corr(fix.vectorize_maps',d,'Type',type);
[r_e, p_e]     = corr(fix.vectorize_maps',e,'Type',type);
[r_f, p_f]     = corr(fix.vectorize_maps',f,'Type',type);
r_a(p_a<0.05) = nan;
r_b(p_b<0.05) = nan;
r_c(p_c<0.05) = nan;
r_d(p_d<0.05) = nan;
r_e(p_e<0.05) = nan;
r_f(p_f<0.05) = nan;


fix.maps = reshape([r_a,r_b,r_c,r_d,r_e,r_f],[500 500 6]);
figure;fix.plot;%title(mat2str(tags{n}),'interpreter','none');
drawnow