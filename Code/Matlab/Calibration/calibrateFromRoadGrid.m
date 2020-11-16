%% This is a script to try and calibrate a camera from periodic road markings.
% First we will collect some data...
%img = loadImageFromFile('M69',1138,7978);
imshow(img);

nLines = 5; % this must be even left side of yellow strip then right.
[U,V] = ginput(3*nLines);
%[n,m,~] = size(img); % image size

%% Now we have pixel data lets create a guess for each of their 3D coords
delta_x = 7; % [m] obtained from arcgis
delta_y = 5.4/2; 

x_star = 10;
y_star = -2;

createCoordinates(x_star, y_star, delta_x, delta_y, nLines);

%% we can now run the optimiser
cameraParams = [4000];
rotation = [0,-5,1];
height = 2.5;

theta0 = [x_star, y_star, rotation, height, cameraParams];

f = @(theta) reprojectionError(theta, delta_x, delta_y, nLines, U, V);
[thetaSolve,fval] = fmincon(f,theta0);

%% and inspect the results
x_star = thetaSolve(1);
y_star = thetaSolve(2);
rotation = thetaSolve(3:5);
height = thetaSolve(6);
cameraParams = thetaSolve(7);

fprintf("\nx* : %2.2f [m]\n", x_star);
fprintf("y* : %2.2f [m]\n", y_star);
fprintf("rotation : [%2.2f, %2.2f, %2.2f] [degs]\n", rotation(1), rotation(2), rotation(3));
fprintf("height : %2.2f [m]\n", height)
fprintf("focal length : %2.2f [pixels]\n\n", cameraParams(1))

showReprojections(x_star, y_star, delta_x, delta_y, rotation, height, cameraParams, nLines, U, V, img)

%% Functions
function showReprojections(x_star, y_star, delta_x, delta_y, rotation, height, cameraParams, nLines, U, V, img)
    coords = createCoordinates(x_star, y_star, delta_x, delta_y, nLines);    
    imshow(img); hold on;
    % reproject each point and show label. 
    for i = 1:3*nLines
        plot(U(i),V(i),'go'); % clicked by me
        [u,v] = simpleCameraProjection(coords(i,:), rotation, height, cameraParams);
        plot(u,v,'r+'); % reprojections
    end
    hold off;
end


function fval = reprojectionError(theta, delta_x, delta_y, nLines, U, V)
% this is the high level function that will be minimised. theta takes all
% camera parameters and x_star, y_star; theta = [cp, rots, height, x_star, y_star]
    x_star = theta(1);
    y_star = theta(2);
    rotation = theta(3:5);
    height = theta(6);
    cameraParams = theta(7);
    % calculate coords from these
    coords = createCoordinates(x_star, y_star, delta_x, delta_y, nLines);
    % now reproject and calculate error:
    error = [];
    for i = 1:3*nLines
        [u,v] = simpleCameraProjection(coords(i,:), rotation, height, cameraParams);
        error(end+1) = u-U(i);
        error(end+1) = v-V(i);
    end
    fval = norm(error);
end


function [u,v] = simpleCameraProjection(coords, rotation, height, cameraParams)
% projects the coords to pixels u,v subject to the camera parameters, and a
% rotation and translation about the camera. 
    m = 2464; n = 2056;
    A = deg2rad(rotation(1)); B =  deg2rad(rotation(2)); G = deg2rad(rotation(3));
    %x0 = cameraParams(4); y0 = cameraParams(5); h = cameraParams(6);
    f = cameraParams(1);
    R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
          sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
         -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
    % Translation
    % I am assuming x_star and y_star will take care of the translation in the
    % (x,y) plane
    T = [0, 0, height]';

    Xw = coords'; % X in the world
    Xc = R*Xw - T; % X relative to the camera

    % converting to pixels
    u =  f*Xc(2)/Xc(1) + m/2;% this is from the centre of the image
    v = -f*Xc(3)/Xc(1) + n/2;
end


function coords = createCoordinates(x_star, y_star, delta_x, delta_y, nLines)
% creates 3D coordinates given start and deltas. (x_star, y_star) is
% coord of the left corner of the first yellow strip in the (x,y) plane.
    coords = [];
    for i = 1:nLines
       coords(end+1,:) = [x_star + i*delta_x, y_star, 0];
       coords(end+1,:) = [x_star + i*delta_x, y_star + delta_y, 0];
       coords(end+1,:) = [x_star + i*delta_x, y_star + 2*delta_y, 0];
    end
end
