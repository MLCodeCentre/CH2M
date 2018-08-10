function deltas

close all
%% setting up 
m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^

A = -0.4860912061e-2; B = -0.7090294123e-1; G = -0.7469854833e-2; L1 = .8354517787; L2 = 1.150049223;

x = 1.2; y = -0.25; z = -0.205;

dG = -pi/12:0.01:pi/12;
dB = -pi/12:0.01:pi/12;
dA = -pi/4:0.01:pi/4;

% defining full rotation matrix
R = [ cos(G)*cos(B), -sin(G)*cos(A)+cos(G)*sin(B)*sin(A),  sin(G)*sin(A)+cos(G)*sin(B)*cos(A);
      sin(G)*cos(B),  cos(G)*cos(A)+sin(G)*sin(B)*sin(A), -cos(G)*sin(A)+sin(G)*sin(B)*cos(A);
     -sin(B),         cos(B)*sin(A),                       cos(B)*cos(A)];

%% pan gamma
du_gamma = m*L1*(((R(2,1)*x + R(2,2)*y + R(2,3)*z).*cos(dG) + (R(1,1)*x + R(1,2)*y + R(1,3)*z).*sin(dG))...
               ./((R(1,1)*x + R(1,2)*y + R(1,3)*z).*cos(dG) - (R(2,1)*x + R(2,2)*y + R(2,3)*z).*sin(dG)));
            
dv_gamma = n*L2*(((R(3,1)*x + R(3,2)*y + R(3,3)*z))...
              ./((R(1,1)*x + R(1,2)*y + R(1,3)*z).*cos(dG) - (R(2,1)*x + R(2,2)*y + R(2,3)*z).*sin(dG)));
 
%% tilt beta
E1 = -(cos(G)*sin(B))*x + (cos(G)*cos(B)*sin(A))*y + (cos(G)*cos(B)*cos(A))*z;
E2 = -(sin(G)*sin(B))*x + (sin(G)*cos(B)*sin(A))*y + (sin(G)*cos(B)*cos(A))*z;
E3 = cos(B)*x - (sin(B)*sin(A))*y - sin(B)*cos(A)*z;

du_beta = m*L1*(((R(2,1)*x + R(2,2)*y + R(2,3)*z).*cos(dB) + E2.*sin(dB))...
              ./((R(1,1)*x + R(1,2)*y + R(1,3)*z).*cos(dB) + E1.*sin(dB)));
            
dv_beta = n*L2*(((R(3,1)*x + R(3,2)*y + R(3,3)*z).*cos(dB) + E3.*sin(dB))...
              ./((R(1,1)*x + R(1,2)*y + R(1,3)*z).*cos(dB) + E1.*sin(dB)));
           
%% roll alpha
du_alpha = m*L1*((R(2,1)*x + (R(2,2)*y + R(2,3)*z).*cos(dA) + (R(2,3)*y - R(2,2)*z).*sin(dA))...
               ./(R(1,1)*x + (R(1,2)*y + R(1,3)*z).*cos(dA) + (R(1,3)*y - R(1,2)*z).*sin(dA)));
            
dv_alpha = n*L2*((R(3,1)*x + (R(3,2)*y + R(3,3)*z).*cos(dA) + (R(3,3)*y - R(3,2)*z).*sin(dA))...
               ./(R(1,1)*x + (R(1,2)*y + R(1,3)*z).*cos(dA) + (R(1,3)*y - R(1,2)*z).*sin(dA)));
           
