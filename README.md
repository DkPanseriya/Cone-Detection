<a name="readme-top"></a>

<h3 align="center">Solution to MATLAB and Simulink Challenge project 248: Cone Detection for Formula Student Driverless Competition</h3>

  <p align="center">
    <a href="https://github.com/mathworks/MATLAB-Simulink-Challenge-Project-Hub/tree/40c3078ecaf4acd684f5b202a545f0933bb993ba/projects/Cone%20Detection%20for%20Formula%20Student%20Driverless%20Competition"><strong>Probem Statement»</strong></a>
    <br />
    
  </p>
</div>


## About The Project
The ability to detect cones in the scene is crucial for autonomous driving applications, such as autonomous racing, as it enables the vehicle to navigate through a course safely and efficiently. In the Formula Student driverless competitions, the teams are required to navigate through a series of cones, and detecting the cones accurately can give the team a competitive edge. In this project, we will learn how to use MATLAB® and Simulink® to detect cones in a virtual environment, which can help them gain valuable experience in autonomous driving.

### Training Procedure
- VideoLabeler in Matlab is used to label the Blue and Yellow cones as training data.   <br />
- The labeled data is exported into Matlab workspace.   <br />
- In the TrainingScript, YOLOv2 object detection algorithm is trained for detection of the cones with labeled training data.    <br />
  (Alternatively, already trained network can also be loaded into workspace with yolov2ConeDetector.)   <br />
- VideoTestingScript runs trained network on Test_Vid.mp4 for detection of the Blue and Yellow cones and labels them.   <br />


### Test your Video

1. Place *(the video)* into the working directory.
2. Load trained network into the Workspace with YOLOv2ConeDetector.
3. Open VideoTestingScript.
4. Change the names in the script: Test_Vid.mp4 --> *(Name of the video.extension)*
5. Run the script.

## Background Material

1. [How to Perform Data Labeling for Camera and Lidar Sensor Data](https://www.mathworks.com/videos/ground-truth-labeler-app-1529300803691.html)
2. [YOLOv2 Object Detection: Data Labelling to Neural Networks in MATLAB](https://blogs.mathworks.com/student-lounge/2020/07/07/yolov2-object-detection-data-labelling-to-neural-networks-in-matlab/)

