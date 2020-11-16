function projections = predictPixels(X,m,n)

nCameraParams = 8;
alpha = X(1); beta = X(2); gamma = X(3);
x0 = X(4); y0 = X(5); h = X(6);
fu = X(7); fv = X(8);
cameraParams = [alpha,beta,gamma,x0,y0,h,fu,fv,0,0,m,n];
coords = reshape(X(nCameraParams+1:end),3,[])';

nCoords = size(coords,1);
projections = [];
for iCoord = 1:nCoords
   [u,v] = getPixelsFromCoords(coords(iCoord,:)',cameraParams);
   projections(end+1) = u;
   projections(end+1) = v;
end

end