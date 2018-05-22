function photos = getImages(easting, northing, road, distance, years)
% return all photos of road within a distance target easting and northing
% for all years in years.

% iterate through years
num_years = length(years);
photos = table();
for year_ind = 1:num_years
    year = years{year_ind};
    % loading navFile from that year
    nav_file = readtable(fullfile(dataDir(),road,year,'Nav','Nav.csv'));
    dists = sqrt((nav_file.XCOORD - easting).^2 + (nav_file.YCOORD - northing).^2);
    nav_file = nav_file(dists<distance, ...
                       {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                       'PITCH','ROLL','YAW'});
                   
    num_images = size(nav_file,1);
    year_col = repmat(year,[num_images,1]);
    dist_col = dists(dists<distance);
    photos = [photos; nav_file, table(year_col, dist_col)];
    
end