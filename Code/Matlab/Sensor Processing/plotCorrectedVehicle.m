function plotCorrectedVehicle(navFile,PCDATE,PCTIMES,targetPCTIME)
% function to plot the position and headings of the vehicle
hold on;
L=1;

nPCTIMES =  numel(PCTIMES);

for iPCTIME = 1:nPCTIMES
    navImage = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==PCTIMES(iPCTIME),:);
    x = navImage.XCOORD; y = navImage.YCOORD;
    xOLD= navImage.XCOORDOLD; yOLD = navImage.YCOORDOLD;

    plot(x,y,'bo')
    plot(xOLD,yOLD,'ro')
    %text(x,y,num2str(PCTIMES(iPCTIME)))
    % plot old heading
    x2=x+(L*sin(deg2rad(navImage.HEADING)));
    y2=y+(L*cos(deg2rad(navImage.HEADING)));

    x3=xOLD+(L*sin(deg2rad(navImage.HEADINGOLD)));
    y3=yOLD+(L*cos(deg2rad(navImage.HEADINGOLD)));

    plot([x x2],[y y2],'b--')
    plot([xOLD x3],[yOLD y3],'r--')

end
hold off
%xlabel('Easting [m]'); ylabel('Northing [m]')
set(gca,'xtick',[])
set(gca,'ytick',[])
leg = legend({'Corrected Vehicle','Vechile','Corrected heading','IMU Heading'});
set(leg,'Interpreter','latex')