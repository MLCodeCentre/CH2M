function plotWorldScene(C,P,theta,alpha)
    figure()
    Rot = rotx(alpha)*rotz(theta);
    plotCamera('Location',[C(1), C(2), C(3)],'Orientation',Rot,'Opacity',0,'size',0.3);
    hold on
    Easting = P(1);
    Northing = P(2);
    Z = P(3);
    scatter3(Easting,Northing,Z,'.')
    text(Easting,Northing,Z,'P','FontWeight','bold','FontSize',14)
    xlabel('Easting [m]');ylabel('Northing [m]');zlabel('Z [m]');title('World View')
    grid on
    axis equal  
end
