function solveCameraEquations

guess = [1,1,0,0,0];

options = optimoptions('fsolve','Display','iter');
[result, fval, exit, output] = fsolve(@cameraEquations, guess, options);
