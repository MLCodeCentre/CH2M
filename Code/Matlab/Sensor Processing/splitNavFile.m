function navFileSections = splitNavFile(navFile,showPlot)
% SPLITNAVILE splits navFile up using time steps. If the time step is over a threshold
% then the vehicle is assumed to have stopped moving for a longer period of
% time. This is designed to help the kalman filter. 

if showPlot
    figure; hold on; % new fig for plotting;
end

TIME_THRESH = 10; % section breaks are time steps longer than 1 TIME_THRESH. 
ts = [0.1; diff(navFile.GPSTIMES)]; % time steps - guessing the first. 
% create sections
navFileSections = {};
sectionStartInd = 1;
nNav = size(navFile,1);

for iNav = 1:nNav
    if abs(ts(iNav)) > TIME_THRESH
        if iNav == nNav
            navFileSection = navFile(sectionStartInd:iNav,:);
        else
            navFileSection = navFile(sectionStartInd:iNav-1,:);
        end
        navFileSections{end+1} = navFileSection; % add to section        
        if showPlot
            scatter(navFileSection.XCOORD,navFileSection.YCOORD,'.')
        end
        sectionStartInd = iNav; % this is the start of the next section
    end
end
% add final section to the end, if not already at the end. 
if sectionStartInd ~= nNav
   navFileSections{end+1} = navFile(sectionStartInd:end,:);
end
