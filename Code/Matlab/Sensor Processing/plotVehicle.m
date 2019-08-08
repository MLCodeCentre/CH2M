function plotVehicle(navFile,plotIDX)
% function to plot the position and headings of the vehicle
cla
hold on;
L=1; % length of heading arm 
scatter(navFile(plotIDX,:).XCOORDOLD,navFile(plotIDX,:).YCOORDOLD,...
    'o','MarkerEdgeColor',[0,0.2,0]+0.2);
for iPlot = plotIDX   
    % extract position and heading from each navfile entry.
    navImage = navFile(iPlot,:);
    % plot position
    x = navImage.XCOORD; y = navImage.YCOORD;
    plot(x,y,'ko')
    % plot heading
    x2 = x + (L*sin(deg2rad(navImage.HEADING)));
    y2 = y + (L*cos(deg2rad(navImage.HEADING)));
    plot([x x2],[y y2],'b--')
%     % plot original heading
%     x2 = x + (L*sin(deg2rad(navImage.HEADINGOLD)));
%     y2 = y + (L*cos(deg2rad(navImage.HEADINGOLD)));
%     plot([x x2],[y y2],'g--')
    % plot heading from KF
    x2 = x + (L*sin(deg2rad(navImage.HEADINGKF)));
    y2 = y + (L*cos(deg2rad(navImage.HEADINGKF)));
    plot([x x2],[y y2],'r--')
end
hold off
% add labels. 
xlabel('Easting [m]'); ylabel('Northing [m]')
set(gca,'xtick',[])
set(gca,'ytick',[])
%legend({'GPS position','KF position','CD heading','GPS heading','KF heading'})