function [phi,psi] = collapseOntoPlane(x,y,z)

% x y and z are coordinates in the camera frame of reference - z up, x
% across and y away from the camera (down the road). These points have been
% rotated by all extrinsic camera properties. 

% returns phi and psi, the angles between the projected vectors in the
% e1,e3 and e1,e3 planes and e1 vector respectively. 

r = [y,x,z];
    
e1 = [1,0,0];
e2 = [0,1,0];
e3 = [0,0,1];

r_e1e3 = r - dot(r,e2)*e2;
phi = angleBetweenVectors([e1(1), e1(3)], [r_e1e3(1), r_e1e3(3)]);
phi_deg = rad2deg(phi);

r_e1e2 = r - dot(r,e3)*e3;
psi = angleBetweenVectors([e1(1), e1(2)], [r_e1e2(1), r_e1e2(2)]);
psi_deg = rad2deg(psi);

end


function alpha = angleBetweenVectors(V1,V2)
    %V1 should be the axis e1 and V2 the projection of r in e1,e2 or e1,e3
    
    V1_alpha = atan2(V1(1),V1(2));
    V2_alpha = atan2(V2(1),V2(2)); 
    
    alpha = V1_alpha - V2_alpha;
    
end


