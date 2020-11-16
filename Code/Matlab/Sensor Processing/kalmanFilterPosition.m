function [navFile,XPosts,PPosts,innovationSequence] = kalmanFilterPosition(navFile,sigmaAcc,sigmaGPS)
% KALMANFILTER kalman filter to smooth GPS and heading readings from the sensor. 
% We use a dynamical model of a vehicle to estimate the state: ()
% x(k+1) = x(k) + ts*vx(k) + 0.5*ts^2*ax(k) (easting)
% y(k+1) = y(k) + ts*vy(k) + 0.5*ts^2*ay(k) (northing)
% vx(k+1) = vx(k) + ts*ax(k) (easting velocity)
% vy(k+1) = vy(k) + ts*ay(k) (northing velocity)

% X(k+1) = F*X(k) + G*[ax,ay]'

%% Initialisation
nNavFile = size(navFile,1);
% Observation times    
t = navFile.GPSTIMES;
ts = diff(t); % time differences - this is how I estimate the velocity.
% extract observations
x = navFile.XCOORD; y = navFile.YCOORD; theta = navFile.HEADING;
% first filtered value will be first reading
xFilt = x(1); yFilt = y(1); thetaFilt = theta(1);
vx(1) = (x(2)-x(1))/ts(1);
vy(1) = (y(2)-y(1))/ts(1);
w(1) = (theta(2)-theta(1))/ts(1);

% initial state estimates
%    x    y    heading  vx  vy  w (angle velocity) ax ay aw
X = [x(1);y(1);theta(1);vx(1);vy(1);w(1)];
nStates = size(X,1);
% initialise covariance matrix
P = 100*eye(nStates);

% process error - how noisy is my dynamical model?
Qb = diag([sigmaAcc,sigmaAcc,sigmaAcc]);
% measurement error - this is how much I believe the GPS
R = diag([sigmaGPS,sigmaGPS,sigmaGPS]);

% memory allocation
XPosts = zeros(nStates,nNavFile);
XPosts(:,1)= X; % Initial posterior is just initial conditions
PPosts = zeros(nNavFile,nStates,nStates);
PPosts(1,:,:) = P;

innovationSequence = [];
%% Filtering
for iNav = 2:nNavFile
    % step up kalman matrices as time step changes from reading to reading
    T = ts(iNav-1);
    % define the state matrix Xk+1 = F*Xk (9x9) in keeping with wikipedia
    F = [1 0 0 T 0 0; % x
         0 1 0 0 T 0; % y
         0 0 1 0 0 T; % theta
         0 0 0 1 0 0; % vx
         0 0 0 0 1 0; % vy
         0 0 0 0 0 1]; % w
    
    B = [T^2/2 0 0;
         0 T^2/2 0;
         0 0 T^2/2;
         T 0 0;
         0 T 0;
         0 0 T;];
    
    Q = B*Qb*B';
    % prediction 
    XPriori = F*X; % state
    PPriori = F*P*F' + Q; % error
        
    % observation matrix we only record x,y
    H = [1 0 0 0 0 0;
         0 1 0 0 0 0
         0 0 1 0 0 0];     
    % update
    % Innovation measurement
    zk = [x(iNav);y(iNav);theta(iNav)];
    if abs(XPriori(3) - zk(3)) > 50
        XPriori(3) = zk(3);
    end
    
    yk =  zk - H*XPriori;
%     if any(yk(3) > 5)
%        disp('large Yk') 
%     end
    innovationSequence(:,end+1) = yk;
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
end


