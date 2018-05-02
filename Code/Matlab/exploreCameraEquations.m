function exploreCameraEquations

img_file = fullfile('C:','CH2MData','A27','Year1','Images','2_1310_4269.jpg');
I = imread(img_file);
imshow(I)
hold on
% camera parameters;
fx = 1040;
fy = 1040;
cx = 1280;
cy = 1024;

params = [fx, fy, cx, cy];

Z = 0.1:0.1:10; % straight line away through (1,1)
X = 0.1*ones(size(Z));
Y = 0.1*ones(size(Z));
points = [X; Y; Z]';
pixels = transformPerspective(points, params);
plot(pixels(:,2), pixels(:,1))

end

function pixels = transformPerspective(points, params)

    X = points(:,1); Y = points(:,2); Z = points(:,3);
    fx = params(1); fy = params(2); cx = params(3); cy = params(4);
    
    X_dashed = X./Z;
    Y_dashed = Y./Z;
    u = fx.*X_dashed + cx;
    v = fx.*Y_dashed + cy;
    
    pixels = [u,v];

end