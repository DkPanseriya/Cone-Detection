% load gTruth.mat

% Create training data folder 
if ~isfolder(fullfile("TrainingDataCustomMultiDetect"))
    mkdir TrainingDataCustomMultiDetect
end

% Sample Training Data
trainingData = objectDetectorTrainingData(gTruth, "SamplingFactor",1,"WriteLocation",'TrainingDataCustomMultiDetect');

% Display first few rows
trainingData(1:2,:)
testDataSet = trainingData;

% YOLO %

% Define Image input layer
inputSize = [416 416 3];
inputLayer = imageInputLayer(inputSize,'Name','input','Normalization','none');

% Define Middle Layer
filterSize = [3 3];

middleLayers = [
    convolution2dLayer(filterSize, 16, 'Padding', 1, 'Name', 'conv_1',...
    'WeightsInitializer','narrow-normal')
    batchNormalizationLayer('Name','BN1')
    reluLayer('Name','relu_1')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'maxpool1')
    convolution2dLayer(filterSize, 32, 'Padding', 1, 'Name', 'conv_2',...
    'WeightsInitializer','narrow-normal')
    batchNormalizationLayer('Name','BN2')
    reluLayer('Name','relu_2')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'maxpool2')
    convolution2dLayer(filterSize, 64, 'Padding', 1, 'Name', 'conv_3',...
    'WeightsInitializer','narrow-normal')
    batchNormalizationLayer('Name','BN3')
    reluLayer('Name','relu_3')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'maxpool3')
    convolution2dLayer(filterSize, 128, 'Padding', 1, 'Name', 'conv_4',...
    'WeightsInitializer','narrow-normal')
    batchNormalizationLayer('Name','BN4')
    reluLayer('Name','relu_4')
    ];

% Combine initial & middle layer
lgraph = layerGraph([inputLayer; middleLayers]);

numClasses = size(trainingData,2)-1;

% Define Anchor boxes
trainingData11 = boxLabelDatastore(trainingData(:,2:end));

numAnchors = 10;
[anchorBoxes,meanIoU] = estimateAnchorBoxes(trainingData11,numAnchors);


% Assemble YOLOv2
lgraph = yolov2Layers(inputSize,numClasses,anchorBoxes,lgraph,'relu_4');

% Check
% analyzeNetwork(lgraph);

% Train the Network
doTraining = false;
if doTraining
    rng(0);

options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'MiniBatchSize', 16, ... % Adjust the mini-batch size
    'MaxEpochs', 250, ... % Adjust the maximum number of epochs
    'Shuffle', 'every-epoch', ...
    'VerboseFrequency', 50, ...
    'ExecutionEnvironment','parallel' , ...
    'Plots', 'training-progress', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 10); % Increase the drop period


% Call YOLOv2
[yolov2ConeDetector, info] = trainYOLOv2ObjectDetector(testDataSet,lgraph,options);

save('/Users/vikalp/Desktop/Driverless files/yolov2ConeDetector.mat', 'yolov2ConeDetector');

else
    load('yolov2ConeDetector.mat')
end



