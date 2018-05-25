function images = getImages(easting, northing, road, min_distance, years)
% return all photos of road within a distance target easting and northing
% for all years in years.

% iterate through years
num_years = length(years);
images = table();
for year_ind = 1:num_years
    year = years{year_ind};
    % loading navFile from that year
    nav_file = readtable(fullfile(dataDir(),road,year,'Nav','Nav.csv'));
    distances = sqrt((nav_file.XCOORD - easting).^2 + (nav_file.YCOORD - northing).^2);
    nav_file = nav_file(distances>min_distance, ...
                       {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                       'PITCH','ROLL','YAW'});                  
    num_images = size(nav_file,1);
    year = repmat(year,[num_images,1]);
    distance = distances(distances>min_distance);
    angle_difference = infrontOrBehind(easting,northing,nav_file.XCOORD,nav_file.YCOORD,nav_file.HEADING);
    images = [images; nav_file, table(year, distance, angle_difference)];
end

