function drawRoadFromPlane

close all

X = 1;
Z = 0;
Y = 0:10;

alpha = 0;
lambda = 1;

figure
hold on 
for y = Y
    for x = X
    [r_e1,phi,psi] = collapseOntoPlane(x,y,Z,alpha)
    plot(r_e1*sin(phi),r_e1*sin(psi),'ro')
    end
end