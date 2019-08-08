function whiteheadCalibration(fundamentalMatricesandNPoints)
    
    F = fundamentalMatricesandNPoints(:,:,1:3);
    nPoints = fundamentalMatricesandNPoints(:,1,4);

    myFunc = @(cameraParams) multipleMatches(cameraParams,F,nPoints);

    cameraParams0 = [5000,5000];
    UB = [10000,10000];
    LB = [0,0];
    options = optimoptions(@ga,'MutationFcn',@mutationadaptfeasible);
    options = optimoptions(options,'PlotFcn',{@gaplotbestf}, ...
      'Display','iter');
    % Next we run the GA solver.
    options.InitialPopulationMatrix = cameraParams0;
    constraint = @simple_constraint;
    [x,fval] = ga(myFunc,2,[],[],[],[],LB,UB,[],options)
        
end

function [c, ceq] = simple_constraint(cameraParams)
fu = cameraParams(1); fv = cameraParams(2);
c = [];
ceq = [fu-fv];
end