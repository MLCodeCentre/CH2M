function Xt = transitionFunction(Xtminus1,vehicleChange,nPoints)

nCameraParams = 8;
Xt(1:nCameraParams,1) = Xtminus1(1:nCameraParams);
coordstminus1 = reshape(Xtminus1(nCameraParams+1:end),3,[])';

for iPoint = 1:nPoints
    Xt(end+1:end+3,1) = coordstminus1(iPoint,:)-vehicleChange;
end

end