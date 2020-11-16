 function R = rotationMatrix(alpha, beta, gamma)
 % my rotation matrix.
    A = deg2rad(alpha); B = deg2rad(beta); G = deg2rad(gamma);
    R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
          sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
         -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];
end