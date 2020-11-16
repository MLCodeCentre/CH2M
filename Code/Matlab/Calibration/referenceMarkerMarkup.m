function referenceMarkerMarkup(navFile, referenceMarkers)
% collecting lots and lots of calibration data from reference markers. I
% know that they are 1.1 m in height.

% creating calibration datatable. 
%referenceMarkerData = cell2table(cell(0,10), 'VariableNames', {'PCDATE','PCTIME',...
    %'GPS_x','GPS_y','Marker_x','Marker_y','u_b','v_b','u_t','v_t'});
% now loading..
referenceMarkerData = readtable(fullfile(dataDir(),'M69','Calibration',...
    'referenceMarkerData.csv'));
if size(referenceMarkerData,1) > 0
    lastPCDATE = referenceMarkerData(end,:).PCDATE;
    lastPCTIME = referenceMarkerData(end,:).PCTIME;
    idxStart = find(navFile.PCTIME==lastPCTIME & navFile.PCDATE==lastPCDATE);
    % looping through all images
    navFile = navFile(idxStart:end,:);
end
nNav = size(navFile,1);
skip = 5;
for iNav = 1:skip:nNav
   % load image and find markers that are close. 
   image = navFile(iNav,:);
   [closeMarkers,coordinates,~] = findCloseAssets(referenceMarkers,image);
   nMarkers = size(closeMarkers,1);
   for iMarker = 1:nMarkers
       marker = closeMarkers(iMarker,:);
       markerID = marker.SOURCE_ID{1};
       % these coordinates are to help find the asset in the image. 
       x = coordinates(iMarker,1);
       y = coordinates(iMarker,2);
       z = coordinates(iMarker,3);
       fprintf('+------------------------------------------------------------------+\n')
       fprintf('Marker %s at coordinates (%0.2f, %0.2f, %0.2f) rel to vehicle \n',...
           markerID, x,y,z);
       img = loadImage(image,'M69'); imshow(img);
       % get pixels of markers, bottom first (q to quit)
       [U,V,button] = ginput(2);
       if any(button==113)
           disp('image skipped')
       else
           referenceMarkerData = [referenceMarkerData; ...
               {image.PCDATE, image.PCTIME, image.HEADING, image.XCOORD, ...
               image.YCOORD,marker.XCOORD, marker.YCOORD, U(1), V(1), U(2), V(2)}]
       end
   end
   % save calibrationData every ten images.
   if nMarkers > 0 && mod(size(referenceMarkerData,1),10) == 0
      writetable(referenceMarkerData, ...
          fullfile(dataDir(),'M69','Calibration','referenceMarkerData.csv'))
      disp('Saved')
   end
end
end