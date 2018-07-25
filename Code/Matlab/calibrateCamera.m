function calibrateCamera(road,year)
%% loading data
close all
params = config();
img_file = fullfile(dataDir(),road,year,'Images','2_2367_1174.jpg');
I = imread(img_file);
imshow(I);
figure;

calibrationData = readtable(fullfile(dataDir(),road,year,...
                            'calibration_data.csv'));
%num_data_points = size(calibrationData,1);
num_data_points = 2;

%% 
alpha = 0;
gamma = 0;

plotCamera('Location',[0,0,0],'Orientation',rotx(90),'Size',0.5)
hold on


dL1Lambdas = [];
dL2Lambdas = [];

for row_ind = 1:num_data_points
    
   row = calibrationData(row_ind,:);
   Camera = [row.photo_x, row.photo_y, row.photo_z];
   Pw = [row.x, row.y, row.z];
   Pc = rotz(row.Yaw + gamma)*rotx(alpha)*(Pw-Camera)';
   Pc = [Pc(1) - params.r1, Pc(2) - params.r2, Pc(3) - params.r3]
   plot3(Pc(1),Pc(2),Pc(3),'ro')
   text(Pc(1),Pc(2),Pc(3),num2str(row_ind))
       
   u =  row.u - row.cx;
   v = -(row.v - row.cy);
   
   [phi,psi] = collapseOntoPlane(Pc(1),Pc(2),Pc(3));
   
   dL1Lambdas = [dL1Lambdas, u/(row.m*tan(phi))];
   dL2Lambdas = [dL2Lambdas, v/(row.n*tan(psi))];
   
end

xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
axis equal

dL1Lambdas
dL2Lambdas
