% Assuming you have initialized totalFrames appropriately
videoFile = 'Test_Vid.mp4';
vidObj = VideoReader(videoFile);
totalFrames = vidObj.NumFrames;

% Assuming you have loaded yolov2ConeDetector

% Initialize results structure
results = struct('Boxes', cell(1, totalFrames), 'Scores', cell(1, totalFrames), 'Labels', cell(1, totalFrames));

% Video Reader
vidReader = VideoReader('Test_Vid.mp4');

% Video Player
depVideoPlayer = vision.DeployableVideoPlayer;

% Loop through video frames
for i = 1:totalFrames
    % Read frame
    I = readFrame(vidReader);

    % Detect objects in the frame
    [bboxes, scores, labels] = detect(yolov2ConeDetector, I);

    % Display the results
    if ~isempty(bboxes)
        I = insertObjectAnnotation(I, 'rectangle', bboxes, cellstr(labels), 'LineWidth', 2);
    end
    depVideoPlayer(I);

    % Save results
    if ~isempty(bboxes)
        results(i).Boxes = floor(bboxes);
        results(i).Scores = scores;
        results(i).Labels = labels;
    else
        % Handle the case when no detection is found
        results(i).Boxes = [];
        results(i).Scores = [];
        results(i).Labels = [];
    end

    % Pause for visualization (adjust as needed)
    pause(0.1);
end

% Close video player
release(depVideoPlayer);

% Evaluate results
threshold = 0.7;
testLabels = cell(totalFrames, 2);
testLabels(:, 1) = {'BlueCone'};
testLabels(:, 2) = {'YellowCone'};

[ap, recall, precision] = evaluateDetectionPrecision(results, testLabels, threshold);
[am, fppi, missRate] = evaluateDetectionMissRate(results, testLabels, threshold);

% Plot Precision-Recall curve
figure;
plot(recall{1,1}, precision{1,1}, 'r-', recall{2,1}, precision{2,1}, 'b:');
xlabel('Recall');
ylabel('Precision');
legend('BlueCone', 'YellowCone');
title('Precision-Recall Curve');

% Plot Miss Rate vs False Positives per Image (FPPi) curve
figure;
loglog(fppi{1,1}, missRate{1,1}, 'r-', fppi{2,1}, missRate{2,1}, 'b:');
xlabel('False Positives per Image (FPPi)');
ylabel('Miss Rate');
legend('BlueCone', 'YellowCone');
title('Miss Rate vs FPPi Curve');
