function navFile = centralDiffOrder4(navFile)

headings = navFile.HEADING;
XCOORD = navFile.XCOORD;
YCOORD = navFile.YCOORD;

headingsCorrected = headings;

nHeadings = size(headings,1);
for iHeading = 7:nHeadings-7
    % f(x +- h)
    xMinus1 = XCOORD(iHeading-1);
    xPlus1 = XCOORD(iHeading+1);
    % f(x +- 2h)
    xMinus2 = XCOORD(iHeading-2);
    xPlus2 = XCOORD(iHeading+2);
    
    % create the 12h by 6 YCOORD readings
    yMinus6 = YCOORD(iHeading-6);
    yPlus6 = YCOORD(iHeading+6);
    
    dx = - xPlus2 + 8*xPlus1 - 8*xMinus1 + xMinus2;
    dy = yPlus6-yMinus6;
    headingCorrected = rad2deg(mod(atan2(dx,dy),2*pi));
    headingsCorrected(iHeading) = headingCorrected;
end

navFile.HEADING = headingsCorrected;
navFile.HEADINGOLD = headings;
plotHeadings(navFile)
end