function navFile = fixHeadingsCentralDiff(navFile)
% Fixes headings by employing a central differencing scheme from the
% positional data of the (i-1)th and (i+1)th image. 

N = 1;
headings = navFile.HEADING;
XCOORD = navFile.XCOORD;
YCOORD = navFile.YCOORD;
% add to start
headingsCorrected = headings;
ts = diff(navFile.GPSTIMES);
ts = [0.1;ts];

nHeadings = size(headings,1);
for iHeading = N+1:nHeadings-N
    xMinus1 = XCOORD(iHeading-N);
    xPlus1 = XCOORD(iHeading+N);
    yMinus1 = YCOORD(iHeading-N);
    yPlus1 = YCOORD(iHeading+N);
    dx = xPlus1-xMinus1;
    dy = yPlus1-yMinus1;
    headingCorrected = rad2deg(mod(atan2(dx,dy),2*pi));
    if ~(abs(ts(iHeading)) > 1 || abs(ts(iHeading-1)) > 1 || abs(ts(iHeading+1)) > 1)
        headingsCorrected(iHeading) = headingCorrected;
    else
        %disp('Large time step')
        ts(iHeading-1:iHeading+1);
    end
end

navFile.HEADING = headingsCorrected;
%plotHeadings(navFile)
end
