function S = cameraParameterSolve

params = config();

syms lambda Sx alpha_
eqns = [(235-params.cx)*Sx == lambda*(-7.23) / ...
        (13.42*sin(alpha_) + 0.9*cos(alpha_) + lambda),
        
        (params.cy - 1090)*0.8*Sx == lambda*(13.42*cos(alpha_)-0.9*sin(alpha_)) / ...
        (13.42*sin(alpha_) + 0.9*cos(alpha_) + lambda),
        
        (487-params.cx)*Sx == lambda*(-11) / ...
        (22.98*sin(alpha_) + lambda)
        ];

 S = solve(eqns, [lambda Sx alpha_]);