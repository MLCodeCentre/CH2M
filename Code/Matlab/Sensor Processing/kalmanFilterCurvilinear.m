function kalamanFilterCurvilinear(navFile)
%%
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
    
    X = [x(1);vx(1);y(1);vy(1);1;1];
    
    nStates = size(X,1);
    % initialise covariance matrix
    P = 100*eye(nStates);

    % process error - how noisy is my dynamical model?
    sigmaGPS = 1;
    q = 1;
    Q = diag([q,q,q,q,q^2,q^2]);
    % measurement error - this is how much I believe the GPS
    R = diag([sigmaGPS^2,sigmaGPS^2]);

    % memory allocation
    XPosts = zeros(nStates,nNavFile);
    XPosts(:,1)= X; % Initial posterior is just initial conditions
    PPosts = zeros(nNavFile,nStates,nStates);
    PPosts(1,:,:) = P;
    innovationSeq = [];
    % observation matrix
    H = [1 0 0 0 0 0;
         0 0 1 0 0 0];
    
    cla; hold on; axis equal;
    %% KF
    for iNav = 2:100
        T = ts(iNav);
        % define the state matrix Xk+1 = F*Xk (9x9) in keeping with wikipedia
        at = X(5); an = X(6);
        
        F=[0, 1, 0, 0, 0, 0; % x
           0, at*fvxvx(X) + an*fvyvx(X), 0, at*fvxvy(X) + an*fvyvy(X), fvx(X), fvy(X); % y
           0, 0, 0, 1, 0, 0; % theta
           0, at*fvyvx(X) - an*fvxvx(X), 0, at*fvyvy(X) - an*fvxvy(X), fvx(X), -fvy(X); % v
           0, 0, 0, 0, 0, 0;
           0, 0, 0, 0, 0, 0]; % w
       
        XPriori = X + f(X).*T; % state
        Pdot = F*P + P*F' + Q;
        PPriori = P + Pdot*T; % error
        
        zk = [x(iNav);y(iNav)];
        yk =  zk - H*XPriori;
        innovationSeq(end+1,:) = yk;
        % Innovation covariance
        S = H*PPriori*H' + R;
        % kalman gain
        K = PPriori*H'*inv(S);

        % posterior state estimate
        XPost = XPriori + K*yk;
        heading = rad2deg(atan2(XPost(2),XPost(4)));
        plotHeading(XPost(1),XPost(3),heading,'r')
        plotHeading(x(iNav),y(iNav),theta(iNav),'k')
        fprintf("vx: %.2f, vy: %.2f, theta: %.2f, thetaIMU: %.2f\n",XPost(2),XPost(4),heading,theta(iNav))
        
        X = XPost;
        
    end

end

function Xpred = f(X)
    x = X(1); vx = X(2); y = X(3); vy = X(4); at = X(5); an = X(6);
    Xpred = [vx; 
             at*fvx(X) + an*fvy(X); 
             vy; 
             at*fvy(X) + an*fvx(X);
             0;
             0];
end

function f = fvx(X)
    f = X(2)/(sqrt(X(2)^2 + X(4)^2));
end

function f = fvy(X)
    f = X(4)/(sqrt(X(2)^2 + X(4)^2));
end

function f = fvxvx(X)
    f = (X(2)^2)/((X(2)^2 + X(4)^2)^(1.5));
end

function f = fvxvy(X)
    f = (X(2)*X(4))/((X(2)^2 + X(4)^2)^(1.5));
end

function f = fvyvx(X)
    f = (X(4)*X(2))/((X(2)^2 + X(4)^2)^(1.5));
end

function f = fvyvy(X)
    f = (X(4)^2)/((X(2)^2 + X(4)^2)^(1.5));
end