function kalmanCalibration(trackedPoints,trackedCoords)

road = 'A27'; %year = 'Year3';
%m = 2464; n = 2056;
m = 2560; n = 2048;
trackedPoints = trackedPoints(:,1:100,:);

nImages = size(trackedPoints,1);
nPoints = size(trackedPoints,2);

% begin with an estimate for the state vector
alphaInit = 0; betaInit = -0.1; gammaInit = 0;
x0Init = 2; y0Init = 0; hInit = 2.5;
fuInit = 2000; fvInit = 2000;
X = [alphaInit,betaInit,gammaInit,x0Init,y0Init,hInit,fuInit,fvInit]';

sigmaAlphaInit = 1; sigmaBetaInit = 1; sigmaGammaInit = 1;
sigmax0Init = 4; sigmay0Init = 2; sigmahInit = 2.5;
sigmafuInit = 100; sigmafvInit = 100;

S = [sigmaAlphaInit,sigmaBetaInit,sigmaGammaInit,...
    sigmax0Init,sigmay0Init,sigmahInit,...
    sigmafuInit,sigmafvInit]';

% Process Error
sigmaAngleProcess = 0; sigmaOffsetProcess = 0; sigmaFocalProcess = 0;
R = [sigmaAngleProcess,sigmaAngleProcess,sigmaAngleProcess,...
    sigmaOffsetProcess,sigmaOffsetProcess,sigmaOffsetProcess,...
    sigmaFocalProcess,sigmaFocalProcess]';

% % Measurement Error
% sigmaAngleMeasure = 0.1; sigmaOffsetMeasure = 0.3; sigmaFocalMeasure = 500;
% Q = [sigmaAngleMeasure,sigmaAngleMeasure,sigmaAngleMeasure,...
%     sigmaOffsetMeasure,sigmaOffsetMeasure,sigmaOffsetMeasure,...
%     sigmaFocalMeasure,sigmaFocalMeasure]';

% adding, a state and each error for the coordinates
Q = [];
sigmaCoord = 10;
sigmaCoordProcess = 0;
sigmaPixelMeasure = 500;
for iPoint = 1:nPoints
   X = [X;30;5;2];
   S = [S;sigmaCoord;sigmaCoord;sigmaCoord];
   R = [R;sigmaCoordProcess;sigmaCoordProcess;sigmaCoordProcess];
   Q = [Q;sigmaPixelMeasure;sigmaPixelMeasure];
   
end

nStates = size(X,1);
S = eye(nStates).*S;
R = eye(nStates).*R;
Q = eye(2*nPoints).*Q;

%% Kalman updating
for iImage = 1:nImages
    vehicleChange = trackedCoords(iImage,:) - trackedCoords(1,:);
    % transition
    Xbar = transitionFunction(X,vehicleChange,nPoints);
    Coordsbar = reshape(Xbar(8+1:end),3,[])
    G = eye(nStates); % jacobian of transition is just identity
    Sbar = G*S*G' + R; 
    H = constructJacobian(Xbar,nPoints); % measurement jacobian
    K = S*H'*inv(H*Sbar*H' + Q); % kalman gain
    % predict
    projections = predictPixels(Xbar,m,n)';
    % update
    z = trackedPoints(iImage,:)';
    norm(z-projections)
    X = Xbar + K*(z-projections);
    S = (eye(nStates) - K*H)*Sbar;
    
    Coords = reshape(X(8+1:end),3,[])'
    Es(iImage,:) = X;
    Vars(iImage,:) = diag(S);
end

createInfoBoard(Es,Vars)

end