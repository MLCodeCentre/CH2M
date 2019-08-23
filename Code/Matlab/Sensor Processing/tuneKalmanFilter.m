function accuracies = tuneKalmanFilter(road)

imgSetLoad = load(fullfile(road,sprintf('imgSet_%s.mat',road)));
imgSet = imgSetLoad.imgSet;
navFileFilterLoad = load(fullfile(road,sprintf('navFileFilter_%s.mat',road)));
navFileFilter = navFileFilterLoad.navFileFilter;
navFileClassifyLoad = load(fullfile(road,sprintf('navFileClassify_%s.mat',road)));
navFileClassify = navFileClassifyLoad.navFileClassify;
tuningAssetsFileLoad = load(fullfile(road,sprintf('tuningAssets_%s.mat',road)));
assets = tuningAssetsFileLoad.tuningAssets;

sigmaAccs = linspace(1,5,20);
sigmaGPSs = linspace(0.0005,0.025,20);

accuracies = [];

% loading images 

imshow(imgSet{1})

i = 1;
for sigmaAcc = sigmaAccs
    j = 1;
    for sigmaGPS = sigmaGPSs
        navFileFixed = preProcessNavFile(navFileFilter,sigmaAcc,sigmaGPS,false);
        navFileClassifyFixed = navFileFixed(ismember(navFileFixed.ID,navFileClassify.ID),:);
        accuracy = cropAndClassify(assets,navFileClassifyFixed,road,imgSet,false);
        accuracies(i,j) = accuracy;
        fprintf('sigma_acc: %2.2f, sigma_gps: %2.2f, acc: %2.5f\n',sigmaAcc,sigmaGPS,accuracy)
        j = j + 1;
    end
    i = i + 1;
end
% figure
imagesc(sigmaAccs,sigmaGPSs,accuracies)
xlabel('\sigma_{Acc}');
ylabel('\sigma_{GPS}');
set(gca,'YDir','normal')
c = colorbar;
c.Label.String = 'White ratio';
[i,j] = find(accuracies==max(accuracies(:)));
sigmaAccMax = sigmaAccs(i);
sigmaGPSMax = sigmaGPSs(j);
navFileFixed = preProcessNavFile(navFileFilter,sigmaAcc,sigmaGPS,false);
navFileClassifyFixed = navFileFixed(ismember(navFileFixed.ID,navFileClassify.ID),:);
cropAndClassify(assets,navFileClassifyFixed,road,imgSet,true);
% plot(sigmaAccs,accuracies);
% xlabel('\sigma_{Acc}');
% ylabel('Classification Accuracy')
end