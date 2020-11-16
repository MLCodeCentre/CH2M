function findTuningAssets(assets,navFile,road)

%assetIDs = {'7000007052','7000007022','7000006865'};
%assetIDs = {'7002000304','7002000305','7002000635','7002000922'};
%  assetIDs = {'7000004812','7000005109','7000004808','7000004807','7000005086',...
%              '7000005296','7000005446','7000005447'}; % MKRF
%assetIDs = {'7000000616','7000000795','7000000258','7002000531','7002001047'};
%assetIDs = {'7000006865'};
% MKRFs on straight roads.
assetIDs = {'7002001216','7002001217','7000001145','7000001165','7000001342'};
assets = assets(ismember(assets.SOURCE_ID,assetIDs),:);
classifySeqLength = 10;
filterSeqLength = 50;

tuningAssets = [];
navFileFilter = [];
navFileClassify = [];
cameraParams = loadCameraParams(road);

nAssets = size(assets,1);
for iAsset = 1:nAssets
   asset = assets(iAsset,:);
   closestImage = getAssetImage(asset,navFile,cameraParams);
   if ~isempty(closestImage)
       PCDATE = closestImage.PCDATE; PCTIME = closestImage.PCTIME;
       navFileFilterSequence = navFile(navFile.PCDATE==PCDATE & ...
           ismember(navFile.PCTIME,PCTIME-filterSeqLength:PCTIME),:);
       navFileFilter = [navFileFilter;navFileFilterSequence];
       
       navFileClassifySequence = navFile(navFile.PCDATE==PCDATE & ...
           ismember(navFile.PCTIME,PCTIME-classifySeqLength:PCTIME),:);
       navFileClassify = [navFileClassify;navFileClassifySequence];

       tuningAssets = [tuningAssets;asset];
       fprintf('%d/%d processed %d added to tuning set\n',iAsset,nAssets,size(tuningAssets,1))
   end
end

navFileFilter = unique(navFileFilter);
navFileClassify = unique(navFileClassify);
fprintf('%d assets to classify\n',size(navFileClassify,1));

nNav = size(navFileClassify,1);
for iNav = 1:nNav
    fprintf('loading images (%d/%d)\n',iNav,nNav)
    image = navFileClassify(iNav,:);
    imgSet{iNav} = rgb2gray(imread(fullfile(dataDir(),road,'Images',...
        sprintf('2_%d_%d.jpg',image.PCDATE,image.PCTIME))));
end

mkdir(road);
save(fullfile(road,sprintf('tuningAssets_%s',road)),'tuningAssets');
save(fullfile(road,sprintf('navFileFilter_%s',road)),'navFileFilter');
save(fullfile(road,sprintf('navFileClassify_%s',road)),'navFileClassify');
save(fullfile(road,sprintf('imgSet_%s',road)),'imgSet');