function [navFile,Xs,Ps] = RTSsmoother(navFile,X,P,sigmaAcc)
% Rauch-Tung-Stiebel smoother smooths the filtered state estimates X and
% covariances P.
% Inputs:
%   X (nStateEstimates,nStates,nStates) - filtered state estimates
%   P (nStateEstimates,nStates,nStates) - filtered covariance estimates

t = navFile.GPSTIMES;
ts = diff(t); % time differences - this is how I estimate the velocity.
ts = [0.1;ts];

% process error - how noisy is my dynamical model?
Qb = diag([sigmaAcc,sigmaAcc,sigmaAcc]);
% measurement error - this is how much I believe the GPS

nStates = size(X,1);
nStateEstimates = size(X,2);
Xs = zeros(size(X));
Ps = zeros(size(P));

Xs(:,nStateEstimates) = X(:,nStateEstimates);
Ps(nStateEstimates,:,:) = P(nStateEstimates,:,:);

for k = nStateEstimates-1:-1:1 % backwards pass
    % time step at k+1
    T = ts(k);
    % state transition
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
    
    Xk = X(:,k);
    Pk = reshape(P(k,:,:),nStates,nStates);
    
    XPriori = F*Xk;   
    PPriori = F*Pk*F' + Q;
    
    Ck = Pk*F'*inv(PPriori);
    % smoothing
    Xs(:,k) = Xk + Ck*(Xs(:,k+1)-XPriori);
    if abs(Xs(3,k) - X(3,k)) > 30
       %disp('headings')
       %Xs(3,k) = X(3,k);
    end
    
    Ps(k,:,:) = Pk + Ck*(reshape(Ps(k+1,:,:),nStates,nStates)-PPriori);
end

navFile.XCOORDSMOOTH = Xs(1,:)';
navFile.YCOORDSMOOTH = Xs(2,:)';
navFile.HEADINGSMOOTH = Xs(3,:)';