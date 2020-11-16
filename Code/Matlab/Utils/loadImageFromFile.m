function img = loadImageFromFile(road,camera,PCDATE,PCTIME)
% Just loads an image without the need for navFile. 
img = imread(fullfile(dataDir(),road,'Images',...
    sprintf('%d_%d_%d.jpg',camera,PCDATE,PCTIME))); 

end