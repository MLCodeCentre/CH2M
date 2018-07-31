function experimentSetup

close all

cam_height = 0.21;
camera_pos = [0,0,cam_height];

%% plotting experiment
stickyNotesData = readtable(fullfile(dataDir(),'Experiment','StickyNotes.csv'));


% plotCamera('Location',camera_pos,'Orientation',rotx(90),'Size',0.05)

% hold on

num_stickyNotes = size(stickyNotesData,1);
% for row_ind = 1:num_stickyNotes
%    row = stickyNotesData(row_ind,:);
%    plot3(row.X,row.Y,0,'ro')
%    text(row.X,row.Y,0,num2str(row_ind),'fontSize',14)
%    hold on
% end

% xlabel('X[m]')
% ylabel('Y[m]')
% zlabel('Z[m]')
% grid on
% axis equal

figure;

img_file = fullfile(dataDir(),'Experiment','tablewithstickies.jpg');
I = imread(img_file);
imshow(I);
hold on

%% calculating angles
n = 4032; cx = 2016; % >
m = 3024; cy = 1512; % ^

rat1s = [];
rat2s = []; 

for row_ind = 1:num_stickyNotes
   row = stickyNotesData(row_ind,:);
   % get position of note relative to camera
   x = row.X;
   y = row.Y;
   z = -cam_height;
   
   alpha = 0;
   r = rotx(alpha)*[x,y,z]';
   x = r(1); y = r(2); z = r(3);
   
   % get pixel co-ordinates - the origin is the centre of the image. 
   u = row.U - cx;
   v = -(row.V - cy);
   
   [phi,psi] = collapseOntoPlane(y,z,x);
   
   rat1s = [rat1s, u/(2*n*tan(phi))];
   rat2s = [rat2s, v/(2*m*tan(psi))];

end

rat1s
rat2s


