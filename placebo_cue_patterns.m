r = 8;
tsize = [10,10];
coords    = [5, 1; 7.8 2.2; 9 5; 7.8, 7.8; 5, 9; 2.2 7.8; 1 5; 2.2 2.2];
coords = 5+
plot(coord(:,1),coord(:,2),'b')
axis square

pattern = (2*make_gaussian2D(8,8,2,2,4,3)-make_gaussian2D(8,8,1,1,6,6)+randn(8,8)*0.4);imagesc(pattern);
pattern = pattern+rand(8,8)*0.2;imagesc(pattern);
pattern = imresize(pattern,10);imagesc(pattern)
pattern =  imresize(pattern,10,'method','bilinear');
imagesc(pattern)
axis square
box off
axis off

for n=1:8
    pattern = (2*make_gaussian2D(8,8,2,2,coords(n,1),coords(n,2)));
    %pattern = imresize(pattern,50,'method','bilinear');
    subplot(2,4,n)
    imagesc(pattern);title(sprintf('No %d',n));
    axis square
end

pattern = zeros(80,80);
pattern(20:60,15:50)=2;
pattern = 2*make_gaussian2D(80,80,20,20,40,30)-make_gaussian2D(80,80,10,10,60,60)+randn(80,80)*0.2));
pattern = pattern+rand(8,8)*0.2;
pattern =  imresize(pattern,50,'method','bilinear');
imagesc(pattern)
axis square

x = conv2(randn(600), fspecial('gaussian',200,30), 'valid'); %// example 2D smooth data
imagesc(x)
