function plotRoadSurface(cameraParams,image)

figure
img = imread(image);
imshow(img); hold on;    
    
U = [];
V = [];
z = 0;
for x = linspace(10,40,10)
    for y = linspace(-1.8,1.8,10)        
        [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'bo')
    hold on
    U = [];
    V = [];
end

end

