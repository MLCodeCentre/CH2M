function [vanishingPoint,laneMarkers] = findLinesAndIntersection(lines,img)
    
    BUFF = 30;

    laneMarkers = [];
    % find longest line on the left and right from angles.
    maxRightLen = 0; maxLeftLen = 0;    
    nLines = length(lines);
    for iLine = 1:nLines
        lineLen = norm(lines(iLine).point1 - lines(iLine).point2);
        angle = lines(iLine).theta;
        if abs(angle) < 60
            
            if angle > 0 && lineLen > maxLeftLen
                maxLeftLine = iLine;
                maxLeftLen = lineLen;
            elseif angle < 0 && lineLen > maxRightLen
                maxRightLine = iLine;
                maxRightLen = lineLen;
            end
        end
        % collecting right lines for lane markers
        if lines(iLine).theta < 0
            xy = lines(iLine).point1;
            if size(laneMarkers,1) > 0
                if all(abs(xy(1) - laneMarkers(:,1)) > BUFF) ...
                        && all(abs(xy(2) - laneMarkers(:,2)) > BUFF)
                    laneMarkers = [laneMarkers;xy];
                end
            else
                laneMarkers = [laneMarkers;xy];
            end
        end       
    end
    % plotting for visualisation ease
    imshow(img); hold on
    
    % hough lines don't gaurantee consistent top and bottom ordering so..
    % --------- LEFT --------- %
    xy1 = lines(maxLeftLine).point1; xy2 = lines(maxLeftLine).point2;
    if xy1(2) > xy2(2)
        xybLeft = xy1;
        xytLeft = xy2;
    else
        xybLeft = xy2;
        xytLeft = xy1;
    end 
    
    plot(xytLeft(1),xytLeft(2),'g+')
    plot(xybLeft(1),xybLeft(2),'b+')
    % getting true angle in image coordinate 
    theta = atan2(xytLeft(2)-xybLeft(2),xytLeft(1)-xybLeft(1));
    % extending the line along this angle to "infinity"
    xyInfLeft = xybLeft + 2000.*[cos(theta), sin(theta)];
    plot(xyInfLeft(1),xyInfLeft(2),'m+')
    
    % --------- RIGHT --------- %
    xy1 = lines(maxRightLine).point1; xy2 = lines(maxRightLine).point2;
    % find top and bottom again
    if xy1(2) > xy2(2)
        xybRight = xy1;
        xytRight = xy2;
    else
        xybRight = xy2;
        xytRight = xy1;
    end   
    plot(xytRight(1),xytRight(2),'g+')
    plot(xybRight(1),xybRight(2),'b+')
    % angle
    theta = atan2(xytRight(2)-xybRight(2),xytRight(1)-xybRight(1));
    % extend
    xyInfRight = xybRight + 2000.*[cos(theta), sin(theta)];
    plot(xyInfRight(1),xyInfRight(2),'m+')
    
    % Finding the intersection between the two extended lines will give the
    % vanishing point.
    [uInf,vInf] = polyxpoly([xybLeft(1),xyInfLeft(1)],[xybLeft(2),xyInfLeft(2)],...
        [xybRight(1),xyInfRight(1)],[xybRight(2),xyInfRight(2)]);
    plot(uInf,vInf,'ro')
    % plot lane markers
    nLaneMarkers = size(laneMarkers,1);
    for iMarker = 1:nLaneMarkers
        plot(laneMarkers(iMarker,1),laneMarkers(iMarker,2),'bo')
    end
    vanishingPoint = [round(uInf),round(vInf)];
end