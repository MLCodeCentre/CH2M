function createRandomImages(road,year)

imageDir = fullfile(dataDir,year,road,'images');
images = dir(fullfile(imageDir,'2*.jpg'));
cameraParamTable = readtable(fullfile(dataDir,year,road,'calibration_parameters.csv'));
cameraParams = table2struct(cameraParamTable);
images = images(randperm(length(images)),:);
%% finding assets in the images
outDir = 'C:/CH2MData';
nImages = size(images,1);
imsaveInd = 1;
for iImage = 1:1500
    % generate random coord
    x = randInt(5,30,1);
    y = randInt(3,-5,1);
    z = randInt(2,0,1);
    
    assetLength = randInt(1,0,1);
    assetWidth = randInt(2,1,1);
    assetHeight = randInt(2,1,1);
    
    box = getBoundingBox([x,y,z],[assetLength,assetWidth,assetHeight],cameraParams);
    
    image = images(iImage);
    imageFileName = image.name;
    img = imread(fullfile(imageDir,imageFileName));
    assetCrop = imcrop(img,box);
    try
        imwrite(assetCrop,fullfile(outDir,road,'AssetThumbs','Random',sprintf('%s_%d.jpg','Random',imsaveInd)))
        fprintf('%d images cropped\n',imsaveInd)
        imsaveInd = imsaveInd+1;
    catch 
        disp('errored');
    end
    
end


end

function r = randInt(a,b,n)
r = (b-a).*rand(n,1) + a;
end