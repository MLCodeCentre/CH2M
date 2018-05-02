function error = cameraDisplacements()
    close all;
    
    params = config();
    plot = true;
    
    file = fullfile(dataDir(),'A27','object_positions.csv');
    data = readtable(file);

    num_rows = size(data,1);
    for row_index = 2:2
        
        row = data(row_index, :);
        img_file = fullfile('C:','CH2MData','A27','Year2','Images',row.Photo{1});
        % getting displacement vector W, with origin of car in world 
        % [Easting, Northing, Height]
        W = [row.ArcGis_XCOORD - row.Photo_XCOORD
             row.ArcGis_YCOORD - row.Photo_YCOORD
             row.Height];
        % true pixel values
        UT = [row.Pixel_Width, row.Pixel_Height];
        % theta taken from YAW of car
        theta = row.YAW;
        
        % plotting change of co-ordinate system from World to Camera
        % plotScene(W,params.Z0,theta,params.alpha);
        % R is displacement vector from camera to object in new view
        R = toCameraCoords(W,theta); 
        if plot
            plotDownTheRoad(R,params.Z0,params.alpha);
        end
        % Uses equations in woods/gonzalez to project object into image
        [x_img,y_img] = getImagePlaneCoords(R(1),R(2),R(3),params.Z0,...
                                       params.r1,params.r2,params.r3,...
                                       params.lambda,theta,params.alpha);
        % plotting on image
        if plot
            figure();
            I = imread(img_file);
            imshow(I);
            hold on
        end
        % image-coordinates changed to pixels
        [u,v] = getPixels(x_img,y_img,params.cx,params.cy, ...
                      params.sx,params.sy);
        U = [u,v];
        if plot
            plotPixels(U,UT);
        end
        disp({'Pixels: ', U(1), U(2)})
        error = norm(U-UT);
       
    end
end % cameraDisplacements.m

function plotPixels(U,UT) 
    plot(U(1),U(2),'bo')
    xlabel('u')
    ylabel('v')
    hold on
    plot(UT(1),UT(2),'ro')
    legend('Calculated','Ground Truth')
end

function plotScene(W,Z0,theta,alpha)    
    figure();
    % plotting camera and object in original world co-ordinates
    Easting = W(1);
    Northing = W(2);
    Z = W(3);
    Rot = rotx(alpha)*rotz(theta);
    plotCamera('Location',[0, 0, Z0],'Orientation',Rot,'Opacity',0,'size',0.2);
    hold on
    scatter3(Easting,Northing,Z)
    xlabel('Easting')
    ylabel('Northing')
    zlabel('Z')
    grid on
    axis equal  
end

function plotDownTheRoad(R,Z0,alpha)
    figure();
    X = R(1);
    Y = R(2);
    Z = R(3);
    RotCamera = rotx(alpha);   
    plotCamera('Location',[0, 0, Z0],'Orientation',RotCamera,'Opacity',0,'size',0.2);
    hold on
    scatter3(X,Y,Z)
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    grid on
    axis equal  
end