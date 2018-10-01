function bayesOpt
close all
file_dir = fullfile(dataDir(),'A27','Year2','target_data.csv');
data_points = readtable(file_dir);

num_rows = size(data_points,1);

h = 2.5;

% define parameter distribution as a multivariate pdf
mu_prior = 0;
sigma_prior = 100;
theta_sample = [normrnd(mu_prior,sigma_prior), -0.112736209888317,   0.005422460046276,   0.817631205649983,   0.872856749516468];%   1.862386606078967

%% first guess init
XU = [];
for D = 20:-1:15
    %% getting new data point and getting distance from each particle
    data_point = data_points(D,:);
    U = data_point.u;
    V = data_point.v;
    X = data_point.x-2.05;
    Y = data_point.y;
    Z = -h; 
    
    [u_hat,v_hat] = cameraEquationFunction(theta_sample,[X,Y,Z]);
    dist = sqrt((U-u_hat)^2 + (V-v_hat)^2);
    XU = [XU, dist];
end

mu_likelihood = 0;
sigma_likelihood = sqrt(sum(XU.^2)/(length(XU)-1));

mu_post = (sigma_prior*mu_likelihood + sigma_likelihood*mu_prior)/(sigma_prior + sigma_likelihood);
sigma_post = (1/((1/sigma_prior) + (1/sigma_likelihood)));

range = -pi/4:0.01:pi/4;
plot(range,normpdf(range,mu_prior,sigma_prior))
hold on
plot(range,normpdf(range,mu_likelihood,sigma_likelihood))
plot(range,normpdf(range,mu_post,sigma_post))

%% now iterate
for D = 15:-1:1
    %% getting new data point and getting distance from each particle
    data_point = data_points(D,:);
    U = data_point.u;
    V = data_point.v;
    X = data_point.x-2.05;
    Y = data_point.y;
    Z = -h; 
    
    [u_hat,v_hat] = cameraEquationFunction(theta_sample,[X,Y,Z]);
    dist = sqrt((U-u_hat)^2 + (V-v_hat)^2);
    XU = [XU, dist];
end


