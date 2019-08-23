function [navFile,XPosts,PPosts,Q] = kalmanFilterPosition(navFile,sigmaAcc,sigmaGPS)
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
x = navFile.XCOORD; y = navFile.YCOORD; h = navFile.HEADING;

ts = [0.1;ts];
% first filtered value will be first reading
xFilt = x(1); yFilt = y(1);

% initial state estimates
%    x    y    heading  vx  vy  w (angle velocity) ax ay aw
X = [x(1);y(1);5;5;0;0];
nStates = size(X,1);
% initialise covariance matrix
P = 10*eye(nStates);

% process error - how noisy is my dynamical model?
Q = diag([0,0,0,0,sigmaAcc^2,sigmaAcc^2]);
% measurement error - this is how much I believe the GPS
R = diag([sigmaGPS^2,sigmaGPS^2]);

% memory allocation
XPosts = zeros(nStates,nNavFile);
XPosts(:,1)= X; % Initial posterior is just initial conditions
PPosts = zeros(nNavFile,nStates,nStates);
PPosts(1,:,:) = P;
%% Filtering
for iNav = 2:nNavFile
    % step up kalman matrices as time step changes from reading to reading
    T = ts(iNav);
    % define the state matrix Xk+1 = F*Xk (9x9) in keeping with wikipedia
    F=[1 0 T 0 T^2/2 0; % x
       0 1 0 T 0 T^2/2; % y
       0 0 1 0 T 0; % vx
       0 0 0 1 0 T
       0 0 0 0 1 0
       0 0 0 0 0 1]; % vk
    
    % prediction 
    XPriori = F*X; % state
    PPriori = F*P*F' + Q; % error
    
    % observation matrix we only record x,y
    H = [1 0 0 0 0 0;
         0 1 0 0 0 0];     
    % update
    % Innovation measurement
    zk = [x(iNav);y(iNav);];
    yk =  zk - H*XPriori;
    % Innovation covariance
    S = H*PPriori*H' + R;
    % kalman gain
    K = PPriori*H'*inv(S);
    
    % posterior state estimate
    XPost = XPriori + K*yk;
    xFilt(end+1) = XPost(1);
    yFilt(end+1) = XPost(2);
    
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

end


