function deltaGamma

close all

A = 0; B = 0; G = 0; L1 = 1; L2 = 1;

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)]; 

cx = 1280; cy = 1024; m = 2560; n = 2048;
x = 10;
y = 0;
z = 0;

dG = 0:0.001:pi/3;

dR = [R(1,1).*cos(dG) - R(2,1).*sin(dG);  R(1,2)*cos(dG) - R(2,2)*sin(dG);   R(1,3)*cos(dG) - R(2,3)*sin(dG);
      R(2,1).*cos(dG) + R(1,1).*sin(dG);  R(2,2)*cos(dG) + R(1,2)*sin(dG);   R(2,3)*cos(dG) + R(1,3)*sin(dG);
      R(3,1)*ones(size(dG));              R(3,2)*ones(size(dG));             R(3,3)*ones(size(dG))];

du = m*L1*((dR(4,:).*x + dR(5,:).*y + dR(6,:).*z)...
         ./(dR(1,:).*x + dR(2,:).*y + dR(3,:).*z));

dv = n*L2*((dR(7,:).*x + dR(8,:).*y + dR(9,:).*z)...
         ./(dR(1,:).*x + dR(2,:).*y + dR(3,:).*z));

       
plot(rad2deg(dG),du)
hold on
plot(rad2deg(dG),dv)

title('Pan Angle ($\gamma$) Pixel Sensitivity','Interpreter','latex')
xlabel('$\delta\gamma$ [degs]','Interpreter','latex')
ylabel('Pixels','Interpreter','latex')
leg = legend('$\delta u$','$\delta v$');
set(leg,'Interpreter','latex');
set(leg,'Location','NorthWest');