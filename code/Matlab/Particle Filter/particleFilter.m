function particleFilter

%% system paramters
number_particles = 10000;

effective_ratio = 0.3;
likelihood_sigma = 50;
num_random_particles = 500;
delta_angle = 0.0001;

x_cam = 2.05; y_cam = 0;
system_params = [1280, 1024, 2560, 2048, x_cam, y_cam];

sigma_transition = [delta_angle,delta_angle,delta_angle,0,0,0];

video = false;

close all
file_dir = fullfile(dataDir(),'A27','Year2','target_data_road_2.csv');
num_points_in_pic = 1;
data_points = readtable(file_dir);
num_data_points = size(data_points,1)/num_points_in_pic;

%% initialisation
particles_kminus1 = createRandomParticles(number_particles);    
% begin with uniform weights.
weights_kminus1 = ones(number_particles,1)/number_particles;

E = sum(particles_kminus1.*weights_kminus1)
Var = sum((bsxfun(@minus,particles_kminus1,E).^2).*weights_kminus1);
k0 = 0;
ymins = [-pi/4,-pi/4,-pi/4,0,0,0];
ymaxs = [pi/4,pi/4,pi/4,3,3,3];
Es = [E];
Vars = [Var];

if video == true
    createInfoBoard(Es,Vars,E,0,0,num_data_points,k0,ymins,ymaxs)
end
% findRoad(E)
% pause(1)
% close

%% particle filter iterations
for k = 1:num_data_points
    
    particles_k = mvnrnd(particles_kminus1,sigma_transition);
    %image_file = char(data_point.image_file);    
    data_points_pic = data_points(k*num_points_in_pic - (num_points_in_pic-1):k*num_points_in_pic,:);
    %data_points_pic = data_points(k,:);
    
    % p(y_k|x_k)        
    U = data_points_pic.u;
    V = data_points_pic.v;
    X = data_points_pic.x;
    Y = data_points_pic.y;
    Z = zeros(num_points_in_pic,1);
    
    for i = 1:number_particles
        % finding difference in observation and particle
        particle_ik = particles_k(i,:);
        norm = cameraEquationFunction(particle_ik,[X,Y,Z,U,V],system_params);
        observation_differences(i,1) = norm;           
    end
        
    %P_ZkPk = normpdf(observation_differences,0,likelihood_sigma);
    P_ZkPk = observation_differences;
    weights_k = weights_kminus1.*P_ZkPk;    
    weights_k = weights_k./sum(weights_k);
    % if number of effective particles is below half then resample all.
    Neff = 1/sum(weights_k.^2);
    if Neff < effective_ratio*number_particles
        disp('Resampling')
        % resampling
        % creating some random particles
        particles_k_resampled = resampleParticles(particles_k,weights_k,number_particles-num_random_particles);
        particles_k_random = createRandomParticles(num_random_particles);
        particles_k = [particles_k_resampled; particles_k_random];
        
        weights_k = ones(number_particles,1)/number_particles;
    end
    
    %displayHists(particles,weights)
    %The expection is then:
    E = sum(particles_k.*weights_k)
    % and variance
    Var = sum((bsxfun(@minus,particles_k,E).^2).*weights_k);
    Es = [Es;E];
    Vars = [Vars;Var];
    %findRoad(E)
    %displayHists(particles,weights)
    %pause(1)
<<<<<<< HEAD
    ymins = [-pi/4,-pi/4,-pi/4,0,0,0];
    ymaxs = [pi/4,pi/4,pi/4,3,3,3];
    %createInfoBoard(Es,Vars,E,U,V,num_data_points,k,ymins,ymaxs)
    %pause(1)
    close

=======
    
    if video == true
        createInfoBoard(Es,Vars,E,U,V,num_data_points,k,ymins,ymaxs)
        fprintf('Created %d Images',k)
        close
    end    
    %update
>>>>>>> cbfe253bb6d58242a7f62e2b523f5543032dbf7a
    particles_kminus1 = particles_k;
    weights_kminus1 = weights_k;
    
    
end
findRoad(E,system_params,'A27','Year2')
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
