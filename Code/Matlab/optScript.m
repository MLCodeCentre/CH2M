function optScript

options = optimoptions('fsolve','Display','iter',...
                       'MaxFunctionEvaluations',10000);
h = 3.5;
[X,FVAL,EXITFLAG] = fsolve(@(x) cameraEquationsYear2(x,h), [0.2,0.2,0.2,1,1,h], options);
X = [X, h];
disp('params found:')
disp(['roll (alpha): ',num2str(rad2deg(X(1))),' degs'])
disp(['tilt (beta): ',num2str(rad2deg(X(2))),' degs'])
disp(['pan (gamma): ',num2str(rad2deg(X(3))),' degs'])
disp(['L1: ',num2str(rad2deg(X(4)))])
disp(['L2: ',num2str(rad2deg(X(5)))])
disp(['h:',num2str(X(6))])

findRoad(X);