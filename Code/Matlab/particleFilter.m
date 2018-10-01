function particleFilter

% system paramters
number_particles = 20000;
effective_ratio = 0.5; 

close all
file_dir = fullfile(dataDir(),'A27','Year2','target_data_left_metal_structure.csv');
data_points = readtable(file_dir);
num_data_points = size(data_points,1);

particles_kminus1 = createRandomParticles(number_particles);    
% begin with uniform weights.
weights_kminus1 = ones(number_particles,1)/number_particles;

E = sum(particles_kminus1.*weights_kminus1)
% findRoad(E)
% pause(1)
close

%displayHists(particles)
Es = [];
Vars = [];
delta_angle = 0.0001;
sigma_transition = [delta_angle,delta_angle,delta_angle,0,0,0];

for D = 1:num_data_points
    
    particles_k = mvnrnd(particles_kminus1,sigma_transition);
    
    %% getting new data point and getting distance from each particle
    data_point = data_points(D,:);
    U = data_point.u;
    V = data_point.v;
    X = data_point.x-2.05;
    Y = data_point.y;
    Z = 0; 
    
    % p(z_k|x_k)
    observation_differences = zeros(number_particles,1);
    for i = 1:number_particles
        % finding difference in observation and particle
        particle_ik = particles_k(i,:);
        [u_hat,v_hat] = cameraEquationFunction(particle_ik,[X,Y,Z]);
        observation_differences(i) = sqrt((U-u_hat)^2 +  (V-v_hat)^2);
    end
    P_ZkPk = normpdf(observation_differences,0,200);
    weights_k = weights_kminus1.*P_ZkPk;
%     % p(x_k|x^i_k-1)
%     for i = 1:number_particles
%         particle_ikminus1 = particles_kminus1(i,:);
%         PkPkminus1_differences = bsxfun(@minus, particle_ikminus1, particles_k);
%         P_PkPkminus1 = mvnpdf(PkPkminus1_differences, mu_transition, sigma_transition);
%         weights_k(i) = weights_kminus1(i)*sum(P_ZkPk.*P_PkPkminus1);
%     end
    
    weights_k = weights_k./sum(weights_k);
    % if number of effective particles is below half then resample all.
    Neff = 1/sum(weights_k.^2);
    if Neff < effective_ratio*number_particles
        disp('Resampling')
        % resampling
        % creating some random particles (1000)
        particles_k = resampleParticles(particles_k,weights_k,number_particles);
        weights_k = ones(number_particles,1)/number_particles;
        %particles_k_random = createRandomParticles(500);
        %particles_k = [particles_resampled_k; particles_k_random];
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
    %close
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
    
    particles = [randRange(-pi/8,pi/8,number_particles),...
                 randRange(-pi/8,pi/8,number_particles),...
                 randRange(-pi/8,pi/8,number_particles),...
                 randRange(0.5,2,number_particles),...
                 randRange(0.5,2,number_particles),...
                 randRange(1,3,number_particles)];
end

function r = randRange(a,b,N)
    r = (b-a).*rand(N,1) + a;
end
