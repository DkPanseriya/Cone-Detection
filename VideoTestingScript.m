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

