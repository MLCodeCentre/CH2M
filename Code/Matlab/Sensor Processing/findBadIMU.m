function findBadIMU(navFile)
%FINDBADIMU Idenifies where in the navfile the predicted IMU reading is
% different to the recorded.
close all; figure; hold on;
L = 2; MAX_DIST = 0.1;
nBad = 0;
nNav = size(navFile,1);
for iNav = 1:nNav-1
    % extract current position and heading
    nav = navFile(iNav,:);
    x = nav.XCOORD; y = nav.YCOORD; heading = nav.HEADING; 
    % guess next position. 
    xPred = x + (L*sin(deg2rad(heading)));
    yPred = y + (L*cos(deg2rad(heading)));
    % get recorded next position
    navNext = navFile(iNav+1,:);
    xNext = navNext.XCOORD; yNext = navNext.YCOORD; headingNext = navNext.HEADING;
    % distance between predicted and next. 
    dist = sqrt((xNext-xPred)^2 + (yNext-yPred)^2);
    % if dist is greater than MAX_DIST, then plot and the one before, as this is innacurate.
    if dist > MAX_DIST
        plot(x,y,'ko'); % current
        x2 = x + (1*sin(deg2rad(heading))); % heading direction
        y2 = y + (1*cos(deg2rad(heading)));
        plot([x x2],[y y2],'r--')
        plot(xNext,yNext,'ko'); % next
        x2 = xNext + (1*sin(deg2rad(headingNext))); % heading direction
        y2 = yNext + (1*cos(deg2rad(headingNext)));
        plot([xNext x2],[yNext y2],'r--')
        nBad = nBad + 1; % update counter
    else % plot a dot.
%         plot(x,y,'k.')
    end
end
fprintf('%d bad IMU readings found\n',nBad)
end