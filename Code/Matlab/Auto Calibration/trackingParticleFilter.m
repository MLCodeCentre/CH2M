function trackingParticleFilter(trackedPoints,trackedCoords)

close all
SIGMA = 1000;

%road = 'A52'; %year = 'Year3';
%m = 2464; n = 2056;
m = 2560; n = 2048;
trackedPoints = trackedPoints(:,:,:);

nImages = size(trackedPoints,1);
nPoints = size(trackedPoints,2);

nParticles = 200;
[particles,weights(:,1)] = initialiseParticles(nParticles,nPoints);

for itter = 1:nImages
    if itter > 1
        nEff = 1/sum(weights(:,end).^2);
        if nEff < 0.2*nParticles
            disp('Resampling')
            [particles,weights(:,end+1)] = resample(particles,weights(:,end),nParticles);
        end
    end
    iImage = itter;
    vehicleChange = trackedCoords(itter,:) - trackedCoords(1,:);
    
    for iParticle = 1:nParticles
        % evolve each particle slightly.
        for iPoint = 1:nPoints
            
            u = trackedPoints(iImage,iPoint,1);
            v = trackedPoints(iImage,iPoint,2);
            
            xPoint = particles(iParticle,8+(3*iPoint-2));
            yPoint = particles(iParticle,8+(3*iPoint-1));
            zPoint = particles(iParticle,8+(3*iPoint));
            coords = [xPoint,yPoint,zPoint] - vehicleChange;
                        
            cameraParams = [particles(iParticle,1:8),0,0,m,n];
            [uDash,vDash] = getPixelsFromCoords(coords',cameraParams);
            d(iParticle,iPoint) = sqrt((uDash-u)^2 + (vDash-v)^2);
            pd(iParticle,iPoint) = normpdf(d(iParticle,iPoint),0,SIGMA);
        end
    end
    weightsTilde = weights(:,end)./sum(pd,2);
    weights(:,end+1) = weightsTilde/sum(weightsTilde);
    
   
    Es(itter,:) = sum(particles.*weights(:,end));
    Vars(itter,:) = sum(particles.^2.*(weights(:,end))) - (sum(particles.*weights(:,end))).^2;
    
    theta = Es(itter,:);
    cameraParams = [theta(1:8),0,0,m,n];
    for iPoint = 1:nPoints       
        u = trackedPoints(iImage,iPoint,1);
        v = trackedPoints(iImage,iPoint,2);        
        coords = theta(8+(3*iPoint-2):8+(3*iPoint)) - vehicleChange;
        [uDash,vDash] = getPixelsFromCoords(coords',cameraParams);
        reprojectionError(iPoint) = sqrt((uDash-u)^2 + (vDash-v)^2);
    end
    norm(reprojectionError)
        
    
       
end
createInfoBoard(Es,Vars)
displayHists(particles,weights(:,end))
theta = Es(end,:);
%plotTrackedPointsAfterCalibration(theta,trackedPoints,trackedCoords)
end

function [newParticles,newWeights] = resample(particles,weights,nParticles)
    % resampling according to RISTIC page 42
    csw = cumsum(weights);
    i = 1;
    u1 = randInterval(0,1/nParticles,1);
    for j=1:nParticles
        uj = u1 + (j-1)/nParticles;
        while uj > csw(i)
            i = i+1;
        end
        inds(j) = i;
        newParticles(j,:) = particles(i,:);% + mvnrnd([  0,   0,     0,  0,  0,  0,  0,    0,  0],...
                                                    %[0.001,0.001,0.001,0.001,0.001,0.001,0.01, 0,0]);
        newWeights(j,1) = 1/nParticles;
    end
%     figure
%     plot(particles(:,7),ones(nParticles,1),'r+')
%     hold on
%     plot(newParticles(:,7),2*ones(nParticles,1),'b+')
    fprintf('resampled to %d particles \n',length(unique(inds)))
    
end

function [particles, weights] = initialiseParticles(nParticles,nPoints)
    % randomly assign values within limits to each particle
    alpha = randInterval(-0.2,0.2,nParticles);
    beta = randInterval(-0.2,0.2,nParticles);
    gamma = randInterval(-0.2,0.2,nParticles);
    x0 = randInterval(5,0,nParticles);
    y0 = randInterval(-1,1,nParticles);
    h = randInterval(4,0,nParticles);
    fu = randInterval(1000,5000,nParticles);
    fv = randInterval(1000,5000,nParticles);
    particles = [alpha,beta,gamma,x0,y0,h,fu,fv];
    for iPoint = 1:nPoints
        x = randInterval(0,100,nParticles);
        y = randInterval(-10,0,nParticles);
        z = randInterval(5,0,nParticles);
        particles = [particles,x,y,z]; 
    end
    weights = (1/nParticles)*ones(nParticles,1);
end

function r = randInterval(a,b,n)
    r = a + (b-a).*rand(n,1);
end