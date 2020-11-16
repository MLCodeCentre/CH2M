function navFileStruct = createNavFileStruct(road)
% create a struct containing all the nav_files for the inputed road.
years = {'Year1','Year2'};
nYears = numel(years);
% create empty struct

for iYear = 1:nYears
    % loading nav file
    year = years{iYear};
    navFile = readtable(fullfile(dataDir(),road,year,'Nav','Nav.csv'));
    vals{iYear} = navFile;
end

navFileStruct = containers.Map(years, vals);