function solveCameraMatrix
close all
Xw = [471316.640, 105927.277, 0; % 1 S
      471314.418, 105926.673, 0; % 1 E
      471307.949, 105928.705, 0; % 2 S
      471305.925, 105928.864, 0; % 2 E
      471316.124, 105923.546, 0; % 1 S H
      471313.902, 105923.744, 0; % 1 E H
      471307.274, 105924.697, 0; % 2 S H
      471305.250, 105925.054, 0]; % 2 E H

Y = [2113, 1984;
     1833, 1584;
     1549, 1189;
     1516, 1129;
     130,  1984;
     515,  1584;
     910,  1189;
     973,  1129];

params = config();
photo = [471321.89, 105924.92, params.Z0];
yaw = 279.33;

num_samples = size(Xw,1);
figure();
hold on
for i = 1:num_samples
    [u,v] = coords2PixelsHomog(Xw(i,:)',photo',yaw);
    plot(i,u,'ro')
    plot(i,Y(i,1),'bo')
     
end





end