function navFile = preProcessNavFile(navFile)
% function to call kalman filter to filter positions then the usual heading
% correction. 
navFile = kalmanFilter(navFile);
navFile = fixHeadingsCentralDiff(navFile);
%plotCorrections(navFile);
% save filtered version for plotting with folium
%writetable(navFile,fullfile(dataDir,road,'Nav',sprintf('%s_filtered.csv',road)));

% and update
navFile.XCOORDOLD = navFile.XCOORD;
navFile.YCOORDOLD = navFile.YCOORD;
navFile.XCOORD = navFile.XCOORDFILT;
navFile.YCOORD = navFile.YCOORDFILT;
navFile.HEADINGOLD = navFile.HEADING;
navFile.HEADING = navFile.HEADINGCD;

end