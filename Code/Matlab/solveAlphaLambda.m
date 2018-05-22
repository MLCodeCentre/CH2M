function solveAlphaLambda

close all;
% training set world coords of middle of the road of road marker, 1st and
% 2nd street light.
X = [0, 5.60, 0;
    0, 16.4133, 0;
    0, 55.7628, 0];
% V pixel values
Y = [1980; 
    1300;
    890];

% explore lambda, alpha space to minimise the error.
params = config();

n = 1000; %samples per parameter
alpha = linspace(0.1,180,n); %alpha range and corresponding sy
lambda = linspace(0.01,0.1,n);

[A,L] = meshgrid(alpha, lambda);
sy = -(L./tan(deg2rad(A))) .* (1/(780-params.cy));

errors = zeros(n,n,3);

for i = 1:3
    [~,v] = coords2Pixels(X(i,1),X(i,2),X(i,3),A,sy,L);
    error = abs(v-Y(i));
    errors(:,:,i) = error; 
end

errors = mean(errors,3);
surf(A,L,errors);
xlabel('\alpha [deg]');ylabel('\lambda [m]');zlabel('E(\alpha, \lambda)');
colorbar
zlim([0,1000])
caxis([0,1000])

lambda_ind = find(abs(lambda-0.05) < 0.001);
figure()
plot(alpha,errors(450,:))
xlabel('\alpha');ylabel('E(\alpha, \lambda=0.05)');
legend('\lambda=0.05','location','northwest')
ylim([0,2000])

[val,Idx] = min(errors(:));
[Errors_minRow,Errors_minCol] = ind2sub(size(errors), Idx);
alpha_min = alpha(Errors_minCol)
lambda_min = lambda(Errors_minRow)
sy_min = -(lambda_min./tan(deg2rad(alpha_min))) .* (1/(780-params.cy))