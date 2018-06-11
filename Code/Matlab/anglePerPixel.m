function anglePerPixel

camera = [0,0,0];
point = [2,3,4];

alpha = 50;
R = [1 0           0
     0 cos(alpha) -sin(alpha)
     0 sin(alpha)  cos(alpha)];

plotCamera('Location',camera,'Orientation',R,'Opacity',0);

R = point - camera;
