function UVAngle

close all  
h = 1;
X = 2;
Y = 0;
Z = 2:20;

lambda = 1;
alpha = 0;
alpha = deg2rad(alpha);

[X,Z] = meshgrid(X,Z);

Up = getU(0,0,100000,lambda,alpha,h)
Vp = getV(0,0,100000,lambda,alpha,h)
Vp_calc = lambda*tan(alpha);

subplot(2,2,1)
U = getU(X,Y,Z,lambda,alpha,h); 
plot(Z(:),U(:),'g.')
xlabel('Z'); ylabel('U')

subplot(2,2,2)
V = getV(X,Y,Z,lambda,alpha,h);
plot(Z(:),V(:),'k.')
xlabel('Z'); ylabel('V')

subplot(2,2,3)
tanPhi = (V-Vp)./(U-Up);
phi = wrapTo360(atan(tanPhi));
plot(Z(:),phi(:),'.');
xlabel('Z');
ylabel('\phi');
ylim([0,2*pi])

subplot(2,2,4)
plot(U(:),V(:),'r.-')
xlabel('U');
ylabel('V');
%axis equal
grid on
%set(gca,'Ydir','reverse'
Umax = max(abs(min(U(:))),abs(max(U(:))));
xlim([-Umax, Umax])
Vmax = max(abs(min(V(:))),abs(max(V(:))));
ylim([-Vmax, Vmax])

end


function U = getU(X,Y,Z,lambda,alpha,h)
    U = (lambda.*X) ./...
        (lambda - Z.*cos(alpha) - (Y-h).*sin(alpha));
end

function V = getV(X,Y,Z,lambda,alpha,h)
    V = (lambda.*(-Z.*sin(alpha) + (Y-h).*cos(alpha))) ./...
         (lambda - Z.*cos(alpha) - (Y-h).*sin(alpha));
end

% Z IS DOWN ROAD X,Y UP ACROSS ROAD PLANE