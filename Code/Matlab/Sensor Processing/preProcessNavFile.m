function navFile = preProcessNavFile(navFile,sigmaAcc,sigmaGPS,showPlot)
% PREPROCESSNAVFILE performs a kalman filter then smoother on the XCOORD
% and YCOORD fields in the navFile, then a central differencing scheme to
% correct the HEADINGS field. 

% first we split the navFile into sections
navFileSections = splitNavFile(navFile,false);
nSections = size(navFileSections,2);

XCOORDFILT = [];
YCOORDFILT = [];
HEADINGFILT = [];
XCOORDSMOOTH = [];
YCOORDSMOOTH = [];
%HEADINGSMOOTH = [];

covariances = [];
for iSection = 1:nSections
    navFileSection = navFileSections{iSection};
    [navFileSection,X,P] = kalmanFilterPosition(navFileSection,sigmaAcc,sigmaGPS); % kalman filter
    [navFileSection,~,Ps] = RTSsmoother(navFileSection,X,P,sigmaAcc); % kalman smoother
    %[navFileSection,X,P,sigmaAcc] = constantVelocityVehicleKF(navFileSection); % kalman filter
        
    XCOORDFILT = [XCOORDFILT;navFileSection.XCOORDFILT];
    YCOORDFILT = [YCOORDFILT;navFileSection.YCOORDFILT];
    XCOORDSMOOTH = [XCOORDSMOOTH;navFileSection.XCOORDSMOOTH];
    YCOORDSMOOTH = [YCOORDSMOOTH;navFileSection.YCOORDSMOOTH];
    covariances = [covariances;Ps];   
end

% cla; hold on;
% scatter(navFile.XCOORD,navFile.YCOORD,'.'); 
% scatter(XCOORDFILT,YCOORDFILT,'.');

% update navFile
navFile.XCOORDOLD = navFile.XCOORD;
navFile.YCOORDOLD = navFile.YCOORD;
navFile.XCOORD = XCOORDSMOOTH;
navFile.YCOORD = YCOORDSMOOTH;

% HEADING
navFile.HEADINGOLD = navFile.HEADING;
navFile = fixHeadingsCentralDiff(navFile); % central difference

if showPlot
    plotCorrections(navFile,covariances); % plotting
end

%% This is for the kalman filter tuning work.
end