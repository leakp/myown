function [imfolder_target] = imagezauber(f,option)
%create the target folder if not existing
imfolder_target = [f,option,filesep];
if exist(imfolder_target) == 0
    mkdir(imfolder_target);
end
%%
if strcmp(option,'png2bmp')
    for imname = ListFiles([f '*.png'])'
        png = imread([f,imname{1}]);
        imwrite(png,sprintf('%s%s',imfolder_target,regexprep(imname{1},'png','bmp')));
    end
elseif strcmp(option,'killbg')
    for imname = ListFiles([f '*.bmp'])'
        fprintf('Working on file %s \n',imname{1})
        keyboard
        im = imread([f,imname{1}]);
        wand = magicwand(im,1,1,0);
        for a = 1:size(im,3)
        im(wand,a) = NaN;
        end
        imwrite(im,sprintf('%s%s',imfolder_target,regexprep(imname{1},'png','bmp')));
    end
end