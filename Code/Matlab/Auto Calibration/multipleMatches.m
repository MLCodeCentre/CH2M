function fval = multipleMatches(cameraParams,F,nPoints)

fval = [];
nMatrices = size(F,1);
for iMatrix = 1:nMatrices  
        f = reshape(F(iMatrix,:,:),3,3); 
        w = nPoints(iMatrix)/sum(nPoints);
        fval(end+1) = w*kruppaRatio(cameraParams,f);
        %fval(end+1) = w*mendoncaFunction(cameraParams,f);
end

fval = sum(fval);