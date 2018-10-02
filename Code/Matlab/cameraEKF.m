function cameraEKF

close all

file_dir = fullfile(dataDir(),'A27','Year2','target_data_one_arrow.csv');
data_points = readtable(file_dir);
num_data_points = size(data_points,1);

mu_tminus1 = [0,0,0,1,1,2]';
Sigma_tminus1 = 0.0001*eye(6);
mus = [];
sigmas = [];
    for D = 1:num_data_points
        %% getting new data point and getting distance from each particle
        data_point = data_points(D,:);
        u = data_point.u;
        v = data_point.v;
        x = data_point.x-2.05;
        y = data_point.y;
        z = 0;
        
        U_t = [u;v]; X_t = [x,y,z];
        [mu_t, Sigma_t] = extended_kalman_filter(mu_tminus1, Sigma_tminus1, U_t, X_t);
        mu_tminus1 = mu_t;
        mus = [mus,mu_tminus1];
        Sigma_tminus1 = Sigma_t;
        sigmas = [sigmas,diag(Sigma_tminus1)];
        
        
    end
findRoad(mu_tminus1)
figure
plotVariables(mus,sigmas) 
end


function [mu_t, Sigma_t] = extended_kalman_filter(mu_tminus1, Sigma_tminus1, U_t, X_t)

R_t = 0.1*eye(6); %noise in motion - really small
Q_t = 0.1*eye(2); %measurement noise

mu_bar_t = g(mu_tminus1);
G_t = predictJacobian(mu_bar_t);
Sigma_bar_t = G_t*Sigma_tminus1*G_t' + R_t;

H_t = correctJacobian(X_t,mu_bar_t);
K_t = Sigma_bar_t*H_t'*inv((H_t*Sigma_bar_t*H_t' + Q_t));

mu_t = mu_bar_t + K_t*(U_t - cameraEquationFunction(mu_bar_t, X_t));
Sigma_t = (eye(6) - K_t*H_t)*Sigma_bar_t;

end

function mu_t = g(mu_tminus1)
    mu_t = mu_tminus1;
end

function plotVariables(mus,sigmas)
subplot(3,2,1)
alphas = mus(1,:);
plot(alphas)
hold on
alpha_sigmas = sigmas(1,:);
plot(alphas - alpha_sigmas,'r')
plot(alphas + alpha_sigmas,'r')
ylabel('\alpha')
%ylim([-pi/4,pi/4])

subplot(3,2,2)
betas = mus(2,:);
plot(betas)
hold on
beta_sigmas = sigmas(2,:);
plot(betas - beta_sigmas,'r')
plot(betas + beta_sigmas,'r')
ylabel('\beta')
%ylim([-pi/4,pi/4])

subplot(3,2,3)
gammas = mus(3,:);
plot(gammas)
hold on
gammas_sigmas = sigmas(3,:);
plot(gammas - gammas_sigmas,'r')
plot(gammas + gammas_sigmas,'r')
ylabel('\gamma')
%ylim([-pi/4,pi/4])

subplot(3,2,4)
L1s = mus(4,:);
plot(L1s)
hold on
L1_sigmas = sigmas(4,:);
plot(L1s - L1_sigmas,'r')
plot(L1s + L1_sigmas,'r')
ylabel('L1')
%ylim([0,2])

subplot(3,2,5)
L2s = mus(5,:);
plot(L2s)
hold on
L2_sigmas = sigmas(5,:);
plot(L2s - L2_sigmas,'r')
plot(L2s + L2_sigmas,'r')
ylabel('L2')
%ylim([0,2])

subplot(3,2,6)
hs = mus(6,:);
plot(hs)
hold on
h_sigmas = sigmas(6,:);
plot(hs - h_sigmas,'r')
plot(hs + h_sigmas,'r')
ylabel('h')
%ylim([0,3])

end