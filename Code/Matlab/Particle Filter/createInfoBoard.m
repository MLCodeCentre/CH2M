function createInfoBoard(Es,Vars,theta,u_target,v_target,K,k,ymins,ymaxs)

h = figure('units','normalized','outerposition',[0 0 1 1]);
set(h,'visible','off');
subplot(6,2,[2,4,6,8,10,12])
findRoad(theta)

subplot(6,2,1)
alphas = Es(:,1);
plot(0:k,alphas)
hold on
alpha_sigmas = Vars(:,1);
plot(0:k,alphas - alpha_sigmas,'r--')
plot(0:k,alphas + alpha_sigmas,'r--')
ylabel('$\alpha$ [rads]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg1 = legend('E$[\alpha]$','E$[\alpha] \pm$ Var$[\alpha]$','location','NorthEast');
set(leg1,'Interpreter','latex');
xlim([0,K])
ylim([ymins(1),ymaxs(1)])

subplot(6,2,3)
betas = Es(:,2);
plot(0:k,betas)
hold on
beta_sigmas = Vars(:,2);
plot(0:k,betas - beta_sigmas,'r--')
plot(0:k,betas + beta_sigmas,'r--')
ylabel('$\beta$ [rads]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg6 = legend('E$[\beta]$','E$[\beta] \pm$ Var$[\beta]$','location','NorthEast');
set(leg6,'Interpreter','latex');
%ylim([-pi/4,pi/4])
xlim([0,K])
ylim([ymins(2),ymaxs(2)])

subplot(6,2,5)
gammas = Es(:,3);
plot(0:k,gammas)
hold on
gammas_sigmas = Vars(:,3);
plot(0:k,gammas - gammas_sigmas,'r--')
plot(0:k,gammas + gammas_sigmas,'r--')
ylabel('$\gamma$ [rads]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg2 = legend('E$[\gamma]$','E$[\gamma] \pm$ Var$[\gamma]$','location','NorthEast');
set(leg2,'Interpreter','latex');
%ylim([-pi/4,pi/4])
xlim([0,K])
ylim([ymins(3),ymaxs(3)])

subplot(6,2,7)
L1s = Es(:,4);
plot(0:k,L1s)
hold on
L1_sigmas = Vars(:,4);
plot(0:k,L1s - L1_sigmas,'r--')
plot(0:k,L1s + L1_sigmas,'r--')
ylabel('$\frac{\lambda}{L1}$','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg3 = legend('E$[\frac{\lambda}{L_1}]$','E$[\frac{\lambda}{L_1}] \pm$ Var$[\frac{\lambda}{L_1}]$','location','NorthEast');
set(leg3,'Interpreter','latex');
%ylim([0,2])
xlim([0,K])
ylim([ymins(4),ymaxs(4)])

subplot(6,2,9)
L2s = Es(:,5);
plot(0:k,L2s)
hold on
L2_sigmas = Vars(:,5);
plot(0:k,L2s - L2_sigmas,'r--')
plot(0:k,L2s + L2_sigmas,'r--')
ylabel('$\frac{\lambda}{L_2}$','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg4 = legend('E$[\frac{\lambda}{L_2}]$','E$[\frac{\lambda}{L_2}] \pm$ Var$[\frac{\lambda}{L_2}]$','location','NorthEast');
set(leg4,'Interpreter','latex');
%ylim([0,2])
xlim([0,K])
ylim([ymins(5),ymaxs(5)])

subplot(6,2,11)
hs = Es(:,6);
plot(0:k,hs)
hold on
h_sigmas = Vars(:,6);
plot(0:k,hs - h_sigmas,'r--')
plot(0:k,hs + h_sigmas,'r--')
ylabel('$h$ [m]','Interpreter','latex')
xlabel('$k$','Interpreter','latex')
leg5 = legend('E$[h]$','E$[h] \pm$ Var$[h]$','location','NorthEast');
set(leg5,'Interpreter','latex');
%ylim([0,3])
xlim([0,K])
ylim([ymins(6),ymaxs(6)])

file_name = fullfile(dataDir(),'Video Images',strcat([num2str(k),'.png']));
saveas(gcf,file_name)

end