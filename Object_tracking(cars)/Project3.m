%% Background Subtraction USING GMM
clc;
clear;
 
xyloObj=VideoReader('/Users/apple/Downloads/output/Resources/output - Cellular.mp4'); 
vidWidth = xyloObj.Width;
vidHeight = xyloObj.Height;

foregroundDetector = vision.ForegroundDetector('NumGaussians', 5, ...
    'NumTrainingFrames', 100,'MinimumBackgroundRatio',0.7);

videoReader = vision.VideoFileReader('/Users/apple/Downloads/output/Resources/output - Cellular.mp4');
for i = 1:900
    frame = step(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
    foreground=uint8(foreground)*255;
    K = cat(3, foreground, foreground, foreground);
    mov(i).cdata=K;
    mov(i).colormap=[];
end
hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);
movie(hf,mov,1,xyloObj.FrameRate);

%% Mophlogical operation
clc;
clear;

xyloObj=VideoReader('/Users/apple/Downloads/output/Resources/output - Cellular.mp4'); 
vidWidth = xyloObj.Width;
vidHeight = xyloObj.Height;

foregroundDetector = vision.ForegroundDetector('NumGaussians', 5, ...
    'NumTrainingFrames', 100,'MinimumBackgroundRatio',0.7);

videoReader = vision.VideoFileReader('/Users/apple/Downloads/output/Resources/output - Cellular.mp4');
for i = 1:900
    frame = step(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
    foreground=uint8(foreground)*255;
     % foreground=medfilt2(foreground,[4,4]);
     foreground = bwmorph(foreground,'clean');
     foreground = bwmorph(foreground,'majority');
     foreground = bwmorph(foreground,'open');
      
     
    foreground=uint8(foreground)*255;
    K = cat(3, foreground, foreground, foreground);
    mov(i).cdata=K;
    mov(i).colormap=[];
end
hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);
movie(hf,mov,1,xyloObj.FrameRate);

