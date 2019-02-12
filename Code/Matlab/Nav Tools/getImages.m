function images = getImages(easting, northing, road, year, camera, min_distance, max_distance)
% return all photos of road within a distance target easting and northing
% for all years in years.

% loading navFile from that year
nav_file = readtable(fullfile(dataDir(),year,road,'Nav','Nav.csv'));
distances = sqrt((nav_file.XCOORD - easting).^2 + (nav_file.YCOORD - northing).^2);
nav_file = nav_file(distances>min_distance & distances<max_distance, ...
                   {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                   'PITCH','ROLL','YAW'});                  
num_images = size(nav_file,1);
Year = repmat(year,[num_images,1]);
Distance = distances(distances>min_distance & distances<max_distance);
Heading = nav_file.HEADING;

File_Name = char(strcat([num2str(repmat(num2str(camera),[num_images,1])), ...
                   repmat('_',[num_images,1]),...
                   num2str(nav_file.PCDATE),...
                   repmat('_',[num_images,1]),...
                   num2str(nav_file.PCTIME),...
                   num2str(repmat('.jpg',[num_images,1]))...
                   ]))

Northing = nav_file.XCOORD;
Easting = nav_file.YCOORD;
PCTIME = nav_file.PCTIME;

images = table(File_Name, PCTIME, Year, Distance, Northing, Easting, Heading);

end

