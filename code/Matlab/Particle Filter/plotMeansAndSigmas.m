function plotMeansAndSigmas(Es,Vars)

figure

subplot(3,2,1)
alphas = Es(:,1);
plot(alphas)
hold on
alpha_sigmas = Vars(:,1);
plot(alphas - alpha_sigmas,'r--')
plot(alphas + alpha_sigmas,'r--')
title('Roll')
ylabel('$\alpha$ [rads]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg1 = legend('E$[\alpha]$','E$[\alpha] \pm$ Var$[\alpha]$','location','NorthWest');
set(leg1,'Interpreter','latex');
xlim([1,size(Es,1)])
%ylim-pi/4,pi/4])

subplot(3,2,2)
betas = Es(:,2);
plot(betas)
hold on
beta_sigmas = Vars(:,2);
plot(betas - beta_sigmas,'r--')
plot(betas + beta_sigmas,'r--')
title('Tilt')
ylabel('$\beta$ [rads]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg6 = legend('E$[\beta]$','E$[\beta] \pm$ Var$[\beta]$','location','NorthWest');
set(leg6,'Interpreter','latex');
%ylim([-pi/4,pi/4])
xlim([1,size(Es,1)])

subplot(3,2,3)
gammas = Es(:,3);
plot(gammas)
hold on
gammas_sigmas = Vars(:,3);
plot(gammas - gammas_sigmas,'r--')
plot(gammas + gammas_sigmas,'r--')
title('Pan')
ylabel('$\gamma$ [rads]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg2 = legend('E$[\gamma]$','E$[\gamma] \pm$ Var$[\gamma]$','location','NorthWest');
set(leg2,'Interpreter','latex');
%ylim([-pi/4,pi/4])
xlim([1,size(Es,1)])

subplot(3,2,4)
L1s = Es(:,4);
plot(L1s)
hold on
L1_sigmas = Vars(:,4);
plot(L1s - L1_sigmas,'r--')
plot(L1s + L1_sigmas,'r--')
ylabel('$\frac{\lambda}{L1}$','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
title('Ratio of focal fength and camera plane width')
leg3 = legend('E$[\frac{\lambda}{L_1}]$','E$[\frac{\lambda}{L_1}] \pm$ Var$[\frac{\lambda}{L_1}]$','location','NorthWest');
set(leg3,'Interpreter','latex');
%ylim([0,2])
xlim([1,size(Es,1)])

subplot(3,2,5)
L2s = Es(:,5);
plot(L2s)
hold on
L2_sigmas = Vars(:,5);
plot(L2s - L2_sigmas,'r--')
plot(L2s + L2_sigmas,'r--')
title('Ratio of focal fength and camera plane height')
ylabel('$\frac{\lambda}{L_2}$','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg4 = legend('E$[\frac{\lambda}{L_2}]$','E$[\frac{\lambda}{L_2}] \pm$ Var$[\frac{\lambda}{L_2}]$','location','NorthWest');
set(leg4,'Interpreter','latex');
%ylim([0,2])
xlim([1,size(Es,1)])

subplot(3,2,6)
hs = Es(:,6);
plot(hs)
hold on
h_sigmas = Vars(:,6);
plot(hs - h_sigmas,'r--')
plot(hs + h_sigmas,'r--')
title('Camera height')
ylabel('$h$ [m]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg5 = legend('E$[h]$','E$[h] \pm$ Var$[h]$','location','NorthWest');
set(leg5,'Interpreter','latex');
%ylim([0,3])
xlim([1,size(Es,1)])

end