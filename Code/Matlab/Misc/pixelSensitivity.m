function pixelSensitivity(road,year)
% This function explores the sensitivity of the model due to pixel error.

    %% Initialising system parameters and data
    if strcmp(year,'Year1')
        x_cam = 2.05; y_cam = 0;
                         %cx    cy    m      n
        system_params = [1280, 1024, 2560, 2048, x_cam, y_cam];   
    elseif strcmp(year,'Year2')
        x_cam = 2.05; y_cam = 0;
        system_params = [1280, 1024, 2560, 2048, x_cam, y_cam];
    elseif strcmp(year,'Year3')
        x_cam = 2.05; y_cam = 0;
        system_params = [1232, 1028, 2464, 2056, x_cam, y_cam];
    end

    % loading data
    close all
    file_dir = fullfile(dataDir(),road,year,'target_data_road_4_targets.csv');
    data_points = readtable(file_dir);
    num_data_points = size(data_points,1);

    fprintf('%d data points in %s\n',num_data_points,year);
    
    n = 3;
    %D = num_data_points - n;
    fprintf('Solving with %d data points\n',n);

    data_points = data_points(end-(n-1):end,:);

    %% solving for No pixel change - this will be the baseline.
    theta_star = solveEquations(data_points,0,0,system_params);
       
    %% solving in 1d
    pixel_range = 40;
    res = 2;
    
    du_range = -pixel_range:res:pixel_range;
    dv_range = -pixel_range:res:pixel_range;
        
    theta_du_changes = zeros(length(du_range),8);
    fvals = zeros(length(du_range),1);
    disp('Calculating Changes in u')
    du_ind = 1;
    for du = du_range
       [theta_solve, fval] = solveEquations(data_points,du,0,system_params);
        theta_change = abs(theta_star - theta_solve); %percentage change;
        theta_du_changes(du_ind,:) = theta_change;
        du_ind = du_ind+1;
    end
    
    theta_dv_changes = zeros(length(du_range),8);
    disp('Calculating Changes in v')
    dv_ind = 1;
    for dv = dv_range
       [theta_solve, fval] = solveEquations(data_points,0,dv,system_params);
        theta_change = abs(theta_star - theta_solve); %percentage change;
        theta_dv_changes(dv_ind,:) = theta_change;
        dv_ind = dv_ind+1;
    end
    
    %% first image
    % alpha
    subplot(3,1,1)
    plot(du_range,rad2deg(theta_du_changes(:,1)),dv_range,rad2deg(theta_dv_changes(:,1)))
    xlabel('Pixel change [pixels]'); ylabel('\alpha change [degs]'); title('Roll');
    legend('u','v');
    % beta
    subplot(3,1,2)
    plot(du_range,rad2deg(theta_du_changes(:,2)),dv_range,rad2deg(theta_dv_changes(:,2)))
    xlabel('Pixel change [pixels]'); ylabel('\beta change [degs]'); title('Tilt');
    legend('u','v');
    % gamma
    subplot(3,1,3)    
    plot(du_range,rad2deg(theta_du_changes(:,3)),dv_range,rad2deg(theta_dv_changes(:,3)))
    xlabel('Pixel change [pixels]'); ylabel('\gamma change [degs]'); title('Pan');
    legend('u','v');
    %% second image
    figure;
    % L1
    subplot(2,1,1)
    plot(du_range,theta_du_changes(:,4),dv_range,theta_dv_changes(:,4))
    xlabel('Pixel Change'); ylabel('\lambda/L_1 Change'); title('\lambda/L_1');
    legend('u','v');
    % L2
    subplot(2,1,2)
    plot(du_range,theta_du_changes(:,5),dv_range,theta_dv_changes(:,5))
    xlabel('Pixel Change'); ylabel('\lambda/L_2 Change'); title('\lambda/L_2');
    legend('u','v');
    %% third image
    figure;
    subplot(3,1,1)
    plot(du_range,theta_du_changes(:,6),dv_range,theta_dv_changes(:,6))
    xlabel('Pixel Change'); ylabel('h Change'); title('Height');
    legend('u','v');
    
    subplot(3,1,2)
    plot(du_range,theta_du_changes(:,7),dv_range,theta_dv_changes(:,7))
    xlabel('Pixel Change'); ylabel('x_0 Change [m]'); title('Offset x_0');
    legend('u','v');
    
    subplot(3,1,3)
    plot(du_range,theta_du_changes(:,8),dv_range,theta_dv_changes(:,8))
    xlabel('Pixel Change'); ylabel('y_0 Change [m]'); title('Offset y_0');
    legend('u','v');
