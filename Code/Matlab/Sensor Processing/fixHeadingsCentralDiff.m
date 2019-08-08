function navFile = fixHeadingsCentralDiff(navFile)
% Fixes headings by employing a central differencing scheme from the
% positional data of the (i-1)th and (i+1)th image. 

N = 1;

headings = navFile.HEADING;
XCOORD = navFile.XCOORD;
YCOORD = navFile.YCOORD;
% add to start
headingsCorrected(1:N,1) = headings(1:N);

nHeadings = size(headings,1);
for iHeading = N+1:nHeadings-N
    xMinus1 = XCOORD(iHeading-N);
    xPlus1 = XCOORD(iHeading+N);
    yMinus1 = YCOORD(iHeading-N);
    yPlus1 = YCOORD(iHeading+N);
    dx = xPlus1-xMinus1;
    dy = yPlus1-yMinus1;
    headingCorrected = rad2deg(mod(atan2(dx,dy),2*pi));
    headingsCorrected(end+1,1) = headingCorrected;
end

% add to the end
headingsCorrected(end:end+N,1) = headings(end-N:end);

navFile.HEADINGCD = headingsCorrected;
%plotHeadings(navFile)
end
