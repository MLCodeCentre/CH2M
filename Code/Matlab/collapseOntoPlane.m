function [phi,psi] = collapseOntoPlane(x,y,z)

% x y and z are coordinates in the camera frame of reference - z up, x
% across and y away from the camera (down the road). These points have been
% rotated by all extrinsic camera properties. 

% returns phi and psi, the angles between the projected vectors in the
% e1,e3 and e1,e3 planes and e1 vector respectively. 

r = [x,y,z];
    
e1 = [1,0,0];
e2 = [0,1,0];
e3 = [0,0,1];

r_e2e1 = r - dot(r,e3)*e3;
r_e2e3 = r - dot(r,e1)*e1;

%%calculating angles phi and psi - i think this is wrong currently 
phi = angleBetweenVectors(r_e2e1(1),r_e2e1(2));
psi = angleBetweenVectors(r_e2e3(3),r_e2e3(2));
end

function alpha = angleBetweenVectors(V1,V2)
    %V1 should be the axis e1 and V2 the projection of r in e1,e2 or e1,e3
    alpha = atan(V1/V2);    
end


