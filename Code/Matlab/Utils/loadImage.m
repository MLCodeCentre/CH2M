function img = loadImage(image,road)
%LOADIMAGE loads image of road image is a navFile row
img = imread(fullfile(dataDir(),road,'Images',...
    sprintf('%d_%d_%d.jpg',2,image.PCDATE,image.PCTIME)));
end

