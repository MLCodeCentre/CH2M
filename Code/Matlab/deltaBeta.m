function deltaBeta

close all
figure;
A = 0; B = 0; G = 0; L1 = 1; L2 = 1;

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)]; 

cx = 1280; cy = 1024; m = 2560; n = 2048;
x = 10;
y = 0;
z = 0;

dB = 0:0.001:pi/3;

dR = [R(1,1).*cos(dB) - cos(G)*sin(B).*sin(dB);  R(1,2) + cos(G)*sin(B)*sin(A).*(cos(dB)-1) + cos(G)*cos(B)*sin(A).*sin(dB);  R(1,3) + cos(G)*sin(B)*cos(A).*(cos(dB)-1) + cos(G)*cos(B)*cos(A).*sin(dB);
      R(2,1).*cos(dB) - sin(G)*sin(B).*sin(dB);  R(2,2) + sin(G)*sin(B)*sin(A).*(cos(dB)-1) + sin(G)*cos(B)*sin(A).*sin(dB);  R(2,3) + sin(G)*sin(B)*cos(A).*(cos(dB)-1) + sin(G)*cos(B)*cos(A).*sin(dB);
      R(3,1).*cos(dB) + cos(B).*sin(dB);         R(3,2).*cos(dB) - sin(B)*sin(A).*sin(dB);                                    R(3,2).*cos(dB) - sin(B)*cos(A).*sin(dB)];

du = m*L1*((dR(4,:).*x + dR(5,:).*y + dR(6,:).*z)...
         ./(dR(1,:).*x + dR(2,:).*y + dR(3,:).*z));

dv = n*L2*((dR(7,:).*x + dR(8,:).*y + dR(9,:).*z)...
             ./(dR(1,:).*x + dR(2,:).*y + dR(3,:).*z));

plot(rad2deg(dB),du)
hold on
plot(rad2deg(dB),dv)
title('Tilt Angle ($\beta$) Pixel Sensitivity','Interpreter','latex')
xlabel('$\delta\beta$ [degs]','Interpreter','latex')
ylabel('$\delta u$','Interpreter','latex')
% leg = legend('$\delta u$','$\delta v$');
% set(leg,'Interpreter','latex');
% set(leg,'Location','NorthWest');