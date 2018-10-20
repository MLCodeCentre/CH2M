function nav_data = getNavFromFile(file,road,year)

file_name = extractBefore(file,'.');
file_info = split(file_name,'_');
camera = str2num(char(file_info(1))); PCDATE = str2num(char(file_info(2))); PCTIME = str2num(char(file_info(3)));

nav_file = readtable(fullfile(dataDir(),road,year,'Nav','Nav.csv'));
nav_data = nav_file((nav_file.PCDATE==PCDATE) & (nav_file.PCTIME==PCTIME),...
                    {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                     'PITCH','ROLL','YAW'});
