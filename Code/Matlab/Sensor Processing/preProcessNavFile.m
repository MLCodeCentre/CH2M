function navFile = preProcessNavFile(navFile,road,sigmaAcc,sigmaGPS,showPlot,saveNav)
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
HEADINGSMOOTH = [];
%covariances = [];
for iSection = 1:nSections
    navFileSection = navFileSections{iSection};
    [navFileSection,X,P] = kalmanFilterPosition(navFileSection,sigmaAcc,sigmaGPS); % kalman filter
    [navFileSection,~,Ps] = RTSsmoother(navFileSection,X,P,sigmaAcc); % kalman smoother
    %[navFileSection,X,P,sigmaAcc] = constantVelocityVehicleKF(navFileSection); % kalman filter
        
    XCOORDFILT = [XCOORDFILT;navFileSection.XCOORDFILT];
    YCOORDFILT = [YCOORDFILT;navFileSection.YCOORDFILT];
    HEADINGFILT = [HEADINGFILT;navFileSection.HEADINGFILT];
    XCOORDSMOOTH = [XCOORDSMOOTH;navFileSection.XCOORDSMOOTH];
    YCOORDSMOOTH = [YCOORDSMOOTH;navFileSection.YCOORDSMOOTH];
    HEADINGSMOOTH = [HEADINGSMOOTH;navFileSection.HEADINGSMOOTH];
end
navFileSections = splitNavFile(navFile,false);
nSections = size(navFileSections,2);

% update navFile
navFile.XCOORDOLD = navFile.XCOORD;
navFile.YCOORDOLD = navFile.YCOORD;
navFile.HEADINGOLD = navFile.HEADING;
navFile.XCOORD = XCOORDSMOOTH;
navFile.YCOORD = YCOORDSMOOTH;
navFile.HEADING = HEADINGSMOOTH;
% navFile.XCOORD = XCOORDFILT;
% navFile.YCOORD = YCOORDFILT;
% navFile.HEADING = HEADINGFILT;

if showPlot
    %plotCorrections(navFile,covariances); % plotting
    plotNavFileKF(navFile);
end

%% This is for the kalman filter tuning work.
if saveNav
    disp('saving nav file')
    writetable(navFile,fullfile(dataDir(),road,'Nav','nav_smoothed.csv'));
end