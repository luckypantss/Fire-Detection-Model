% This scripts cuts the video to 12 seconds ans stores it as its own video.

% Loading the video into MATLAB:
fireVidData          =   VideoReader('fireVid_013.mp4');


% Creating a new video file and opening it for writing:
fireVidObj           =   VideoWriter('fireVid_12s');
open(fireVidObj)

% Calculating the amount of frames needed for 12 seconds:
fps                 =   fireVidData.FrameRate;
t                   =   12;
framesNeeded        =   t*fps;

% Looping through the frames and reading them into the new videofile:
for i = 1 : framesNeeded + 5/2*fps 
    
    writeVideo(fireVidObj, read(fireVidData,i));

end

close(fireVidObj)

close all 
clear all
clc
