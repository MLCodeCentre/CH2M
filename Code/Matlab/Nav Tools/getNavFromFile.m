function nav_data = getNavFromFile(varargin)
% returns nav file data for the file specified.
% positional args: file, road, year
% optional args: nav_file. 

file = varargin{1};
road = varargin{2};
year = varargin{3};
% can either pass the nav file or load it. When running loops loading the
% nav file form disk every time is slow.
if nargin == 3
    nav_file = readtable(fullfile(dataDir(),year,road,'Nav','Nav.csv')); 
elseif nargin == 4
    nav_file = varargin{4};
end

% splitting file name into camera, PCDATE and PCTIME. 
file_name = extractBefore(file,'.');
file_info = split(file_name,'_');
camera = str2num(char(file_info(1))); PCDATE = str2num(char(file_info(2))); PCTIME = str2num(char(file_info(3)));

% finding in nav data.
nav_data = nav_file((nav_file.PCDATE==PCDATE) & (nav_file.PCTIME==PCTIME),...
                    {'XCOORD','YCOORD','HEADING','PCDATE','PCTIME',...
                     'PITCH','ROLL','YAW'});
end