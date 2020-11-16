function plotReprojectionError(pixels,reprojections,image)
    m = 2464; n = 2056;
    nPixels = size(pixels,1);
    img = imread(image);
    imshow(img)
    hold on
    scatter(pixels(:,1),pixels(:,2),'k+');
    scatter(reprojections(:,1),reprojections(:,2),'bo'); 
    for iPixel = 1:nPixels
        plot([pixels(iPixel,1);reprojections(iPixel,1)],[pixels(iPixel,2);reprojections(iPixel,2)],'r--')
    end
    lh = legend({'Targets','Reprojections'});
end