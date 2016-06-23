imagesc(Scale(make_gaussian2D(400,400,100,200,300,100)*rand(400,400)*0.1+repmat(sind(1:400),[400 1]))+0.2*Scale(make_gaussian2D(400,400,100,100,300,100)))
imagesc(Scale(make_gaussian2D(400,400,100,200,300,100)*rand(400,400)*0.1))%band


imagesc(Scale(make_gaussian2D(400,400,100,200,200,50))+rand(400,400)*0.01)%gauss

A = (Scale(make_gaussian2D(400,400,50,200,200,100)*rand(400,400)*0.1));
B = Scale(make_gaussian2D(400,400,100,200,200,50))+rand(400,400)*0.01;
imagesc(imfuse(imfuse(A,B,'blend'),B,'blend'));