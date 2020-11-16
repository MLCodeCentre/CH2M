function [navFile,XPosts,PPosts,sigmaAccx,innovationSeq] = kalmanFilterConstantVel(navFile,showPlot)
% KALMANFILTER kalman filter to smooth GPS and heading readings from the sensor. 
% We use a dynamical model of a vehicle to estimate the state: ()
% x(k+1) = x(k) + ts*v(k)*cos(theta(k)) + 0.5*ts^2*ax(k) (easting)
% y(k+1) = y(k) + ts*v(k)*sin(theta(k)) + 0.5*ts^2*ay(k) (northing)
% theta(k+1) = theta(k) + w(k) (easting velocity)
% v(k+1) = v(k) (northing velocity)
% w(k+1) = w(k)

% sigmaAccx = sigmaAcc;
% sigmaAccy = sigmaAccx;
% sigmaAcctheta = sigmaAccx;

%sigmaGPS = 5;
%sigmaTheta = sigmaGPS;

%% Initialisation
%navFile = navFile(1100:1200,:);
nNavFile = size(navFile,1);
% Observation times    
t = navFile.GPSTIMES;
ts = diff(t); % time differences - this is how I estimate the velocity.
% extract observations
x = navFile.XCOORD; y = navFile.YCOORD; theta = navFile.HEADING;

ts = [0.1;ts];
% first filtered value will be first reading
xFilt = x(1); yFilt = y(1); thetaFilt = theta(1);
vx(1) = (x(2)-x(1))/ts(1);
vy(1) = (y(2)-y(1))/ts(1);


estPos(:,1) = [x(1);y(1)];
estHeading(1) = theta(1);

% initial state estimates
%    x    y    heading  v  w (angle velocity)
vx(1) = (x(2)-x(1))/ts(1);
vy(1) = (y(2)-y(1))/ts(1);
state = [x(1);vx(1);y(1);vy(1);0];
init_cov = [5,1e-3,5,1e-3,1e-3];

UKF = trackingUKF(@constturn,@ctmeas,state);
UKF.ProcessNoise = 10*eye(5);
positionSelector = [1 0 0 0 0; 0 0 1 0 0]; % Position from state

cla;
hold on;
axis equal;
%% Filtering
for iNav = 2:130
    %fprintf('Filtering %d/%d images\n',iNav,navTestInd);
    predict(UKF,ts(iNav-1));
    meas = [x(iNav);y(iNav);0];
    % likelihood 
    correctedState = correct(UKF,meas);
    estPos(:,iNav) = positionSelector * correctedState;
    %estHeading(iNav) = rad2deg(atan2(correctedState(2),correctedState(4)));
    estHeading(iNav) = mod(estHeading(iNav-1) + rad2deg(correctedState(5))*ts(iNav),360);
    %estHeading(iNav)
    %theta(iNav)
    %plot(x(iNav),y(iNav),'ro')
    plotHeading(estPos(1,iNav),estPos(2,iNav),estHeading(iNav),'b')
    plotHeading(x(iNav),y(iNav),theta(iNav),'k')
end
  

end


