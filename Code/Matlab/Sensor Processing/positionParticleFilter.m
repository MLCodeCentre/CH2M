function positionParticleFilter(navFile)
% parameters to be tuned
navFile = navFile(1:50,:);

sigmaAcc = 5; sigmaPhi = 5;
sigmaGPS = 10;

% observations
x = navFile.XCOORD;
y = navFile.YCOORD;
t = navFile.GPSTIMES;
dt = [0.1;diff(t)];
nNav = numel(dt);
% create particles between minVal and maxVal each particle is:
% [x, y, theta (heading), v, a, w]
nParticles = 1000;
minVal = [x(1)-10,y(1)-10,navFile.HEADING(1)-20,-10,-30,0];
maxVal = [x(1)+10,y(1)+10,navFile.HEADING(1)+20,30,30,360];
particles = initialiseParticles(nParticles,minVal,maxVal);
% initialise weights
weights = ones(1,nParticles)/nParticles;
%% filter
for iNav = 1:nNav
    % predict the state of each particle by vehicle dynamics
    particles = stateTransitionFnc(particles,dt(iNav),sigmaAcc,sigmaPhi,nParticles);
    % weight each particle according to the observation and normalise
    weights = weightParticles(particles,x(iNav),y(iNav),weights,sigmaGPS);
    % check is resampling is required
    nEff = 1/sum(weights.^2);
    if nEff < 0.5*nParticles
        [particles,weights] = resample(particles,weights,nParticles);
    end
    % calculate expectation
    X = sum(particles.*weights,2);
    %plotTracking(X,x(iNav),y(iNav),iNav);
    XFilt(iNav,:) = X;    
end

p1 = subplot(7,1,1); cla(p1); title('Easting');
plot(x,'*--'); hold on; plot(XFilt(:,1),'*--');
p2 = subplot(7,1,2); cla(p2); title('Northing');
plot(y,'*--'); hold on; plot(XFilt(:,2),'*--');
p3 = subplot(7,1,3); cla(p3);
plot(XFilt(:,3),'*--'); title('Heading');
p4 = subplot(7,1,4); cla(p4); 
plot(XFilt(:,4),'*--'); title('Velocity');
p5 = subplot(7,1,5); cla(p5); 
plot(XFilt(:,5),'*--'); title('Acceleration');
p6 = subplot(7,1,6); cla(p6); 
plot(XFilt(:,6),'*--'); title('Steering Angle');
end

% function plotTracking(X,x,y,iNav)
% % create updating window
%     % plot position and heading
%     l = 2;
%     p1 = subplot(3,4,[1,2,5,6]); 
%     if iNav == 1 || mod(iNav,10) ==0
%         cla(p1)
%         xlim([x-10,x+10]);
%         ylim([y-10,y+10]);
%     end
%     hold on; axis equal;
%     xFilt = X(1); yFilt = X(2); theta = X(3);
%     x2=xFilt+(1*cos(deg2rad(theta)));
%     y2=yFilt+(1*sin(deg2rad(theta)));
%     plot(xFilt,yFilt,'bo');
%     plot([xFilt,x2],[yFilt,y2],'k--');
%     plot(x,y,'ro');
%     p2 = subplot(3,4,[3,4]); hold on; title('Headings')
%     if iNav == 1 || mod(iNav,10) ==0
%         cla(p2)
%     end
%     plot(iNav,X(3),'k.');
%     pause(0.5)
% end

function [newParticles,newWeights] = resample(particles,weights,nParticles)
    % resampling according to RISTIC page 42
    csw = cumsum(weights);
    i = 1;
    u1 = randN(0,1/nParticles,1);
    for j = 1:nParticles
        uj = u1 + (j-1)/nParticles;
        while uj > csw(i) && i < nParticles
            i = i+1;
        end
        inds(j) = i;
        newParticles(:,j) = particles(:,i);
        newWeights(1,j) = 1/nParticles;
    end
    fprintf('resampled to %d particles \n',length(unique(inds)))   
end

function weights = weightParticles(particles,x,y,weights,sigmaGPS)
% weight particles according the x and y observations. 
xDist = abs(particles(1,:) - x); % distance from predicted to measured 
yDist = abs(particles(2,:) - y); % and y
weightsTilde = mvnpdf([xDist;yDist]',[0,0],[sigmaGPS,sigmaGPS]); % weight as multivariate normal distribution
weights = weights.*weightsTilde'; % times old weight with new one
weights = weights./(sum(weights) + 10^-4); % normalise
end


function Xpred = stateTransitionFnc(X,dt,sigmaAcc,sigmaPhi,nParticles)
% predict where the vehicle should be according to the dynamics model.
L = 1.5; % distance from IMU to wheel base
x = X(1,:); y = X(2,:); theta = X(3,:); v = X(4,:); a = X(5,:); phi = X(6,:);
% transition matrix
xpred = x + v.*cos(theta);
ypred = y + v.*sin(theta);
thetapred = theta + v.*tan(phi)/L;
thetapred = mod(thetapred,360);
vpred = v + 0.5.*a.*dt^2;
apred = a; % process uncertainty
phipred = phi; % process uncertainty
phipred = mod(phipred,360);
Xpred = [xpred;ypred;thetapred;vpred;apred;phipred];
end

function particles = initialiseParticles(nParticles,minVal,maxVal)
% create nParticles random particles between bounds in maxVal and minVal
x = randN(minVal(1),maxVal(1),nParticles);
y = randN(minVal(2),maxVal(2),nParticles);
theta = randN(minVal(3),maxVal(3),nParticles);
v = randN(minVal(4),maxVal(4),nParticles);
a = randN(minVal(5),maxVal(5),nParticles);
phi = randN(minVal(6),maxVal(6),nParticles);
% create particles
particles = [x;y;v;theta;a;phi];
end

function r = randN(a,b,n)
% n random numbers between a and b
r = a + (b-a).*rand(1,n);
end