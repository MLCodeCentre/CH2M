function plotNavFileKF(navFile)

%navFile = navFile(1:1000,:);

% updating 
xFilt = navFile.XCOORD;
yFilt = navFile.YCOORD;
thetaFilt = navFile.HEADING;
x = navFile.XCOORDOLD;
y = navFile.YCOORDOLD;
theta = navFile.HEADINGOLD;


% Easting
p1 = subplot(4,2,2); cla(p1); title('Position'); hold on;
plot(xFilt); hold on; plot(x); title('X'); legend('KF','IMU')

% velocity
p2 = subplot(4,2,4); cla(p2); 
plot(yFilt); hold on; plot(y); title('Y'); legend('KF','IMU')
% angular velocity
p3 = subplot(4,2,6); cla(p3); 
plot(thetaFilt); hold on; plot(theta); title('Theta'); legend('KF','IMU')

% v = sqrt(XPosts(4,:).^2 + XPosts(5,:).^2);
% w = abs(XPosts(6,:));
% p4 = subplot(4,2,8); cla(p4); 
% plot(v); title('Velocity');
% p5 = subplot(4,2,7); cla(p5); 
% plot(w); title('Angular Velocity');

% dist = sqrt((x-xFilt).^2 + (y-yFilt).^2);
% dist = abs(thetaFilt-theta);
% ind = find(dist==max(dist));
% ind = ind(1);

p6 = subplot(4,2,[1,3,5]); cla(p6); hold on
for iNav = 1:100
        plot(x(iNav),y(iNav),'ro')
        x2=x(iNav)+(1*sin(deg2rad(theta(iNav))));
        y2=y(iNav)+(1*cos(deg2rad(theta(iNav))));
        plot([x(iNav),x2],[y(iNav),y2],'r--');
        plot(xFilt(iNav),yFilt(iNav),'bo')
        x2=xFilt(iNav)+(1*sin(deg2rad(thetaFilt(iNav))));
        y2=yFilt(iNav)+(1*cos(deg2rad(thetaFilt(iNav))));
        plot([xFilt(iNav),x2],[yFilt(iNav),y2],'b--');
end

end