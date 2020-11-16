function cropAssets(road,year,assetType)

% loading images, asset data, nav data and camera parameters
imageDir = fullfile(dataDir,year,road,'images');
%images = dir(fullfile(imageDir,'2*.jpg'))
navFile = loadNavFile('A27');
nImages = size(navFile,1);

assetDBFFolder = fullfile(dataDir,year,road,'Assets','Year2_A27_Shapefiles');   
assetDBFFiles = dir(fullfile(assetDBFFolder,['*',assetType,'*.dbf']));
assetDBFFile = assetDBFFiles(1);
[assetData, fieldNames] = dbfRead(fullfile(assetDBFFolder,assetDBFFile.name));
assetDataTable = cell2table(assetData,'VariableNames',fieldNames);

% splitting the asset data into test and train. I will try to verify only
% those assets in test. I'll use 20% of the assets to make a training set.
% Still of 1000 images.
nAssets = size(assetDataTable,1);
nTrain = floor(nAssets*0.6);
assetDataTable = assetDataTable(randperm(nAssets),:);
assetsTrain = assetDataTable(1:nTrain,:);
assetsTest = assetDataTable(nTrain+1:end,:);
%save(sprintf('Assets_Train/%s_assetsTrain',assetType),'assetsTrain')
%save(sprintf('Assets_Test/%s_assetsTest',assetType),'assetsTest')

cameraParamTable = readtable(fullfile(dataDir,year,road,'calibration_parameters.csv'));
cameraParams = table2struct(cameraParamTable);

imsaveInd = 1200;
outDir = 'C:/CH2MData';
% looping through the images and pulling out all testing images. 

while imsaveInd < 1300
    %fprintf('%d/%d\n',iImage,nImages)
    try
        iImage = randi(nImages);
        imageNav = navFile(iImage,:);
        imageFileName = sprintf('2_%d_%d.jpg',imageNav.PCDATE,imageNav.PCTIME);
        % find assets
        [assets, Pcs, assetInfo] = findAssetsInImage(assetsTrain,imageNav,cameraParams);
        % assets = n * [u,v,u_box,v_box,w_box,h_box]
        nAssets = size(assets,1); 
        if nAssets > 0       
            label = sprintf('%s\\%s',imageDir,imageFileName);
            pixels = assets(:,1:2);
            boxes = assets(:,3:6);      
            img = imread(fullfile(imageDir,imageFileName));
            %clf;
            %imshow(img)
            %hold on
            for iAsset = 1:nAssets
                if any(assetInfo(iAsset,:).XCOORD == assetsTrain.XCOORD & ...
                        assetInfo(iAsset,:).YCOORD == assetsTrain.YCOORD)
                    Pcs(iAsset,:);
                    assetCrop = imcrop(img,boxes(iAsset,:));
                    %rectangle('Position',boxes(iAsset,:),'EdgeColor','r')
                    %plot(pixels(iAsset,1),pixels(iAsset,2),'m*')
                    imwrite(assetCrop,fullfile(outDir,road,'AssetThumbsTrain',assetType,sprintf('%s_%d.jpg',assetType,imsaveInd)))
                    fprintf('%d images cropped\n',imsaveInd)
                    imsaveInd = imsaveInd+1;
                    %imshow(assetCrop);
                    %close
                end            
            end
        end
    catch
         warning('Problem loading image');
    end
end

end

