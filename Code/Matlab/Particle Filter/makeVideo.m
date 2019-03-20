function makeVideo

% create the video writer with 1 fps
video_file = fullfile(dataDir(),'Video Images','video.mp4');
writerObj = VideoWriter(video_file);
writerObj.FrameRate = 1;

%getting images
fullfile(dataDir(),'Video Images','*.png')

% set the seconds per image
secsPerImage = 1;
% open the video writer
open(writerObj);
% write the frames to the video
for u=1:21
 image_file = fullfile(dataDir(),'Video Images',strcat([num2str(u),'.png']))
 image = imread(image_file);
 % convert the image to a frame
 frame = im2frame(image);
 for v=1:secsPerImage 
     writeVideo(writerObj, frame);
 end
end
% close the writer object
close(writerObj);