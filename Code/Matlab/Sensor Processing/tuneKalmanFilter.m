function accuracies = tuneKalmanFilter(road)

%imgSetLoad = load(fullfile(road,sprintf('imgSet_%s.mat',road)));
%imgSet = imgSetLoad.imgSet;
navFileFilterLoad = load(fullfile(road,sprintf('navFileFilter_%s.mat',road)));
navFileFilter = navFileFilterLoad.navFileFilter;
navFileClassifyLoad = load(fullfile(road,sprintf('navFileClassify_%s.mat',road)));
navFileClassify = navFileClassifyLoad.navFileClassify;
tuningAssetsFileLoad = load(fullfile(road,sprintf('tuningAssets_%s.mat',road)));
assets = tuningAssetsFileLoad.tuningAssets;

sigmaAccs = linspace(0.1,10,10);
sigmaGPSs = linspace(0.15,0.3,10);
%sigmaAccs = 5;

accuracies = [];

% loading images 
%imshow(imgSet{1})

i = 1;
for sigmaGPS = sigmaGPSs
    j = 1;
    for sigmaAcc = sigmaAccs
        navFileFixed = preProcessNavFile(navFileFilter,sigmaAcc,sigmaGPS,false);
        navFileClassifyFixed = navFileFixed(ismember(navFileFixed.ID,navFileClassify.ID),:);
        %avgGradient = calculateYDistances(assets,navFileClassifyFixed);
        %headingVar = std(navFileFixed.HEADING);
        %accuracy = cropAndClassify(assets,navFileClassifyFixed,road,imgSet,false);
        accuracies(i,j) = headingVar;
        fprintf('sigma_acc: %2.2f, sigma_gps: %2.2f, acc: %2.5f\n',sigmaAcc,sigmaGPS,headingVar)
        j = j + 1;
    end
    i = i + 1;
end

imagesc(sigmaGPSs,sigmaAccs,accuracies)
ylabel('\sigma_{ACC}');
xlabel('\sigma_{GPS}');
set(gca,'YDir','normal')
c = colorbar;
c.Label.String = 'Y Distance Variance';
[i,j] = find(accuracies==max(accuracies(:)));
sigmaAccMax = sigmaAccs(i);
sigmaGPSMax = sigmaGPSs(j);
% navFileFixed = preProcessNavFile(navFileFilter,sigmaAcc,sigmaGPS,false);
% navFileClassifyFixed = navFileFixed(ismember(navFileFixed.ID,navFileClassify.ID),:);
% cropAndClassify(assets,navFileClassifyFixed,road,imgSet,true);
% plot(sigmaAccs,accuracies);
% xlabel('\sigma_{Acc}');
% ylabel('Classification Accuracy')
end