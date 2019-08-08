function fval = mendoncaFunction(cameraParams,F)
    
    fu = cameraParams(1); fv = cameraParams(2);
    %cu = cameraParams(3); cv = cameraParams(4);
    cu = 0; cv = 0;
    K = [fu,  0, cu;
          0, fv, cv;
          0,  0, 1];
    S = eigs(K'*F*K);
    fval = 1 - (S(2)/S(1));
end