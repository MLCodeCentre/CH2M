function [navFile,XPosts,PPosts,Q] = kalmanFilterPos(navFile)
% KALMANFILTER kalman filter to smooth GPS and heading readings from the sensor. 
% We use a dynamical model of a vehicle to estimate the state: ()
% x(k+1) = x(k) + T*vx(k) + 0.5*T^2*ax(k) (easting)
% y(k+1) = y(k) + T*vy(k) + 0.5*T^2*ay(k) (northing)
% h(k+1) = h(k) + T*w(k) + 0.5*T^2*ah(k)
% vx(k+1) = vx(k) + T*ax(k) (easting velocity)
% vy(k+1) = vy(k) + T*ay(k) (northing velocity)
% w(k+1) = w(k) + T*ah(k)]
% ax(k+1) = ax(k)
% ay(k+1) = ay(k)
% ah(k+1) = ah(k)

% X(k+1) = F(k)*X(k) + G(k)*U(k) + wk (process)
% Y(k+1) = H*X(k) + vk (noise)
% U = [ax; ay; ah] Inputs - unknown. 

%% Initialisation
nNavFile = size(navFile,1);
% Observation times
t = navFile.GPSTIMES;
ts = diff(t); % time differences - this is how I estimate the velocity.
% extract observations
x = navFile.XCOORD; y = navFile.YCOORD; h = navFile.HEADING;

ts = [0.1;ts];
% first filtered value will be first reading
xFilt = x(1); yFilt = y(1); hFilt = h(1);

% initial state estimates
%    x    y    heading  vx  vy  w (angle velocity) ax ay aw
X = [x(1);y(1);h(1);10;10;0;0;0;0];
% initialise covariance matrix
P = diag([10,10,10,10,10,10,10,10,10]);

% process error - how noisy is my dynamical model?
sigmaAx = 50; sigmaAy = 50; sigmaAh = 50;
% measurement error - this is how much I believe the GPS
sigmaGPS = 4;
sigmaH = 20;
R = diag([sigmaGPS^2,sigmaGPS^2,sigmaH^2]);

nStates = size(X,1);

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
    F = [1 0 0 T 0 0 T^2/2 0 0; % x
         0 1 0 0 T 0 0 T^2/2 0; % y
         0 0 1 0 0 T 0 0 T^2/2; % h
         0 0 0 1 0 0 T 0 0; % vx
         0 0 0 0 1 0 0 T 0; % vy
         0 0 0 0 0 1 0 0 T;
         0 0 0 0 0 0 1 0 0;
         0 0 0 0 0 0 0 1 0;
         0 0 0 0 0 0 0 0 1;]; % vh
    % input matrix
    % noise matrix - defined by var(w)
    Q = diag([0,0,0,0,0,0,sigmaAx^2,sigmaAy^2,sigmaAh^2]);

    % prediction 
    XPriori = F*X; % state
    %heading correction
    if abs(XPriori(3) - h(iNav)) > 60
        XPriori(3)= h(iNav);
    end
    PPriori = F*P*F' + Q; % error
    
    % observation matrix we only record x,y,h 
    H = [1 0 0 0 0 0 0 0 0;
         0 1 0 0 0 0 0 0 0;
         0 0 1 0 0 0 0 0 0];     
    % update
    % Innovation measurement
    zk = [x(iNav);y(iNav);h(iNav)];
    
    yk =  zk - H*XPriori;
    % Innovation covariance
    S = H*PPriori*H' + R;
    % kalman gain
    K = PPriori*H'*inv(S);

    % posterior state estimate
    XPost = XPriori + K*yk;
    xFilt(end+1) = XPost(1);
    yFilt(end+1) = XPost(2);
    hFilt(end+1) = XPost(3);

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
navFile.HEADINGFILT = hFilt';
end