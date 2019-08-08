function plotCorrections(navFile)
    %close
    x = navFile.XCOORD; y = navFile.YCOORD; h = navFile.HEADING;
    xFilt = navFile.XCOORD; yFilt = navFile.YCOORD;
    hCD = navFile.HEADINGCD;
    %velocity = navFile.VELOCITY;
    subplot(2,2,[1,2])
    cla
    hold on
    navID = find(navFile.PCDATE==1138 & navFile.PCTIME==5465);
    navPlotIDX = navID-20:navID+20;
    targetCoords = []; targetCoordsFilt = [];
    for iNav = navPlotIDX
        l = 1;
        plot(x(iNav),y(iNav),'ko')
        %text(x(iNav),y(iNav),oum2str(iNav))
        x2=x(iNav)+(1*sin(deg2rad(h(iNav))));
        y2=y(iNav)+(1*cos(deg2rad(h(iNav))));
        % plot corrected position and heading arm
        plot([x(iNav),x2],[y(iNav),y2],'r--');
        %text(x2,y2,sprintf('%1.2f',h(iNav)))
        % estimate
        % plotting measured and actual
        plot(xFilt(iNav),yFilt(iNav),'ko')
        x2=xFilt(iNav)+(1*sin(deg2rad(hCD(iNav))));
        y2=yFilt(iNav)+(1*cos(deg2rad(hCD(iNav))));
        %plot corrected position and heading arm
        plot([xFilt(iNav),x2],[yFilt(iNav),y2],'b--');
        %text(x2-0.15,y2,sprintf('%1.2f',hFilt(iNav)))
        
        % i want to plot the wobble across the road. this should be
        % minimal.
        target = [x(navPlotIDX(end));y(navPlotIDX(end))+10;0];
        targetTruth = rotz(hCD(navPlotIDX(end-10)))*(target-[x(navPlotIDX(end-10));y(navPlotIDX(end-10));0]);
        
        plot(target(1),target(2),'mx')
        targetCoords(:,end+1) = rotz(h(iNav))*(target-[x(iNav);y(iNav);0]);        
        targetCoordsFilt(:,end+1) = rotz(hCD(iNav))*(target-[xFilt(iNav);yFilt(iNav);0]);
        
    end
    hold off
    subplot(2,2,[3,4]); cla
    hold on
    yline(targetTruth(1));
    plot(targetCoords(2,:),targetCoords(1,:),'.--')
    plot(targetCoordsFilt(2,:),targetCoordsFilt(1,:),'.--');
    legend({'True Y Distance','GPS','Central Difference'})
    xlabel('Easting Distance to Target'); ylabel('Northing'); 

end