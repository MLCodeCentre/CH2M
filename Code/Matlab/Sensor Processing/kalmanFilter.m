function navFile = kalmanFilter(navFile)
% KALMANFILTER kalman filter to smooth GPS and heading readings from the sensor. 
% We use a dynamical model of a vehicle to estimate the state: ()
% x(k+1) = x(k) + ts*vx(k)  (easting)
% y(k+1) = y(k) + ts*vy(k)  (northing)
% vx(k+1) = vx(k) (foward velocity)
% vy(k+1) = vy(k) (horizontal velocity)

%% Initialisation

nNavFile = size(navFile,1);
% Observation times
t = navFile.GPSTIMES;
ts = diff(t); % time differences - this is how I estimate the velocity.
% extract observations
x = navFile.XCOORD; y = navFile.YCOORD;

vx = [20;diff(x)./ts]; vy = [20;diff(y)./ts];
ts = [0.1;ts];
% first filtered value will be first reading
xFilt = x(1); yFilt = y(1);
vxFilt = vx(1); vyFilt = vy(1);
% initialise covariance matrix
%P = diag([std(x)^2,std(y)^2,std(h)^2,std(vx)^2,std(vy)^2,std(w)^2,]);
P = 1000*eye(4);
% initial state estimates
%    x    y    heading  vx [ms-1] vy [ms-1] w (angle velocity)
X = [x(1);y(1);vx(1);vy(1)];

% process error - how noisy is my dynamical model?
sigmaXQ = 1; %standard deviation vx
sigmaYQ = 1; %standard deviation vy
sigmaVxQ = 5;
sigmaVyQ = 5;

Q = diag([sigmaXQ^2,sigmaYQ^2,sigmaVxQ^2,sigmaVyQ^2]);
 
% measurement error - this is how much I believe the GPS
sigmaXR = 1; %standard deviation vx
sigmaYR = 1; %standard deviation vy
sigmaVxR = 10;
sigmaVyR = 10;

R = diag([sigmaXR^2,sigmaYR^2,sigmaVxR^2,sigmaVyR^2]);
%% Filterings
for iNav = 2:nNavFile
    % step up kalman matrices as time step changes from reading to reading
    % define the state matrix Xk+1 = F*Xk (6x6) in keeping with wikipedia
    F=[1 0 ts(iNav) 0; 0 1 0 ts(iNav); 0 0 1 0; 0 0 0 1;];
    % %define the input matrix, inputs are acceleration Xk+1 = A*Xk +
    
    % prediction 
    XPriori = F*X; % state
    PPriori = F*P*F' + Q; % error   

    % update
    % Innovation 
    yk = [x(iNav);y(iNav);vx(iNav);vy(iNav);] - XPriori;
    % covariance
    S = PPriori + R;
    % kalman gain
    K = PPriori*inv(S);
    
    % posterior state estimate
    XPost = XPriori + K*yk;
    xFilt(end+1) = XPost(1);
    yFilt(end+1) = XPost(2);
    vxFilt(end+1) = XPost(3);
    vyFilt(end+1) = XPost(4);

    % posterior covariance estimate
    PPost = (eye(4) - K)*PPriori;
    
    % update X and P
    X = XPost; P = PPost;
end

% updating 
navFile.XCOORDFILT = xFilt';
navFile.YCOORDFILT = yFilt';
navFile.VELOCITY = sqrt(vxFilt'.^2 + vyFilt'.^2);
%navFile.HEADINGFILT = hFilt';
end