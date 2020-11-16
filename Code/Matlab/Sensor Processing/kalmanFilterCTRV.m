function [navFile,XPosts,PPosts,Q,innovationSequence,innovationCov,detP] = kalmanFilterCTRV(navFile,sigmav,sigmaw,sigmaGPS,sigmaTheta)
% KALMANFILTER kalman filter to smooth GPS and heading readings from the sensor. 
% X(k+1) = f(X(k),vk)
navFile = navFile(1:6000,:);

%% Initialisation
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
%    x    y    heading  vx  vy  w (angle velocity) ax ay aw
X0 = [x(1);y(1);theta(1);20;10];
nStates = size(X0,1);
% initialise covariance matrix
P0 = 1000*eye(nStates);

% process error - how noisy is my dynamical model?
Q = diag([0,0,0,sigmav^2,sigmaw^2]);
% measurement error - this is how much I believe the GPS
R = diag([sigmaGPS^2,sigmaGPS^2]);

% memory allocation
XPosts = zeros(nStates,nNavFile);
XPosts(:,1)= X0; % Initial posterior is just initial conditions
PPosts = zeros(nNavFile,nStates,nStates);
PPosts(1,:,:) = P0;

P = P0;
X = X0;

    % observation matrix we only record x,y
H = [1 0 0 0 0;
     0 1 0 0 0;];
nObs = size(H,1);
innovationCov = zeros(nNavFile,nObs,nObs);
innovationCov(1,:,:) = H*P*H' + R; 
innovationSequence = H*X0-[x(1);y(1);];
detP(1) = det(H*P*H' + R);

%% Filtering
for iNav = 2:nNavFile
    % step up kalman matrices as time step changes from reading to reading
    T = ts(iNav);
    
    % prediction 
    XPriori = f(X,T); % state
    Fk = F(X,T);
    PPriori = Fk*P*Fk' + Q; % error
     
    % update
    % Innovation measurement
    zk = [x(iNav);y(iNav);];
    yk =  zk - H*XPriori;
    if any(yk > 20)
        disp('large Yk')
        %fprintf('Theta Obs: %2.2f, theta pred: %2.2f\n',zk(3))
     end
    innovationSequence(:,iNav) = yk;
    % Innovation covariance
    Sk = H*PPriori*H' + R;
    innovationCov(iNav,:,:) = Sk;
    %detP(iNav) = det(Sk);
    % kalman gain
    K = PPriori*H'*inv(Sk);
    
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
navFile.XCOORDOLD = x;
navFile.YCOORDOLD = y;
navFile.HEADINGOLD = theta;
navFile.XCOORD = xFilt';
navFile.YCOORD = yFilt';
navFile.HEADING = thetaFilt';

plotNavFileKF(navFile)
end

function fx = f(X,T)
x = X(1); y = X(2); theta = X(3);
v = X(4); w = X(5);
fx = [x + v/w*(sin(T*w + theta) - sin(theta));
      y + v/w*(-cos(T*w + theta) + sin(theta));
      w*T + theta;
      v;
      w];
fx(3) = mod(fx(3),360);
end

function Fx = F(X,T)
x = X(1); y = X(2); theta = X(3);
v = X(4); w = X(5);
Fx=[1 0 v*(cos(T*w+theta)-cos(theta))/w (sin(T*w+theta)-sin(theta))/w  (-v*(sin(T*w+theta)-sin(theta))/w^2 + v*T*cos(T*w+theta)/w);
    0 1 v*(sin(T*w+theta)+cos(theta))/w (-cos(T*w+theta)+sin(theta))/w (-v*(-cos(T*w+theta)+sin(theta))/w^2 + v*T*sin(T*w+theta)/w);
    0 0 1 0 T;
    0 0 0 1 0;
    0 0 0 0 1];
end

