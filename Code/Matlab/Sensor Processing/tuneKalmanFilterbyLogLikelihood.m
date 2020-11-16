function tuneKalmanFilterbyLogLikelihood(navFile)

navFilePlot = navFile;
navFile = navFile(3800:4200,:);
% theta = x0,               y0,                vx0, vy0, ax0, ay0, Px0, Py0, Pvx0,Pvy0 Pax0, Paxy0,sigmaGPS,sigmaAcc
theta0 = [1,  1];
LB = [0.1,  0.1];
UB = [10, 5];

fncMin = @(theta) kalmanFilterFnc(theta,navFile);

options = optimset('Display','iter');
[x,fval] = fmincon(fncMin,theta0,[],[],[],[],LB,UB,[],options);

% X0 = x(1:6)
% P0 = x(7:12)
sigmaAcc = x(1)
sigmaGPS = x(2)
fval

preProcessNavFile(navFilePlot,sigmaAcc,sigmaGPS,true);
end

function nLogL = kalmanFilterFnc(theta,navFile)

sigmaAcc = theta(1); sigmaGPS = (3); 
[~,~,~,~,v,Pt,detP] = kalmanFilterPosition(navFile,sigmaAcc,sigmaGPS);
%[~,~,~,~,v,Pt,detP] = kalmanFilterConstantVel(navFile,sigmaAcc,sigmaAcctheta,sigmaGPS,sigmaTheta,false);
logL = 0;
for i = 1:size(v,2)
    logL = logL + -0.5*(log(detP(i)) + v(:,i)'*inv(reshape(Pt(i,:,:),2,2))*v(:,i));
end
nLogL = -logL;
end

