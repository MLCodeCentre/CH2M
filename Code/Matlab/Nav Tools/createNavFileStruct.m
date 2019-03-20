function navFileStruct = createNavFileStruct(road)
% create a struct containing all the nav_files for the inputed road.
years = {'Year1','Year2'};
num_years = numel(years);
% create empty struct

for year_ind = 1:num_years
    % loading nav file
    year = years{year_ind};
    nav_file = readtable(fullfile(dataDir(),road,year,'Nav','Nav.csv'));
    vals{year_ind} = nav_file;
end

navFileStruct = containers.Map(years, vals);

