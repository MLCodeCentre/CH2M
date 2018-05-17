function solveAlphaSy
close all
alpha_range = 0:0.001:pi;
params = config();
h = params.Z0;

eq = (((22.77*h.*cos(alpha_range) - h.*sin(alpha_range))./...
       (22.77*h.*sin(alpha_range) + h.*cos(alpha_range) + params.lambda))./ ...
      ((68.55*h.*cos(alpha_range) - h.*sin(alpha_range))./...
       (68.55*h.*sin(alpha_range) + h.*cos(alpha_range) + params.lambda))) + (126/153);
       
plot(alpha_range,eq)
ylim([-5,5])
grid on
xlabel('\alpha')
ylabel('Equation')

alpha_sol = 1.54;

sy_sol = ((22.77*h.*cos(alpha_sol) - h.*sin(alpha_sol))/((22.77*h.*sin(alpha_sol) + h.*cos(alpha_sol) + params.lambda))) * params.lambda/-126