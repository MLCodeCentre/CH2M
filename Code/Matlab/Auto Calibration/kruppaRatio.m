function fval = kruppaRatio(cameraParams,F)
    
    [U,W,V] = svd(F);
    u1 = U(:,1); u2 = U(:,2); u3 = U(:,3);
    v1 = V(:,1); v2 = V(:,2); v3 = V(:,3);
    r = W(1,1); s = W(2,2);
    % constructing camera matrix and dual absolute conic
    fu = cameraParams(1); fv = cameraParams(2);
    %cu = cameraParams(3); cv = cameraParams(4);
    cu = 0; cv = 0;
    K = [fu,  0, cu;
          0, fv, cv;
          0,  0, 1];
    C = K*K';
    
    % kruppa ratios (to be made equal)
    kr1 =  (v2'*C*v2)/(r^2*u1'*C*u1);
    kr2 = (-v2'*C*v1)/(s*r*u1'*C*u1);
    kr3 = (v1'*C*v1)/(s^2*u2'*C*u2);
    
    % factors
    factor(1) = kr1-kr2;
    factor(2) = kr1-kr3;
    factor(3) = kr2-kr3;
    % function val
    fval = norm(factor);
end