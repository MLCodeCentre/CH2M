function trainCNN

%% creating image data store
road = 'A27';
imageFolder = fullfile('AssetThumbs');
imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames','IncludeSubfolders',true);

tbl = countEachLabel(imds)

% Determine the smallest amount of images in a category
minSetCount = min(tbl{:,2}); 

% Limit the number of images to reduce the time it takes
% run this example.
maxNumImages = 1000;
minSetCount = min(maxNumImages,minSetCount);

% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');
countEachLabel(imds)
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7);

% load pre trained network
net = googlenet;
lgraph = layerGraph(net);

% change network output 
lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});
numClasses = numel(categories(imdsTrain.Labels));
newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc');

figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])


% freezing conv layers


inputSize = net.Layers(1).InputSize;
layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:110) = freezeWeights(layers(1:110));
lgraph = createLgraphUsingConnections(layers,connections);

% data augmentation
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',5, ...
    'InitialLearnRate',1e-4, ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'ValidationPatience',Inf, ...
    'Verbose',true)
    %'Plots','training-progress')
    %'ExecutionEnvironment','parallel');

net = trainNetwork(augimdsTrain,lgraph,options);

save 4ClassAssetNet750 net

end