% %% plotting change to U pixel
% subplot(2,1,1)
% plot(rad2deg(dA),du_alpha)
% hold on
% plot(rad2deg(dB),du_beta)
% plot(rad2deg(dG),du_gamma)
% leg = legend('$\delta\alpha$','$\delta\beta$','$\delta\gamma$');
% set(leg,'Interpreter','Latex')
% set(leg,'FontSize',12)
% set(leg,'Location','NorthWest')
% %xlabel('Angle [degrees]','Interpreter','Latex','FontSize',14)
% ylabel('$u + \delta u$ [pixels]','Interpreter','Latex','FontSize',12)
% %title(strcat(['x = ',num2str(x),', y = ',num2str(y),', z = ',num2str(z)]), ...
%     %'Interpreter','Latex')
% ylim([-m/2,m/2])
% 
% %% plotting change to V pixel
% subplot(2,1,2)
% plot(rad2deg(dA),dv_alpha)
% hold on
% plot(rad2deg(dB),dv_beta)
% plot(rad2deg(dG),dv_gamma)
% leg = legend('$\delta\alpha$','$\delta\beta$','$\delta\gamma$');
% set(leg,'Interpreter','Latex')
% set(leg,'FontSize',12)
% set(leg,'Location','NorthWest')
% xlabel('Angle [degrees]','Interpreter','Latex','FontSize',12)
% ylabel('$v + \delta v$ [pixels]','Interpreter','Latex','FontSize',12)
% ylim([-n/2,n/2])
% 
% t = suptitle(strcat(['$x$ = ',num2str(x),', $y$ = ',num2str(y),', $z$ = ',num2str(z)]));
% set(t,'Interpreter','Latex','FontSize',12)

%% phase plots
% ax = figure;
% ax.Units = 'pixels';
img_file = fullfile(dataDir(),'Experiment','Experiment2','tables.jpeg');
I = imread(img_file);
%I = rgb2gray(I);
imshow(I);
hold on

u_start = cx + m*L1*((R(2,1).*x + R(2,2).*y + R(2,3).*z)...
                    ./(R(1,1).*x + R(1,2).*y + R(1,3).*z));

v_start = cy - n*L2*((R(3,1).*x + R(3,2).*y + R(3,3).*z)...
                    ./(R(1,1).*x + R(1,2).*y + R(1,3).*z));

lw = 1.8;

du_alpha = du_alpha+cx; dv_alpha = -dv_alpha + cy;
du_beta = du_beta+cx; dv_beta = -dv_beta + cy;
du_gamma = du_gamma+cx; dv_gamma = -dv_gamma + cy;

% alpha
plot(du_alpha,dv_alpha,'LineWidth',lw)
t1 = text(max(du_alpha)+100,max(dv_alpha)+100,'$\delta\alpha=\frac{\pi}{4}$');
set(t1,'Interpreter','Latex')
set(t1,'FontSize',14)
set(t1,'HorizontalAlignment','center')
t2 = text(min(du_alpha)-100,min(dv_alpha)-100,'$\delta\alpha=-\frac{\pi}{4}$');
set(t2,'Interpreter','Latex')
set(t2,'FontSize',14)
set(t2,'HorizontalAlignment','center')

% beta
plot(du_beta,dv_beta,'LineWidth',lw)
t3 = text(max(du_beta),max(dv_beta)+50,'$\delta\beta=\frac{\pi}{12}$');
set(t3,'Interpreter','Latex')
set(t3,'FontSize',14)
set(t3,'HorizontalAlignment','center')
t4 = text(min(du_beta),min(dv_beta)-50,'$\delta\beta=-\frac{\pi}{12}$');
set(t4,'Interpreter','Latex')
set(t4,'FontSize',14)
set(t4,'HorizontalAlignment','center')

% gamma
plot(du_gamma,dv_gamma,'LineWidth',lw)
t5 = text(max(du_gamma),max(dv_gamma)+25,'$\delta\gamma=\frac{\pi}{12}$');
set(t5,'Interpreter','Latex')
set(t5,'FontSize',14)
set(t5,'HorizontalAlignment','center')
t6 = text(min(du_gamma),min(dv_gamma)-75,'$\delta\gamma=-\frac{\pi}{12}$');
set(t6,'Interpreter','Latex')
set(t6,'FontSize',14)
set(t6,'HorizontalAlignment','center')


plot(u_start,v_start,'k.','MarkerSize',30,'LineWidth',lw)
str = '$\delta\alpha=\delta\beta=\delta\gamma=0$';

x = [0.8,(v_start-550)/n];
y = [0.8,(u_start+180)/m];
a = annotation('arrow',y,x);
t7 = text(m*0.85, n*0.175,str);
set(t7,'Interpreter','Latex')
set(t7,'FontSize',14)
hold off



