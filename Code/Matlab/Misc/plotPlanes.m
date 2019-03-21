function plotPlanes(x,y,z)
%% plotting planes
%close all
r = [x,y,z];

e1 = [1,0,0];
e2 = [0,1,0];
e3 = [0,0,1];

e1phi = [-x,x;-x,x];
e2phi = [-y,-y;y,y];
e3phi = [0,0;0,0];

figure();
surf(e1phi, e2phi, e3phi,'FaceColor','blue','edgecolor','none','FaceAlpha',0.5000)
xlabel('e1')
ylabel('e2')
zlabel('e3')
hold on

e1psi = [0,0;0,0];
e2psi = [-y,y;-y,y];
e3psi = [-z,-z;z,z];

surf(e1psi, e2psi, e3psi,'FaceColor','red','edgecolor','none','FaceAlpha',0.5000)

plot3([0,r(1)],[0,r(2)],[0,r(3)])
text(r(1),r(2),r(3),'r','fontSize',14)

r_e2e1 = r - dot(r,e3)*e3;
r_e2e3 = r - dot(r,e1)*e1;

%%calculating angles phi and psi - i think this is wrong currently 
phi = rad2deg(angleBetweenVectors(r_e2e1(1),r_e2e1(2)));
psi = rad2deg(angleBetweenVectors(r_e2e3(3),r_e2e3(2)));

plot3([0,r_e2e1(1)],[0,r_e2e1(2)],[0,r_e2e1(3)],'k-')
text(3*(0+r_e2e1(1))/4,3*(0+r_e2e1(2))/4,0,['\phi: ',num2str(ceil(phi))],...
     'fontSize',11)

plot3([0,r_e2e3(1)],[0,r_e2e3(2)],[0,r_e2e3(3)],'k-')
text(0,3*(0+r_e2e3(2))/4, 3*(0+r_e2e3(3))/4,['\psi: ',num2str(ceil(psi))],...
     'fontSize',14)

axis equal 
ylim([0,y])

%%calculating angles phi and psi - i think this is wrong currently 
phi = rad2deg(angleBetweenVectors(r_e2e1(1),r_e2e1(2)));
psi = rad2deg(angleBetweenVectors(r_e2e3(3),r_e2e3(2)));
end

function alpha = angleBetweenVectors(V1,V2)
    %V1 should be the axis e1 and V2 the projection of r in e1,e2 or e1,e3
    alpha = atan(V1/V2);    
end
