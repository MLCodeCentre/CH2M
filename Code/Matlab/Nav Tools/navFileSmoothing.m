function navFileSmoothing(navFile)
% MAKE SURE NAV FILE HAS HAD THE HEADINGS FIXED FIRST
close all
figure; hold on;

navFile = navFile(1000:10000,:);

XCOORD = navFile.XCOORD; YCOORD = navFile.YCOORD; HEADING = navFile.HEADING;
XCOORDFilt = XCOORD(1); YCOORDFilt = YCOORD(1); HEADINGFilt = HEADING(1); 

nImages = size(navFile,1);
% initialisation
Xkm1 = [XCOORD(1),YCOORD(1),HEADING(1)]; 
L=2;

sigmaGPSModel = 1;
sigmaHeadingModel = 1;

sigmaGPSMeasure = 1;
sigmaHeadingMeasure = 1;

Pkm1 = [1,0,0
        0,1,0
        0,0,1];

Q = [sigmaGPSModel,0,0;
     0,sigmaGPSModel,0;
     0,0,sigmaHeadingModel];

H = [sigmaGPSMeasure,0,0;
     0,sigmaGPSMeasure,0;
     0,0,sigmaHeadingMeasure];

R = [0,0,0;
     0,0,0;
     0,0,0];

for kImage = 2:nImages
    
    % PREDICT state update xk+1 = f(xk)
    Xk =[Xkm1(1)+(L*sin(deg2rad(Xkm1(3))));
         Xkm1(2)+(L*cos(deg2rad(Xkm1(3))));
         Xkm1(3)];
    
    % predict covariance estimate
    Fk = [1, 0,  L*cos(deg2rad(Xk(3)));
         0, 1, -L*sin(deg2rad(Xk(3)));
         0, 0,  1];
      
    Pk = Fk*Pkm1*Fk' + Q;

    % UPDATE 
    % measurement
    zk = [XCOORD(kImage),YCOORD(kImage),HEADING(kImage)]';  
    % innovation
    yk = zk - Xk;
    % innovation variance
    Sk = H*Pk*H' + R; 
    % kalman gain
    Kk = Pk*H'*inv(Sk);
    % update state
    Xk = Xk + Kk*yk;
    % update covariance
    Pk = (eye(3)-Kk*H)*Pk;

    % plotting Smoothed
    x = Xk(1); y = Xk(2); theta = Xk(3);
    plot(x,y,'bo')
    x2=x+(L*sin(deg2rad(theta)));
    y2=y+(L*cos(deg2rad(theta)));
    plot([x x2],[y y2],'r--')
    % and raw
    hold on
    x = zk(1); y = zk(2); theta = zk(3);
    plot(x,y,'ko')
    x2=x+(L*sin(deg2rad(theta)));
    y2=y+(L*cos(deg2rad(theta)));
    plot([x x2],[y y2],'k--')
    
    XCOORDFilt(end+1) = Xk(1);
    YCOORDFilt(end+1) = Xk(2);
    HEADINGFilt(end+1) = Xk(3);
    
    % reset
    Xkm1 = Xk;
    Pkm1 = Pk;

end

end