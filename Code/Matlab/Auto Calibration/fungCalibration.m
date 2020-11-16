function cameraParams = fungCalibration(road,imageFile)

close all

img = imread(fullfile(dataDir(),road,'Year3','Images',imageFile));
imshow(img)
m = size(img,2); n = size(img,1);

WIDTH = 1.5;
%% load corner data and split into variables given by paper
% corners = [1461.81386861314, 1248.82116788321;
%           1611.69221411192, 1413.68734793187;
%           2010.36861313869, 1245.82360097324;
%           2436.02311435523, 1398.69951338199];

% corners = [1464.81143552311          1269.80413625304
%           1629.67761557178          1446.66058394161
%           1995.38077858881          1260.81143552311
%           2445.01581508516          1428.67518248175]

[u,v] = ginput(4);
corners = [u,v];
 
% change to centre of image
corners(:,1) = corners(:,1) - m/2;
corners(:,2) = -corners(:,2) + n/2;
xA = corners(1,1); yA = corners(1,2);
xB = corners(2,1); yB = corners(2,2);
xC = corners(3,1); yC = corners(3,2);
xD = corners(4,1); yD = corners(4,2);
% scatter(corners(:,1),corners(:,2),'r+');
% hold on
% text(xA,yA,'A'); text(xB,yB,'B'); text(xC,yC,'C'); text(xD,yD,'D');
alphaAB = xB - xA; betaAB = yB - yA; chiAB = xA*yB - xB*yA;
alphaAC = xC - xA; betaAC = yC - yA; chiAC = xA*yC - xC*yA;
alphaBD = xD - xB; betaBD = yD - yB; chiBD = xB*yD - xD*yB;
alphaCD = xD - xC; betaCD = yD - yC; chiCD = xC*yD - xD*yC;

tans = (- betaAB*betaAC*chiBD*alphaCD + betaAC*alphaBD*betaAB*chiCD ...
            + betaCD*chiAB*betaBD*alphaAC - betaAB*chiCD*betaBD*alphaAC ...
            - betaCD*betaBD*chiAC*alphaAB - betaAC*chiAB*alphaBD*betaCD ...
            + betaAB*chiAC*betaBD*alphaCD + betaCD*betaAC*chiBD*alphaAB) / ...
           (- betaAB*chiAC*alphaBD*alphaCD + betaAC*chiAB*alphaBD*alphaCD ...
            - betaAC*alphaBD*alphaAB*chiCD - alphaAC*chiBD*betaCD*alphaAB ...
            - alphaCD*chiAB*betaBD*alphaAC + betaAB*alphaAC*chiBD*alphaCD ...
            + alphaAB*chiCD*betaBD*alphaAC + alphaBD*chiAC*betaCD*alphaAB);
s = atan(tans);
rad2deg(s)

sint = -sqrt((((alphaBD*chiAC - alphaAC*chiBD)*sin(s) + (betaBD*chiAC - betaAC*chiBD)*cos(s)) * ...
         ((alphaCD*chiAB - alphaAB*chiCD)*sin(s) + (betaCD*chiAB - betaAB*chiCD)*cos(s))) / ...
        (((alphaCD*chiAB - alphaAB*chiCD)*cos(s) + (betaAB*chiCD - betaCD*chiAB)*sin(s)) * ...
         ((betaBD*chiAC - betaAC*chiBD)*sin(s)   + (alphaAC*chiBD - alphaBD*chiAC)*cos(s))));
     
t = asin(sint);
rad2deg(t)

tanp = (sin(t)*((betaBD*chiAC - betaAC*chiBD)*sin(s) + (alphaAC*chiBD - alphaBD*chiAC)*cos(s))) / ...
               ((alphaBD*chiAC - alphaAC*chiBD)*sin(s) + (betaBD*chiAC - betaAC*chiBD)*cos(s));

p = atan(tanp);
rad2deg(p)

f = (chiBD*(cos(p)*cos(t))) / ...
    (betaBD*sin(p)*cos(s) - betaBD*cos(p)*sin(t)*sin(s) ... 
  + alphaBD*sin(p)*sin(s) + alphaBD*cos(p)*sin(t)*cos(s))


l = WIDTH*(f*sin(t) + xA*cos(t)*sin(s) + yA*cos(t)*cos(s))*(f*sin(t) + xC*cos(t)*sin(s) + yC*cos(t)*cos(s)) / ...
    (-((f*sin(t)+xA*cos(t)*sin(s)+yA*cos(t)*cos(s)) * ...
      (xC*cos(p)*sin(s) - xC*sin(p)*sin(t)*cos(s) + yC*cos(p)*cos(s) + yC*sin(p)*sin(t)*sin(s))) ...
     +((f*sin(t)+xC*cos(t)*sin(s)+yC*cos(t)*cos(s)) * ...
      (xA*cos(p)*sin(s) - xA*sin(p)*sin(t)*cos(s) + yA*cos(p)*cos(s) + yA*sin(p)*sin(t)*sin(s))))
  
XCAM = l*sin(p)*cos(t)
YCAM = -l*cos(p)*cos(t)
ZCAM = -l*sin(t)

%% converting back to usual notation
cameraParams.alpha = s; cameraParams.beta = t; cameraParams.gamma = -(pi/2 - p);
cameraParams.x0 = 0; cameraParams.y0 = 0; cameraParams.h = ZCAM;
cameraParams.fu = f; cameraParams.fv = f;

% adding others
%radial 
cameraParams.k1 = 0; cameraParams.k2 = 0;
% tangential
cameraParams.p1 = 0; cameraParams.p2 = 0;
% centre point
cameraParams.cu = 0; cameraParams.cv = 0;
cameraParams.s = 0;

cameraParams.m = m; cameraParams.n = n;

imshow(img)
hold on
xRange = linspace(5,60,10);
yRange = linspace(-2,2,4);
zRange = 0;

for x = xRange
    for y = yRange
        for z = zRange
            [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
            plot(u,v,'ro')
        end
    end
end

end