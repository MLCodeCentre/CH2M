function plotDownTheRoad(R,Z0,alpha)
    % plotting camera and point in down the road view.
    figure();
    X = R(1);
    Y = R(2);
    Z = R(3);
    RotCamera = rotx(alpha);   
    plotCamera('Location',[0, 0, Z0],'Orientation',RotCamera,'Opacity',0,'size',0.3);
    hold on
    scatter3(X,Y,Z,'.')
    text(X,Y,Z,'P','FontWeight','bold','FontSize',14)
    xlabel('X [m]');ylabel('Y [m]');zlabel('Z [m]');title('Down The Road View')
    grid on
    axis equal
end