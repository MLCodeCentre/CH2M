function errorSurface(theta_solve,coords,system_params)


plotChanges(theta_solve, coords, system_params, -0.001:0.0001:0.001, '\alpha [degs]', 1)
plotChanges(theta_solve, coords, system_params, -0.01:0.01:0.01, '\beta [degs]', 2)
plotChanges(theta_solve, coords, system_params, -0.5:0.01:0.5, '\gamma [degs]', 3)
plotChanges(theta_solve, coords, system_params, -0.4:0.01:0.4, 'L1', 4)
plotChanges(theta_solve, coords, system_params, -0.4:0.01:0.4, 'L2', 5)
plotChanges(theta_solve, coords, system_params, -20:0.1:20, 'h [m]', 6)
plotChanges(theta_solve, coords, system_params, -20:0.1:20, 'x0 [m]', 7)
plotChanges(theta_solve, coords, system_params, -20:0.1:20, 'y0 [m]', 8)


end

function plotChanges(theta_solve, coords, system_params, param_range, parameter, param_ind)
    subplot(4,2,param_ind)
    fvals = [];
    param_vals = [];
    change_vector = zeros(size(theta_solve));
    change_vector(param_ind) = 1;
    
    for dp = param_range
        theta_dp = theta_solve + dp*change_vector;
        fval = cameraEquationFunction(theta_dp,coords,system_params);
        fvals = [fvals, fval];
        param_vals = [param_vals, theta_dp(param_ind)];
    end
    
    if param_ind < 4
        param_vals = rad2deg(param_vals);
    end
    
    plot(param_vals,fvals); xlabel(parameter); ylabel('fval');
end



