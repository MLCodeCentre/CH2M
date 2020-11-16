function annotateRoad(cameraParams)
% ANNOTATEROAD overlays lines on the surface of the road in the current
% figure
%%  plotting road
xmax = 48;
ymax = 6;
xRange = 10:2:xmax;
yRange = -ymax:ymax;
z = 0;

U = []; V = [];
for y = yRange
    for x = xRange
        [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    U = [];
    V = [];
end

U = [];
V = [];

for x = xRange
    for y = yRange
        [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'r')
    U = [];
    V = [];
end

%% plotting wall
% x = xmax;
% yRange = linspace(-ymax,ymax,2*ymax+1);
% zRange = linspace(0,5,6);
% 
% U = []; V = [];
% for y = yRange
%     for z = zRange
%         [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
%         U = [U,u];
%         V = [V,v];
%     end
%     plot(U(:),V(:),'r')
%     U = [];
%     V = [];
% end
% 
% U = [];
% V = [];
% 
% for z = zRange
%     for y = yRange
%         [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
%         U = [U,u];
%         V = [V,v];
%     end
%     plot(U(:),V(:),'r')
%     U = [];
%     V = [];
% end

%% plotting crash barrier height.
xRange = linspace(40,60,30);
yRange = 9.5;
zRange = 0.6;
U = [];
V = [];
for x = xRange
    for y = yRange
        for z = zRange
            [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
            U = [U,u];
            V = [V,v];
        end
    end
    plot(U(:),V(:),'bo')
    U = [];
    V = [];
end


%% plotting the vanishing points
uInf = cameraParams.fu*tan(cameraParams.gamma) + cameraParams.m/2;
vInf = cameraParams.fv*tan(cameraParams.beta)/cos(cameraParams.gamma) + cameraParams.n/2;
plot(uInf,vInf,'r+');
end