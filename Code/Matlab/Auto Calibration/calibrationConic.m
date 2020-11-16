%% trying calibration by the conic. This is found from 3 vertices. 
% first thing to do is manually label the image

% img = loadImageFromFile('M1',3,1278,40700);
% imshow(img);
% [U,V] = ginput(12);
%  % x1,x2, y1, y2
% lines = {[U(1),U(2),V(1),V(2)], [U(3),U(4),V(3),V(4)], ...
%          [U(5),U(6),V(5),V(6)], [U(7),U(8),V(7),V(8)], ...
%          [U(9),U(10),V(9),V(10)], [U(11),U(12),V(11),V(12)]};

close all 
nLines = size(lines,2);
m = 2464; n = 2056;

close; 

A1 = []; B1 = [];
A2 = []; B2 = [];
A3 = []; B3 = [];
figure; hold on;
%img = imresize(img, 0.25);
%imshow(img); hold on;

for i = 1:nLines
   line = lines{i};
   line = line/4;
   %U = line.X - m/2;
   %V = -line.Y + n/2; 
   X1 = line(1); X2 = line(2); Y1 = line(3); Y2 = line(4); 
   angle = rad2deg(atan2((Y1 - Y2),(X1 - X2)));
   coefficients = polyfit([X1, X2], [Y1, Y2], 1);
   
   if i <= 2
       % v = coeff(1)u + coeff(2)
       A1 = [A1; coefficients(1), -1]; B1 = [B1; -coefficients(2)];
       plot([X1, X2], [Y1, Y2], 'r');
       
   elseif i > 2 && i <= 4
       A2 = [A2; coefficients(1), -1]; B2 = [B2; -coefficients(2)];      
       plot([X1, X2], [Y1, Y2], 'b');
       
   else
       A3 = [A3; coefficients(1), -1]; B3 = [B3; -coefficients(2)];      
       plot([X1, X2], [Y1, Y2], 'g');
   end
   
end

%figure; hold on;
% find vanishing point from 2 lines.
v1 = A1\B1;
v2 = A2\B2;
v3 = A3\B3;

plot(v1(1), v1(2), 'r+')
text(v1(1), v1(2), 'v1')
plot([v1(1), v2(1)], [v1(2), v2(2)], 'k--')
plot(v2(1), v2(2), 'g+')
text(v2(1), v2(2), 'v2')
plot([v2(1), v3(1)], [v2(2), v3(2)], 'k--')
plot(v3(1), v3(2), 'b+')
text(v3(1), v3(2), 'v3')
plot([v1(1), v3(1)], [v1(2), v3(2)], 'k--')


v1_dash = v3 + (dot(v1-v3,v2-v3)/dot(v2-v3,v2-v3)) * (v2-v3);
v1_line = polyfit([v1_dash(1), v1(1)], [v1_dash(2), v1(2)], 1);
plot([v1_dash(1), v1(1)], [v1_dash(2), v1(2)], 'r--');

v2_dash = v1 + (dot(v2-v1,v3-v1)/dot(v3-v1,v3-v1)) * (v3-v1);
v2_line = polyfit([v2_dash(1), v2(1)], [v2_dash(2), v2(2)], 1);
plot([v2_dash(1), v2(1)], [v2_dash(2), v2(2)], 'g--')


v3_dash =  v2 + (dot(v3-v2,v1-v2)/dot(v1-v2,v1-v2)) * (v1-v2);
v3_line = polyfit([v3_dash(1), v3(1)], [v3_dash(2), v3(2)], 1);
plot([v3_dash(1), v3(1)], [v3_dash(2), v3(2)], 'b--')

A = [v1_line(1), -1; v2_line(1), -1; v3_line(1), -1];
B = [-v1_line(2); -v2_line(2); -v3_line(2)];

C = A\B;
plot(C(1), C(2), 'ko')
text(C(1), C(2), 'C')

v1_star = v1 + 2*(C-v1);

plot(v1_star(1), v1_star(2), 'k+');
text(v1_star(1), v1_star(2), 'v1*');

% plot circle
r = 4070/4;
th = 0:pi/50:2*pi;
xunit = r * cos(th) + C(1);
yunit = r * sin(th) + C(2);
plot(xunit, yunit);

% tangets to circle from v1*
P = v1_star'-C';
d2 = dot(P,P);
Q0 = C'+r^2/d2*P;
T = r/d2*sqrt(d2-r^2)*P*[0,1;-1,0];
Q1 = Q0+T;
Q2 = Q0-T;

plot(Q1(1), Q1(2), 'K+')
plot(Q2(1), Q2(2), 'K+')
plot([v1_star(1), Q1(1)],[v1_star(2), Q1(2)],'k')
plot([v1_star(1), Q2(1)],[v1_star(2), Q2(2)],'k')

% Calculate if Q1 and Q2 intercept v2,v3
Q1Error = IsPointWithinLine(v2(1), v2(2), v3(1), v3(2), Q1(1), Q1(2));
Q2Error = IsPointWithinLine(v2(1), v2(2), v3(1), v3(2), Q2(1), Q2(2));

Error = (Q1Error + Q2Error) / 2;
fprintf('Centre of projection: (%2.2f, %2.2f)\n', C(1), C(2));
fprintf('Focal Length: (%2.2f)\n', r);
fprintf('Tangents %2.2f pixels away from v2v3\n', Error);


axis equal; 
set(gca,'Ydir','reverse')

function error = IsPointWithinLine(x1, y1, x2, y2, x3, y3)
    % Line equation: y = m*x + b;
    m = (y2-y1)/(x2-x1);
    b = y1 - m*x1;
    yy3 = m*x3 + b;
    error = abs(yy3 - y3);
end