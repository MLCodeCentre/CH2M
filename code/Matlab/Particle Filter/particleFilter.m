function particleFilter

%% system paramters
number_particles = 10000;
effective_ratio = 0.5;
likelihood_sigma = 500;
num_random_particles = 200;
delta_angle = 0.0001;

num_points_in_pic = 1;

close all
file_dir = fullfile(dataDir(),'A27','Year2','target_data_one_arrow.csv');
data_points = readtable(file_dir);
num_data_points = size(data_points,1);

particles_kminus1 = createRandomParticles(number_particles);    
% begin with uniform weights.
weights_kminus1 = ones(number_particles,1)/number_particles;

E = sum(particles_kminus1.*weights_kminus1)
Var = sum((bsxfun(@minus,particles_kminus1,E).^2).*weights_kminus1);
% findRoad(E)
% pause(1)
% close

Es = [E];
Vars = [Var];
delta_angle = 0.0001;
sigma_transition = [delta_angle,delta_angle,delta_angle,0,0,0];

for k = 1:num_points_in_pic:num_data_points
    
    particles_k = mvnrnd(particles_kminus1,sigma_transition);
    %image_file = char(data_point.image_file);    
    data_points_pic = data_points(k:k+num_points_in_pic-1,:);
    
    % p(z_k|x_k)
    observation_differences = zeros(number_particles,num_points_in_pic);
    for j = 1:num_points_in_pic        
        U = data_points_pic(j,:).u;
        V = data_points_pic(j,:).v;
        X = data_points_pic(j,:).x-2.05;
        Y = data_points_pic(j,:).y;
        Z = 0; 
        for i = 1:number_particles
            % finding difference in observation and particle
            particle_ik = particles_k(i,:);
            [u_hat,v_hat] = cameraEquationFunction(particle_ik,[X,Y,Z]);
            observation_differences(i,j) = sqrt((U-u_hat)^2 +  (V-v_hat)^2);
            
        end
    end
    
    observation_differences = mean(observation_differences,2);
    
    P_ZkPk = normpdf(observation_differences,0,likelihood_sigma);
    weights_k = weights_kminus1.*P_ZkPk;    
    weights_k = weights_k./sum(weights_k);
    % if number of effective particles is below half then resample all.
    Neff = 1/sum(weights_k.^2);
    if Neff < effective_ratio*number_particles
        disp('Resampling')
        % resampling
        % creating some random particles (1000)
        particles_k_resampled = resampleParticles(particles_k,weights_k,number_particles-num_random_particles);
        particles_k_random = createRandomParticles(num_random_particles);
        particles_k = [particles_k_resampled; particles_k_random];
        
        weights_k = ones(number_particles,1)/number_particles;
    end
     
          
    %displayHists(particles,weights)
    
    %The expection is then:
    E = sum(particles_k.*weights_k)
    Var = sum((bsxfun(@minus,particles_k,E).^2).*weights_k);
    Es = [Es;E];
    Vars = [Vars;Var];
    %findRoad(E)
    %displayHists(particles,weights)
    %pause(1)
    ymins = [-pi/4,-pi/4,-pi/4,0,0,0];
    ymaxs = [pi/4,pi/4,pi/4,3,3,3];
    createInfoBoard(Es,Vars,E,U,V,num_data_points,k,ymins,ymaxs)
    %pause(1)
    close

    particles_kminus1 = particles_k;
    weights_kminus1 = weights_k;
    
    
end
findRoad(E)
plotMeansAndSigmas(Es,Vars)

end


function new_particles = resampleParticles(particles,weights,number_particles)
    
    new_paricles = zeros(size(particles));
    
    % draw N times from uniform
    u = rand(number_particles,1);
    u_o = sort(u);
    sumQ = 0; i = 0; j = 1;
    
    while j <= number_particles
        i = i+1;
        sumQ = sumQ + weights(i);
        while(j<=number_particles) && (sumQ > u_o(j))
            new_particles(j,:) = particles(i,:);
            j = j + 1;
        end
    end
    
    %new_weights = ones(number_particles,1)/number_particles;
end

function particles = createRandomParticles(number_particles)

    angle_min = -pi/4;
    angle_max = pi/4;
    
    particles = [randRange(angle_min,angle_max,number_particles),...
                 randRange(angle_min,angle_max,number_particles),...
                 randRange(angle_min,angle_max,number_particles),...
                 randRange(0.5,3,number_particles),...
                 randRange(0.5,3,number_particles),...
                 randRange(1,3,number_particles)];
end

function r = randRange(a,b,N)
    r = (b-a).*rand(N,1) + a;
end
