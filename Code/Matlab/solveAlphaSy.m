function solveAlphaSy
close all
alpha_range = 0:0.001:pi;
params = config();
h = params.Z0;

Y1 = 5.6; V1 = 1980;
Y2 = 55.45; V2 = 134;


eq = (((Y1*h.*cos(alpha_range) - h.*sin(alpha_range) - params.r2)./...
       (Y1*h.*sin(alpha_range) + h.*cos(alpha_range) + params.r3 + params.lambda))./ ...
      ((Y2*h.*cos(alpha_range) - h.*sin(alpha_range) - params.r2)./...
       (Y2*h.*sin(alpha_range) + h.*cos(alpha_range) + params.r3 + params.lambda))) ...
       -((V1-params.cy)/(V2-params.cy));
alphas = rad2deg(alpha_range(abs(eq)<0.01))
       
plot(alpha_range,eq)
ylim([-5,5])
grid on
xlabel('\alpha')
ylabel('Equation')

alpha_sol = 1.286;
sy_sol = ((Y1*h.*cos(alpha_sol) - h.*sin(alpha_sol))/((Y1*h.*sin(alpha_sol) + h.*cos(alpha_sol) + params.lambda))) * params.lambda/(V1-params.cy)