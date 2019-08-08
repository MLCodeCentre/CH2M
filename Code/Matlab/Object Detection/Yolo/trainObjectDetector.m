%% script to train a yolo detection network. 
% load data
road = 'A27'; assetType = 'SNSF';
data = load(fullfile(rootDir,'Data Annotation','Annotations',...
    sprintf('%s_%s_yolo.mat',road,assetType)));
%data = load(sprintf('%s_%s_yolo.mat',road,assetType));

trainingData = data.yoloTrainingTable;
imageDir = fullfile(dataDir,road,'Images');
%imageDir = 'A27_SNSF';
trainingData.imageFileName = fullfile(imageDir,trainingData.imageFileName);

% % Define the image input size.
% imageSize = [224 224 3];
% 
% % Define the number of object classes to detect.
% numClasses = width(trainingData)-1;
% 
% anchorBoxes = [
%     43 59
%     18 22
%     23 29
%     84 109
% ]; % these might want to be changed.

%% Load a pretrained ResNet-50.
%baseNetwork = resnet50;

% Specify the feature extraction layer.
featureLayer = 'activation_40_relu';

% Create the YOLO v2 object detection network. 
%lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,baseNetwork,featureLayer);

    % Configure the training options. 
    %  * Lower the learning rate to 1e-3 to stabilize training. 
    %  * Set CheckpointPath to save detector checkpoints to a temporary
    %    location. If training is interrupted due to a system failure or
    %    power outage, you can resume training from the saved checkpoint.
    options = trainingOptions('sgdm', ...
        'MiniBatchSize', 4, ....
        'InitialLearnRate',1e-3, ...
        'MaxEpochs',20,...
        'CheckpointPath', tempdir, ...
        'Shuffle','every-epoch');

warning off;
    
% Train YOLO v2 detector.
%[detector,info] = trainYOLOv2ObjectDetector(trainingData,lgraph,options);    
% trying faster R-CNN instead
% loading series network
disp('Loading VGG16');
vgg16Load = load('vgg16.mat');
vgg16 = vgg16Load.vgg16;
[detector, info] = trainFasterRCNNObjectDetector(trainingData, vgg16, options, ...
        'NegativeOverlapRange', [0 0.3], ...
        'PositiveOverlapRange', [0.6 1]);
save('assetDetector','detector')
exit(0)