function solveAlphaLambda

close all;
% training set world coords of middle of the road of road marker, 1st and
% 2nd street light.
params = config();

photo = [471321.89, 105924.92, params.Z0];
yaw = 279.33;

% Xw = [471316.802, 105927.226, 0; % lane marker
%       471308.172, 105934.080, 0; % first street light
%       471267.929, 105939.756, 0; % second street light
%       471307.299, 105924.754, 0; % hardshoulder opposite first lane marker
%       471315.911, 105923.444, 0]; % hardshoulder opposite second lad
% 
% % U,V pixel values
% Y = [2110,1981; 
%      2385,1248;
%      1545,894;
%      904, 1186;
%      134, 1984];
% explore lambda, alpha space to minimise the error.
Xw = [471316.640, 105927.277, 0; % 1 S
      471314.418, 105927.673, 0; % 1 E
      471307.949, 105928.705, 0; % 2 S
      471305.925, 105928.864, 0; % 2 E
      471316.124, 105923.546, 0; % 1 S H
      471313.902, 105923.744, 0; % 1 E H
      471307.274, 105924.697, 0; % 2 S H
      471305.250, 105925.054, 0]; % 2 E H

Xc = [1.45, 5.56, -2.5;
      1.45, 7.82, -2.5;
      1.45, 14.37, -2.5;
      1.45, 16.39, -2.5;
      -2.30, 5.56, -2.5;
      -2.30, 7.82, -2.5;
      -2.30, 14.37, -2.5;
      -2.30, 16.39, -2.5;];

Y = [2113, 1984;
     1833, 1584;
     1549, 1189;
     1516, 1129;
     130,  1984;
     515,  1584;
     910,  1189;
     973,  1129];


n = 100; %samples per parameter
alpha = linspace(0.1,90,n); %alpha range and corresponding sy
lambda = linspace(0,0.8,n);
%lambda = 0.072;

[A,L] = meshgrid(alpha, lambda);
sy = -(L./tan(deg2rad(A))) .* (1/(780-params.cy));
sx = sy/0.8;

num_samples = size(Xw,1);

errors = zeros(n,length(lambda),num_samples);
Verrors = zeros(n,length(lambda),num_samples);
Uerrors = zeros(n,length(lambda),num_samples);

for i = 1:num_samples
    %R = Xw(i,:) - photo;
    %Xc = toCameraCoords(R',yaw)
    [u,v] = coords2PixelsArgs(Xc(i,1),Xc(i,2),Xc(i,3),L,A,sx,sy);
    errors(:,:,i) = sqrt((u-Y(i,1)).^2 + (v-Y(i,2)).^2);
    Uerrors(:,:,i) = sqrt((u-Y(i,1)).^2);
    Verrors(:,:,i) = sqrt((v-Y(i,2)).^2);    
end

errors = mean(errors,3);
Uerrors = mean(Uerrors,3);
Verrors = mean(Verrors,3);

surf(A,L,errors);
xlabel('\alpha [deg]');ylabel('\lambda [m]');zlabel('E(\alpha, \lambda)');
colorbar
zlim([0,1000])
caxis([0,1000])

[val,Idx] = min(errors(:))
[Errors_minRow,Errors_minCol] = ind2sub(size(errors), Idx);
alpha_min = alpha(Errors_minRow)
lambda_min = lambda;
sy_min = -(lambda_min./tan(deg2rad(alpha_min))) .* (1/(780-params.cy))

lambda_ind = find(lambda==lambda_min);
figure()
plot(alpha,errors)
hold on
plot(alpha,Uerrors)
plot(alpha,Verrors)

xlabel('\alpha');ylabel(strcat('E(\alpha, \lambda=',num2str(lambda_min),')'));
legend('Total Error','U Error','V Error','location','northwest')
title(strcat('\lambda=',num2str(lambda_min)))
ylim([0,2000])
xlim([70,90])