%% Solving in 2d

%     A = zeros(length(du_range),length(dv_range)); B = zeros(length(du_range),length(dv_range)); 
%     G = zeros(length(du_range),length(dv_range)); L1 = zeros(length(du_range),length(dv_range));
%     L2 = zeros(length(du_range),length(dv_range)); h = zeros(length(du_range),length(dv_range));
%     change = zeros(length(du_range),length(dv_range));
%     
%     % we now solve for small changes in u and v and see how theta changes.
%     i = 1;
%     for du = du_range
%         j = 1;
%         du
%         for dv = dv_range
%             [theta_solve, fval] = solveEquations(data_points,du,dv,system_params);
%             theta_change = abs(theta_star - theta_solve);
%             A(i,j) = rad2deg(theta_change(1));
%             B(i,j) = rad2deg(theta_change(2));
%             G(i,j) = rad2deg(theta_change(3));
%             L1(i,j) = theta_change(4);
%             L2(i,j) = theta_change(5);
%             h(i,j) = theta_change(6);
%             change(i,j) = dot(theta_star,theta_solve);
%             j = j + 1;
%         end
%         i = i + 1;
%     end
% 
% % figure;
% % imagesc('XData',du_range,'YData',dv_range,'CData',change)
% % title('dot product'); xlabel('\delta u'); ylabel('\delta v');
% % colorbar
% % caxis([0 3]);
%  
% figure;
% imagesc('XData',du_range,'YData',dv_range,'CData',A)
% title('\alpha Error'); xlabel('\delta u'); ylabel('\delta v');
% c = colorbar; c.Label.String = 'Change in \alpha [degs]';
% caxis([0, max(A(:))]);
% saveas(gcf,'Images/alpha2.png')
% 
% figure;
% imagesc('XData',du_range,'YData',dv_range,'CData',B)
% title('\beta Error'); xlabel('\delta u'); ylabel('\delta v');
% c = colorbar; c.Label.String = 'Change in \beta [degs]';
% caxis([0, max(B(:))]);
% saveas(gcf,'Images/beta.png')
% 
% figure;
% imagesc('XData',du_range,'YData',dv_range,'CData',G)
% title('\gamma Error'); xlabel('\delta u'); ylabel('\delta v');
% c = colorbar; c.Label.String = 'Change in \gamma [degs]';
% caxis([0, max(G(:))]);
% saveas(gcf,'Images/gamma.png')
% 
% figure;
% imagesc('XData',du_range,'YData',dv_range,'CData',L1)
% title('L1 Error'); xlabel('\delta u'); ylabel('\delta v');
% c = colorbar; c.Label.String = 'Change in L1';
% caxis([0, max(L1(:))]);
% saveas(gcf,'Images/L1.png')
% 
% figure;
% imagesc('XData',du_range,'YData',dv_range,'CData',L2)
% title('L2 Error'); xlabel('\delta u'); ylabel('\delta v');
% c = colorbar; c.Label.String = 'Change in L2';
% caxis([0, max(L2(:))]);
% saveas(gcf,'Images/L2.png')
% 
% figure;
% imagesc('XData',du_range,'YData',dv_range,'CData',h)
% title('h Error'); xlabel('\delta u'); ylabel('\delta v');
% c = colorbar; c.Label.String = 'Change in height [m]';
% caxis([0, max(h(:))]);
% saveas(gcf,'Images/h.png')

end

function [theta_solve,fvalfmu] = solveEquations(data_points,du,dv,system_params)

    
    u = data_points.u + du;
    v = data_points.v + dv;
    x = data_points.x;
    y = data_points.y;
    z = zeros(size(y,1),1);

    coords = [x,y,z,u,v];
    theta_0 = [0,0,0,1,1,3,2,0];
    %ub = [ pi/4,  pi/4,  pi/4,  5,    5,    3];
    %lb = [-pi/4, -pi/4, -pi/4,  0.1,  0.1,  3];

    f = @(theta) cameraEquationFunction(theta,coords,system_params);
    options = optimoptions('fminunc','MaxFunctionEvaluations',10000,'MaxIterations',10000,'FunctionTolerance',1E-08,'display','off');
    [theta_solve,fvalfmu,eflagfmu,outputfmu] = fminunc(f,theta_0,options);


end



