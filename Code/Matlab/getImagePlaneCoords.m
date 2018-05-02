function [x_img,y_img] = getImagePlaneCoords(X,Y,Z,Z0,r1,r2,r3,lambda,theta,alpha)

    c = -X.*sin(theta).*sin(alpha) + Y.*cos(theta)*sin(alpha) - (Z-Z0).*cos(alpha) + r3 + lambda;
    
    x_img = (lambda.*( X.*cos(theta) + Y.*sin(theta) - r1))./c;
    y_img = (lambda.*(-X*sin(theta)*cos(alpha) + Y.*cos(theta)*sin(alpha) - (Z-Z0).*sin(alpha) - r2))./c;
end