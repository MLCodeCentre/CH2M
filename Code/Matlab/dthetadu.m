function dthetadu(theta,coords,system_params)

% This evaluates how the parameters change with each pixel around the
% solution.

A = theta(1); B = theta(2); G = theta(3); L1 = theta(4); L2 = theta(5); h = theta(6);

coord_ind = 3;

x = coords(coord_ind,1); y = coords(coord_ind,2); z = coords(coord_ind,3)-h; u_target = coords(coord_ind,4); v_target = coords(coord_ind,5);

cx = system_params(1); cy = system_params(2); m = system_params(3); n = system_params(4); x0 = system_params(5); y0 = system_params(6);
u_target = u_target - cx;
v_target = cy - v_target;

R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
 
%% defining differentials 
%[u,v] = meshgrid(-100:1:100,-100:10:100);
u = -100:100;
v = -100:100;
% alpha
figure;
dalphadu = @(u) ((R(1,1)*x + R(1,2)*y + R(1,3)*z)./...
                 (u*(R(1,3)*y - R(1,2)*z) + m*L1*(R(2,2)*z - R(2,3)*y)));
             
dalphadv = @(v) ((R(1,1)*x + R(1,2)*y + R(1,3)*z)./...
                 (v*(R(1,3)*y - R(1,2)*z) + n*L2*(R(3,2)*z - R(3,3)*y)));
             
dadu = rad2deg(dalphadu(u_target + u));
dadv = rad2deg(dalphadv(v_target + v));
plot(u_target + u,dadu,v_target + v,dadv); legend('u','v');

%quiver(u,v,dadu,dadv)

%beta
figure;
dbetadu = @(u)((R(1,1)*x + R(1,2)*y + R(1,3)*z)./...
               (u*(-cos(G)*sin(B)*x - cos(G)*cos(B)*sin(A)*y - cos(G)*sin(B)*cos(A)*z) ...
              + m*L1*(sin(G)*sin(B)*x - sin(G)*cos(B)*sin(A)*y - sin(G)*cos(B)*cos(A)*z)));
          
dbetadv = @(v)((R(1,1)*x + R(1,2)*y + R(1,3)*z)./...
               (v*(-cos(G)*sin(B)*x - cos(G)*cos(B)*sin(A)*y - cos(G)*sin(B)*cos(A)*z) ...
              + n*L2*(cos(B)*x + sin(B)*sin(A)*y + sin(B)*cos(A)*z)));

dbdu = rad2deg(dbetadu(u_target + u));
dbdv = rad2deg(dbetadv(v_target + v));
plot(u_target + u,dbdu,v_target + v,dbdv); legend('u','v');

%quiver(u,v,dbdu,dbdv)
% gamma
figure;
dgammadu = @(u) ((R(1,1)*x + R(1,2)*y + R(1,3)*z)./...
                 (u*(-R(2,1)*x - R(2,2)*y - R(2,3)*z) + m*L1*((-R(1,1)*x - R(1,2)*y - R(1,3)*z))));
             
dgammadv = @(v) ((R(1,1)*x + R(1,2)*y + R(1,3)*z)./...
                 (v*(-R(2,1)*x - R(2,2)*y - R(2,3)*z)));

dgdu = rad2deg(dgammadu(u_target + u));
dgdv = rad2deg(dgammadv(v_target + v));
plot(u_target + u,dgdu,v_target + v,dgdv); legend('u','v');

figure;
window = 400; res = 50;
[UU,VV] = meshgrid(u_target-window:res:u_target+window,v_target-window:res:v_target+window);

img_file = fullfile(dataDir(),'A27','Year2','Images','2_2367_1168.jpg');
I = imread(img_file);
imshow(I);
hold on

DADU = dalphadu(UU);
DADV = dalphadv(VV);
quiver(UU+cx,-VV+cy,DADU,DADV)
title('\alpha')

figure
DBDU = dbetadu(UU);
DBDV = dbetadv(VV);
quiver(UU,VV,DBDU,DBDV)
title('\beta')

figure
DGDU = dgammadu(UU);
DGDV = dgammadv(VV);
quiver(UU,VV,DGDU,DGDV)
title('\gamma')

