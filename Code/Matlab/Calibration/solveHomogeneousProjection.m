function solveHomogeneousProjection(road,year)

    % Initialising system parameters and data
    if strcmp(year,'Year1')
        m = 2560; n = 2048;
        vanishingPoint = [1237,1004];
    elseif strcmp(year,'Year2')
        m = 2560; n = 2048;
        vanishingPoint = [1282,812]; 
    elseif strcmp(year,'Year3')
        m = 2464; n = 2056;
    end
    systemParams = [m,n];
    %vanishingPoint = [1156,910];

    % loading data
    close all
    fileDir = fullfile(dataDir(),road,year,'target_data_road_height_12_03.csv');
    dataTable1 = readtable(fileDir);
    fileDir = fullfile(dataDir(),road,year,'target_data_road_height_06_03.csv');
    dataTable2 = readtable(fileDir);
    fileDir = fullfile(dataDir(),road,year,'target_data_road_height_01_03.csv');
    dataTable3 = readtable(fileDir);
    data = [dataTable1;dataTable2;dataTable3];
    data = [dataTable1;dataTable2];

    coords = [data.y,-data.z,data.x];
    pixels = [data.u,data.v];
                     %fv   fu     a   b   g  x0   y0 h
    cameraParams0 =  [4700,4700,  0,  0,  0, 2,   0, 3,  0, 0];
    cameraParamsLB = [1000,1000,-15,-15,-15, 0,-0.5,-5,-2000,-2000];
    cameraParamsUB = [8000,8000, 15, 15, 15, 5, 0.5, 5  2000, 2000];

    f = @(cameraParams) homogeneousProjectionFunction(cameraParams,coords,pixels);
    options = optimset('TolFun',1e-16,'TolX',1e-16);
    problem = createOptimProblem('fmincon','objective',f,'x0',cameraParams0,'lb',cameraParamsLB,'ub',cameraParamsUB,'options',options);
    ms = MultiStart;
    [cameraParams,fval,flag] = run(ms,problem,3)
    
    [~,reprojections] = homogeneousProjectionFunction(cameraParams,coords,pixels);
    plotReprojectionError(pixels,reprojections);
    
    % bundle adjustment
    g = @(coords) myBundleAdjustment(coords,pixels,cameraParams);
    options = optimset('TolFun',1e-16,'TolX',1e-16,'MaxIter',2e5);
    problem = createOptimProblem('fmincon','objective',g,'x0',coords,'options',options);
    ms = MultiStart;
    [adjustedCoords,fval,flag] = run(ms,problem,3)
    plotCoordAdjustments(coords,adjustedCoords,cameraParams)

end

function plotCoordAdjustments(coords,adjustedCoords,cameraParams)
    alpha = cameraParams(3); beta = cameraParams(4); gamma = cameraParams(5);
    x0 = cameraParams(6); y0 = cameraParams(7); h = cameraParams(8);
    R = rotz(gamma+90)*roty(beta)*rotx(alpha);
    
    figure; hold on
    %cam = plotCamera('Location',[y0 x0 h],'Orientation',R,'Opacity',0);
    xlabel('y'); ylabel('x'); zlabel('z');
    
    nCoords = size(coords,1);
    
    scatter3(coords(:,1),coords(:,2),coords(:,3),'bo');
    scatter3(adjustedCoords(:,1),adjustedCoords(:,2),adjustedCoords(:,3),'ro');
    
    for iCoords = 1:nCoords
        plot3([coords(iCoords,1);adjustedCoords(iCoords,1)],...
            [coords(iCoords,2);adjustedCoords(iCoords,2)],...
            [coords(iCoords,3);adjustedCoords(iCoords,3)],'k--')
    end
    lh = legend({'Coords','Adjusted Coords'});
end

function plotReprojectionError(pixels,reprojections)
    nPixels = size(pixels,1);
    figure; hold on
    scatter(pixels(:,1),pixels(:,2),'k+');
    scatter(reprojections(:,1),reprojections(:,2),'bo');
    
    for iPixel = 1:nPixels
        plot([pixels(iPixel,1);reprojections(iPixel,1)],[pixels(iPixel,2);reprojections(iPixel,2)],'r--')
    end
    lh = legend({'Targets','Reprojections'});
end