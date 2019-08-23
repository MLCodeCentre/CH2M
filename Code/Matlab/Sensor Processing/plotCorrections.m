function plotCorrections(navFile,covariances)
    x = navFile.XCOORD; y = navFile.YCOORD; h = navFile.HEADING;   
    xIMU = navFile.XCOORDOLD; yIMU = navFile.YCOORDOLD; hIMU = navFile.HEADINGOLD;
        
    distances = sqrt((x-xIMU).^2 + (y-yIMU).^2);
    max(distances);
    %navID = find(distances == max(distances));
    navID = find(navFile.PCDATE==1221 & navFile.PCTIME==18860);
    nPlots = 50;
    nPlots = min(size(navFile,1)-navID,nPlots);
    navPlotIDX = navID-nPlots:navID+nPlots;
    subplot(3,4,[1,2,5,6,9,10]); cla; hold on
    %targetCoords = []; targetCoordsFilt = [];
    for iNav = navPlotIDX
        % plot corrected
        plot(x(iNav),y(iNav),'bo')
        x2=x(iNav)+(1*sin(deg2rad(h(iNav))));
        y2=y(iNav)+(1*cos(deg2rad(h(iNav))));
        plot([x(iNav),x2],[y(iNav),y2],'b--');
        %text(x2,y2,num2str(h(iNav)));
        % plot IMU 
        plot(xIMU(iNav),yIMU(iNav),'ro')
        x2=xIMU(iNav)+(1*sin(deg2rad(hIMU(iNav))));
        y2=yIMU(iNav)+(1*cos(deg2rad(hIMU(iNav))));
        plot([xIMU(iNav),x2],[yIMU(iNav),y2],'r--');
        %text(x2,y2,num2str(hIMU(iNav)));
        %and covariance
%         covx = covariances(iNav,1,1); covxy = covariances(iNav,1,2);
%         covyx = covariances(iNav,2,1); covy = covariances(iNav,2,2);
%         m = [x(iNav),y(iNav)]; c = [covx,covxy;covyx,covy];
%         plot_gaussian_ellipsoid(m,c)       
    end
    hold off
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    legend({'KF Position','KF Heading','IMU Position','IMU Heading'});
    xlabel('Easting'); ylabel('Northing');
    axis equal;
%     
    subplot(3,4,[3,4]); cla; hold on
    plot(xIMU(navPlotIDX),'.'); plot(x(navPlotIDX),'.'); legend({'IMU','KF'})
    set(gca,'xtick',[]); ylabel('Easting'); xlabel('GPS Reading Sequence');
    subplot(3,4,[7,8]); cla; hold on
    plot(yIMU(navPlotIDX),'.'); plot(y(navPlotIDX),'.'); legend({'IMU','KF'})
    set(gca,'xtick',[]); ylabel('Northing'); xlabel('GPS Reading Sequence');
    subplot(3,4,[11,12]); cla; hold on
    plot(hIMU(navPlotIDX)); plot(h(navPlotIDX)); legend({'IMU','KF'})
    set(gca,'xtick',[]); ylabel('Heading'); xlabel('GPS Reading Sequence');
    
end