function plotHeadings(navFile)
cla
nImages = size(navFile,1);
% fit a polynomial to n gps readings before and after current plot,
% headings is gradient of the polynomial through current position.
headingsOld = navFile.HEADINGOLD;
headings = navFile.HEADING;
XCOORDs = navFile.XCOORD;
YCOORDs = navFile.YCOORD;

L = 1; % heading arm length
hold on
for iImage = 300:450
    x = XCOORDs(iImage); y = YCOORDs(iImage);
    %% correct heading arm
    x2=x+(L*sin(deg2rad(headings(iImage))));
    y2=y+(L*cos(deg2rad(headings(iImage))));
    % plot corrected position and heading arm
    plot(x,y,'ko')
    plot([x,x2],[y,y2],'b--');
    % show corrected reprojections
    xProjCorrected=x+(2*sin(deg2rad(headings(iImage))));
    yProjCorrected=y+(2*cos(deg2rad(headings(iImage))));
    scatter(xProjCorrected,yProjCorrected,'MarkerEdgeColor',[0,0,0.4]+0.2);
      
    %% Original heading 
    % projected next place
    x3=x+(L*sin(deg2rad(headingsOld(iImage))));
    y3=y+(L*cos(deg2rad(headingsOld(iImage))));
    % plot corrected position and heading arm
    plot(x,y,'ko')
    plot([x,x3],[y,y3],'r--');
    xProj=x+(2*sin(deg2rad(headingsOld(iImage))));
    yProj=y+(2*cos(deg2rad(headingsOld(iImage))));
    scatter(xProj,yProj,'MarkerEdgeColor',[0.4,0,0]+0.2);
end
grid on
hold off
xlabel('Easting [m]'); ylabel('Northing [m]')
set(gca,'xtick',[])
set(gca,'ytick',[])
