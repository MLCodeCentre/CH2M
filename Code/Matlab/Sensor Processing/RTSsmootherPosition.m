function [navFile,Xs,Ps] = RTSsmootherPosition(navFile,X,P,sigmaAcc)
% Rauch-Tung-Stiebel smoother smooths the filtered state estimates X and
% covariances P.
% Inputs:
%   X (nStateEstimates,nStates,nStates) - filtered state estimates
%   P (nStateEstimates,nStates,nStates) - filtered covariance estimates

t = navFile.GPSTIMES;
ts = diff(t); % time differences - this is how I estimate the velocity.
ts = [0.1;ts];

nStates = size(X,1);
nStateEstimates = size(X,2);
Xs = zeros(size(X));
Ps = zeros(size(P));

Q = diag([0,0,0,0,sigmaAcc^2,sigmaAcc^2]);

Xs(:,nStateEstimates) = X(:,nStateEstimates);
Ps(nStateEstimates,:,:) = P(nStateEstimates,:,:);

for k = nStateEstimates-1:-1:1 % backwards pass
    % time step at k+1
    T = ts(k);
    % state transition
    F=[1 0 T 0 T^2/2 0; % x
       0 1 0 T 0 T^2/2; % y
       0 0 1 0 T 0; % vx
       0 0 0 1 0 T
       0 0 0 0 1 0
       0 0 0 0 0 1]; % vk
       
    Xk = X(:,k);
    Pk = reshape(P(k,:,:),nStates,nStates);
    
    XPriori = F*Xk;   
    PPriori = F*Pk*F' + Q;
    
    Ck = Pk*F'*inv(PPriori);
    % smoothing
    Xs(:,k) = Xk + Ck*(Xs(:,k+1)-XPriori);
    Ps(k,:,:) = Pk + Ck*(reshape(Ps(k+1,:,:),nStates,nStates)-PPriori);
end

navFile.XCOORDSMOOTH = Xs(1,:)';
navFile.YCOORDSMOOTH = Xs(2,:)';