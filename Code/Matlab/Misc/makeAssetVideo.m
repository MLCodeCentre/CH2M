video = VideoWriter('signposts'); %create the video object
video.FrameRate = 10;
open(video); %open the file for writing

% ordering asset of type as they are driven past.
road = 'A27'; year = 'Year2';

% loading assets
assetType = 'SNSF';
assetDbfFolder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');   
assetDbfFiles = dir(fullfile(assetDbfFolder,['*',assetType,'*.dbf']));
assetDbfFile = assetDbfFiles(1);
[assetData, fieldNames] = dbfRead(fullfile(assetDbfFolder,assetDbfFile.name));
assetDataTable = cell2table(assetData,'VariableNames',fieldNames);

% loading camera parameters
cameraParams = setCameraParams(dataDir,road);

navFile = readtable(fullfile(dataDir,road,year,'Nav','Nav.csv'));
% order so it's as we drive
navFile = sortrows(navFile,{'PCDATE','PCTIME'});

nImages = size(navFile,1);
for iImage = 1:500
    fprintf('searched through %d of %d images\n',iImage,nImages);
    
    image = navFile(iImage,:);
    [assetInfo, pVehicles, assets] = findAssetsInImage(assetDataTable,image,cameraParams(year));
    
    assets = [pVehicles,assets.XCOORD, assets.YCOORD, assets.MOUNTING_H];
    assets = sortrows(assets,1);
    
    nAssets = size(assets,1);
    % plot image
    imageFile = constructFileName(2,image.PCDATE,image.PCTIME);
    img = imread(fullfile(dataDir,road,year,'Images',imageFile));
    imshow(img);
    hold on

    for iAsset = 1:nAssets
        box = assetInfo(iAsset,3:end);
        rectangle('position',box,'EdgeColor','r');
    end
    hold off
    writeVideo(video,img); %write the image to file
    close
       

end
close(video); %close the file


function fileName = constructFileName(camera,PCDATE,PCTIME)
fileName = sprintf('%d_%d_%d.jpg',camera,PCDATE,PCTIME);
end

