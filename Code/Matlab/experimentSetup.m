function experimentSetup

close all

cam_height = 0.21;
camera_pos = [0,0,cam_height];
Alpha = 1.1; Gamma = 0.5;

%% plotting experiment
stickyNotesData = readtable(fullfile(dataDir(),'Experiment','StickyNotes.csv'));

plotCamera('Location',camera_pos,'Orientation',rotz(Gamma)*rotx(90+Alpha),'Size',0.05)

hold on

num_stickyNotes = size(stickyNotesData,1);
for row_ind = 1:num_stickyNotes
   row = stickyNotesData(row_ind,:);
   plot3(row.X,row.Y,0,'ro')
   text(row.X,row.Y,0,num2str(row_ind),'fontSize',14)
   hold on
end

title('World Coordinate System')
xlabel('X[m]')
ylabel('Y[m]')
zlabel('Z[m]')
grid on
axis equal

%% plotting scene in the camera frame
figure;
plotCamera('Location',[0,0,0],'Orientation',rotx(90),'Size',0.05)

hold on

num_stickyNotes = size(stickyNotesData,1);
for row_ind = 1:num_stickyNotes
   row = stickyNotesData(row_ind,:);
   r = rotx(Alpha)*[row.X+0.01,row.Y+0.01,-cam_height]';
   x = r(1); y = r(2); z = r(3);
   plot3(x,y,z,'ro')
   text(x,y,z,num2str(row_ind),'fontSize',14)
   hold on
end

title('Camera Coordinate System')
xlabel('X[m]')
ylabel('Y[m]')
zlabel('Z[m]')
grid on
axis equal

figure;

img_file = fullfile(dataDir(),'Experiment','tablewithstickies.jpg');
I = imread(img_file);
imshow(I);
hold on

%% calculating angles
m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^

dL1Lambdas = [];
dL2Lambdas = [];

for row_ind = 6:num_stickyNotes
   row = stickyNotesData(row_ind,:);
   % get position of note relative to camera
   x = row.X;
   y = row.Y;
   z = -cam_height;
   
   r = rotz(Gamma)*rotx(Alpha)*[x,y,z]';
   x = r(1); y = r(2); z = r(3);
   
   % get pixel co-ordinates - the origin is the centre of the image. 
   u =  row.U - cx;
   v = -(row.V - cy);
   
   [phi,psi] = collapseOntoPlane(x,y,z);
   
   dL1Lambdas = [dL1Lambdas, u/(m*tan(phi))];
   dL2Lambdas = [dL2Lambdas, v/(n*tan(psi))];

end
dL1Lambdas
dL2Lambdas
mean(dL1Lambdas)
mean(dL2Lambdas)


