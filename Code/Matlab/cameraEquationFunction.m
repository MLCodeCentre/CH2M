function F = cameraEquationFunction(theta,coords)
% constants
A = theta(1); B = theta(2); G = theta(3); L1 = theta(4); L2 = theta(5); h = theta(6);
x = coords(:,1); y = coords(:,2); z = coords(:,3); u = coords(:,4); v = coords(:,5);


cx = 1280; cy = 1024; m = 2560; n = 2048;

R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

num_data_points = size(x,1);

for i = 1:num_data_points
    %
    u(i) = u(i) - cx;
    v(i) = cy - v(i);
    
    F(2*i-1)  = ((u(i)*R(1,1) - m*L1*R(2,1))*x(i) + (u(i)*R(1,2) - m*L1*R(2,2))*y(i) + (u(i)*R(1,3) - m*L1*R(2,3))*(z(i)-h));
    F(2*i)= ((v(i)*R(1,1) - n*L2*R(3,1))*x(i) + (v(i)*R(1,2) - n*L2*R(3,2))*y(i) + (v(i)*R(1,3) - n*L2*R(3,3))*(z(i)-h));
end