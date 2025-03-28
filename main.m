close all
clear all
clc
% VideoCutter      % Used to cut the video to 12 seconds.

tic
% Loading the video data into MATLAB:
firerbgData                 =   VideoReader('fire_rgb_20sec.mp4');
fireVidData                 =   VideoReader('fireVid_12s.avi');

% Calling function to generate images from video:
imgCellVid1                 =    vid2img(fireVidData);
imgCellVid2                 =    vid2img(firerbgData);

% Generating the image from the cell:
n                           =    100;                   % Changes the image.
fireImg                     =    imgCellVid1{n};

% Segmenting the image using superpixels:
nPixels                     =   150;
isPlot                      =   truel;
[cFireSegImg, fireSegImg]   =   fireSeg(fireImg,nPixels,isPlot);

% Calculating the centroids:
cent                        =   regionprops(cFireSegImg,'Centroid');
cBw                         =   bwlabel(cFireSegImg, 8);

% Checking how likley that the segmented image actually is fire:
pixelMatrix                    =   isFire(fireSegImg);

% Checking in what cluster the more likley fire indices are from:
controllVector                 =    zeros(size(cent));

for i = 1 : size(pixelMatrix,1)
    for j = 1 : size(pixelMatrix,2) 

        if pixelMatrix(i,j) ~= 0 && cBw(i,j) ~= 0
            A = cBw(i,j);
            controllVector(A) = 1;
            
        end
    end
end

% Generating an image that shows where the fire can be found:
mostLikleyCol               =   'g';
lessLikleyCol               =   'b';

figure
idisp(fireImg)
hold on
for m = 1 : length(cent) 
    if controllVector(m) > 0
                plot_box('centre',cent(m).Centroid, 'size', [45 70]...
            , 'LineWidth',2, 'color', mostLikleyCol);           
    else
                plot_box('centre',cent(m).Centroid, 'size', [45 70]...
            , 'LineWidth',2, 'color', lessLikleyCol);               
    end
end

if length(cent) > 1

    legend('More likley to be a fire', 'Likley to be a fire')
end
title('Shows the where the script found the fire on the image and likliehood')
hold off 
toc