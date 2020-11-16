function kalmanFilterVehicleModel(navFile)
% KALMANFILTER kalman filter to smooth GPS and heading readings from the sensor. 
% We use a dynamical model of a vehicle described in matlab link below
%  to estimate the state: 

% https://uk.mathworks.com/help/ident/examples/state-estimation-using-time-
% varying-kalman-filter.html

% x(k+1) = x(k) + v(k)*sin(h(k))*ts (easting)
% y(k+1) = y(k) + v(k)*cos(h(k))*ts (northing)
% h(k+1) = h(k) + v*tan(phi)/L*ts (heading)
% v(k+1) = v(k) (velocity)
% phi(k+1) =  phi(k)(steering angle) 

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
vFilt = 10; phiFilt = 0;

% initial state estimates
%    x    y    heading  v phi (angle velocity) a
X = [x(1);y(1);h(1);10;0];
% initialise covariance matrix
P = 10*eye(5);

% process error - how noisy is my dynamical model?
sigmaThrottle = 5;
sigmaSteering = 10;
Q = diag([0,0,0,sigmaThrottle^2,sigmaSteering^2]);
% measurement error - this is how much I believe the GPS
sigmaGPS = 2;
sigmaH = 10;
R = diag([sigmaGPS^2,sigmaGPS^2,sigmaH^2]);

% memory allocation
XPosts = zeros(5,nNavFile);
XPosts(:,1) = X; % Initial posterior is just initial conditions
PPosts = zeros(nNavFile,5,5);

%% Filtering
for iNav = 2:nNavFile
    % step up kalman matrices as time step changes from reading to reading
    T = ts(iNav);          
    % prediction 
    XPriori = transition(X,T); % state
    % linearise
    F = dFdx(X,T);
    PPriori = F*P*F' + Q; % error
    
    % observation matrix we only record x,y
    H = [1 0 0 0 0;
         0 1 0 0 0;
         0 0 1 0 0];     
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
    vFilt(end+1) = XPost(4);
    phiFilt(end+1) = XPost(5);
        
    % posterior covariance estimate
    PPost = (eye(5) - K*H)*PPriori;
    
    % saving posterior covariance and states
    XPosts(:,iNav) = XPost;
    PPosts(iNav,:,:) = PPost;  
           
    % update X and P
    X = XPost; P = PPost;   
end
% updating 
navFile.XCOORDOLD = x;
navFile.YCOORDOLD = y;
navFile.HEADINGOLD = h;
navFile.XCOORD = xFilt';
navFile.YCOORD = yFilt';
navFile.HEADING = hFilt';

subplot(4,2,1:4);
plotCorrections(navFile,PPosts)
subplot(4,2,5:6)
plot(vFilt(50:70));
subplot(4,2,7:8)
plot(phiFilt(50:400));

end

function Xk = transition(X,T)
    % state transition function
    L = 1; %GPS to axel distance
    x = X(1); y = X(2); h = X(3); v = X(4); phi = X(5);
    Xk = [x + v*cos(h)*T;
          y + v*sin(h)*T;
          h + (v*tan((phi))/L)*T;
          v; 
          phi];
end

function F = dFdx(X,T)
    % Linearised system (EKF)
    L = 1;
    x = X(1); y = X(2); h = X(3); v = X(4); phi = X(5);
    F=[1 0  v*cos(h)*T sin(h)*T     0; % x
       0 1 -v*sin(h)*T cos(h)*T     0; % y
       0 0  1          tan(phi)*T/L (v*sec(phi)^2/L)*T; % h
       0 0  0          1            0; % v
       0 0  0          0            1]; % phi
end