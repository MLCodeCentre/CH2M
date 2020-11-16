function myIMM(navFile)

%% Initialisation
nNavFile = size(navFile,1);
% Observation times    
t = navFile.GPSTIMES;
ts = diff(t); % time differences - this is how I estimate the velocity.

% extract observations
x = navFile.XCOORD; y = navFile.YCOORD; theta = navFile.HEADING;
vx(1) = (x(2)-x(1))/ts(1);
vy(1) = (y(2)-y(1))/ts(1);

initialState = [x(1);vx(1);y(1);vy(1);0;0];
initialCovariance = diag([3,1e4,3,1e4,3,1e4]); % Velocity is not measured
positionSelector = [1 0 0 0 0 0;0 0 1 0 0 0;0 0 0 0 1 0]; % Position from state

sigmaMeasRange = linspace(0.001,0.002,10);
sigmaProcessRange = linspace(0.001,0.002,10);
%sigmaMeas = 0.1;

imm = trackingIMM();
initialize(imm, initialState, initialCovariance);

cla
hold on;
axis equal;
    
i = 1;
for sigmaMeas = sigmaMeasRange
    j = 1;
    for sigmaProcess = sigmaProcessRange
        logL(i,j) = getIMMLogL(imm,x,y,theta,ts,positionSelector,sigmaMeas,sigmaProcess);
        fprintf("sigmaMeas: %.5f sigmaProcess: %.5f logL: %.5f \n",sigmaMeas,sigmaProcess,logL(i,j));
        j = j + 1;
    end
    i = i + 1;
end

end

function logL = getIMMLogL(imm,x,y,theta,ts,positionSelector,sigmaMeas,sigmaProcess)
    
    imm.MeasurementNoise = diag([sigmaMeas,sigmaMeas,0]);
    imm.TrackingFilters{1,1}.ProcessNoise = diag([sigmaProcess,sigmaProcess,sigmaProcess]);
    imm.TrackingFilters{2,1}.ProcessNoise = diag([sigmaProcess,sigmaProcess,sigmaProcess]);
    imm.TrackingFilters{3,1}.ProcessNoise = diag([sigmaProcess,sigmaProcess,sigmaProcess,sigmaProcess]);

    navTestInd = 500;
    estPos(:,1) = [x(1);y(1);0];
    estHeading(1) = theta(1);

    for iNav = 2:navTestInd
        %fprintf('Filtering %d/%d images\n',iNav,navTestInd);
        predict(imm,ts(iNav-1));
        meas = [x(iNav);y(iNav);0];
        % likelihood 
        l(iNav-1) = likelihood(imm,meas);
        correctedState = correct(imm,meas);
        estPos(:,iNav) = positionSelector * correctedState;
        estHeading(iNav) = rad2deg(atan2(correctedState(2),correctedState(4)));
        %estHeading(iNav)
        %theta(iNav)
        %plot(x(iNav),y(iNav),'ro')
        modelInd = find(imm.ModelProbabilities==max(imm.ModelProbabilities));
        modelCols = {'b','g','m'};
        plotHeading(estPos(1,iNav),estPos(2,iNav),estHeading(iNav),modelCols{modelInd})
        plotHeading(x(iNav),y(iNav),theta(iNav),'k')
    end
    logL = sum(log(l));
end