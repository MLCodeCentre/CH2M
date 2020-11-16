function [navFile,XPosts,PPosts,sigmaAccx,innovationSeq] = kalmanFilterConstantVel(navFile,sigmaAcc,sigmaGPS,showPlot)
% KALMANFILTER kalman filter to smooth GPS and heading readings from the sensor. 
% We use a dynamical model of a vehicle to estimate the state: ()
% x(k+1) = x(k) + ts*v(k)*cos(theta(k)) + 0.5*ts^2*ax(k) (easting)
% y(k+1) = y(k) + ts*v(k)*sin(theta(k)) + 0.5*ts^2*ay(k) (northing)
% theta(k+1) = theta(k) + w(k) (easting velocity)
% v(k+1) = v(k) (northing velocity)
% w(k+1) = w(k)

sigmaAccx = sigmaAcc;
sigmaAccy = sigmaAccx;
sigmaAcctheta = sigmaAccx;

%sigmaGPS = 5;
sigmaTheta = sigmaGPS;

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

% initial state estimates
%    x    y    heading  v  w (angle velocity)
X = [x(1);y(1);theta(1);0;0;0];
nStates = size(X,1);
% initialise covariance matrix
P = 1000*eye(nStates);

% process error - how noisy is my dynamical model?
%Q = diag([0,0,0,sigmaV^2,sigmaW^2]);
% measurement error - this is how much I believe the GPS
R = diag([sigmaGPS^2,sigmaGPS^2,sigmaTheta]);

% memory allocation
XPosts = zeros(nStates,nNavFile);
XPosts(:,1)= X; % Initial posterior is just initial conditions
PPosts = zeros(nNavFile,nStates,nStates);
PPosts(1,:,:) = P;
innovationSeq = [];
%% Filtering
for iNav = 2:nNavFile
    % step up kalman matrices as time step changes from reading to reading
    T = ts(iNav);
    % define the state matrix Xk+1 = F*Xk (9x9) in keeping with wikipedia   
    F=[1 0 0 T 0 0; % x
       0 1 0 0 T 0; % y
       0 0 1 0 0 T; % theta
       0 0 0 1 0 0; % v
       0 0 0 0 1 0;
       0 0 0 0 0 1]; % w
    
    B = [(T^2)/2 0 0;
         0 (T^2)/2 0;
         0 0 (T^2)/2;
         T 0 0;
         0 T 0;
         0 0 T];
    
    Q = B*diag([sigmaAccx,sigmaAccy,sigmaAcctheta])*B'; 
    % prediction 
    XPriori = F*X; % state
    PPriori = F*P*F' + Q; % error
    
    % observation matrix we only record x,y
    H = [1 0 0 0 0 0;
         0 1 0 0 0 0;
         0 0 1 0 0 0];     
    % update
    % Innovation measurement
    
    theta_diff = abs(XPriori(3)-theta(iNav));
    if theta_diff > 200
        XPriori(3) = theta(iNav);
    end
        
    zk = [x(iNav);y(iNav);theta(iNav)];
    yk =  zk - H*XPriori;
    innovationSeq(end+1,:) = yk;
    % Innovation covariance
    S = H*PPriori*H' + R;
    
    % kalman gain
    K = PPriori*H'*inv(S);
    
    % posterior state estimate
    XPost = XPriori + K*yk;
    xFilt(end+1) = XPost(1);
    yFilt(end+1) = XPost(2);
    thetaFilt(end+1) = XPost(3);
    
    % posterior covariance estimate
    PPost = (eye(nStates) - K*H)*PPriori;
    
    % saving posterior covariance and states
    XPosts(:,iNav) = XPost;
    PPosts(iNav,:,:) = PPost;  
           
    % update X and P
    X = XPost; P = PPost;   
end
% updating 
navFile.XCOORDFILT = xFilt';
navFile.YCOORDFILT = yFilt';
navFile.HEADINGFILT = thetaFilt';

if showPlot
    % Easting
    p1 = subplot(4,2,2); cla(p1); title('Position'); hold on;
    plot(xFilt); hold on; plot(x); title('X'); legend('KF','IMU')

    % velocity
    p2 = subplot(4,2,4); cla(p2); 
    plot(yFilt); hold on; plot(y); title('Y'); legend('KF','IMU')
    % angular velocity
    p3 = subplot(4,2,6); cla(p3); 
    plot(thetaFilt); hold on; plot(theta); title('Theta'); legend('KF','IMU')

    v = sqrt(XPosts(4,:).^2 + XPosts(5,:).^2);
    w = abs(XPosts(6,:));
    p4 = subplot(4,2,8); cla(p4); 
    plot(v); title('Velocity');

    p5 = subplot(4,2,7); cla(p5); 
    plot(w); title('Angular Velocity');

    p6 = subplot(4,2,[1,3,5]); cla(p6); hold on
    for iNav = 1:min(100,nNavFile)
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
end


