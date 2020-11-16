function plotCorrectedVehicle(navFile,handles,PCDATE,PCTIMES,targetPCTIME)
% function to plot the position and headings of the vehicle
hold on;
cla
% plot vehicle
nPCTIMES =  numel(PCTIMES);
for iPCTIME = 1:nPCTIMES
    navImage = navFile(navFile.PCDATE==PCDATE&navFile.PCTIME==PCTIMES(iPCTIME),:);
    x = navImage.XCOORD; y = navImage.YCOORD;
    xOLD = navImage.XCOORDOLD; yOLD = navImage.YCOORDOLD;
    
    L = 1;
    if PCTIMES(iPCTIME) == targetPCTIME
       plot(x,y,'bo')
       L = 1;
    else
        plot(x,y,'bo')
    end
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

% % plot more dashs out in front
% navScatterInd = find(navFile.PCDATE==PCDATE&navFile.PCTIME==targetPCTIME);
% scatter(navFile(navScatterInd:navScatterInd+15,:).XCOORD,...
%     navFile(navScatterInd:navScatterInd+15,:).YCOORD,'b.');

% % plot assets
% image =  handles.imageFile.UserData;
% assets = handles.loadAssetData.UserData;
% assetsImage = findCloseAssets(assets,image);
% 
% scatter(assetsImage.XCOORD,assetsImage.YCOORD,'g+')

hold off
xlabel('Easting [m]'); ylabel('Northing [m]')
set(gca,'xtick',[])
set(gca,'ytick',[])
leg = legend({'Corrected Vehicle','Vechile','Corrected heading','IMU Heading','Assets'});
set(leg,'Interpreter','latex','Location','NorthWest')