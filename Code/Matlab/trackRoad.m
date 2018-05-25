function trackRoad(easting,northing,road,years)
% this function will find the identical stretch of 5ms of road infront of
% easting northing.
close all
% define how far away from eating and northing the pictures can be
distance = 5; % metres
camera = '2';
images = getImages(easting,northing,road,distance,years);

num_years = length(years);
for year_ind = 1:num_years
    % for each year find nearest photo
    year = years{year_ind};
    year_images = images(strcmp(string(images.year),year), :);
    % get images with road infront
    infront_images = year_images(year_images.angle_difference < 180, :);
    nearest_image = infront_images(infront_images.distance == min(infront_images.distance), :)
    
    % getting file name from PCDATE PCTIME
    PCDATE = nearest_image.PCDATE;
    PCTIME = nearest_image.PCTIME;
    nearest_image_file = strcat(camera,'_',num2str(PCDATE),...
                                '_',num2str(PCTIME),'.jpg');
    nearest_image_file = fullfile(dataDir(),road,year,'Images',nearest_image_file);
    
    % get easting and northing in car frame
    Tw = [easting; northing; 0]; %Target in the world
    Tc = toCameraCoords(Tw,nearest_image.YAW); %Target in car frame
    Cw = [nearest_image.XCOORD; nearest_image.YCOORD; 0]; %Car in the world
    Cc = toCameraCoords(Cw,nearest_image.YAW); %Target in car frame
    
    % Vector from Car to point
    R = Tc-Cc;
    X = -1+R(1):0.1:R(1)+1;
    Y = R(2):0.1:20+R(2);
    Z = 0;
    [XX,YY] = meshgrid(X,Y);
    [u,v] = coords2Pixels(XX,YY,Z);
    %plotWorldScene(Cw,Tw,nearest_image.YAW,83)
    %plotDownTheRoad(R,1,83);
    figure();
    I = imread(nearest_image_file);
    imshow(I);
    hold on              
    % % plotting them       
    plot(u,v,'r.-')
    hold on
    plot(u',v','r.-')
end

end



