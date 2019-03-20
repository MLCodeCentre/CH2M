function merged_boxes = mergeBoxes(boxes,threshold)

% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(boxes, boxes);
% Set the overlap ratio between a bounding box and itself to zero to
% simplify the graph representation.
n = size(overlapRatio,1); 
overlapRatio(1:n+1:n^2) = 0;
% only consider overlaps that are above threshold
overlapRatio(overlapRatio<threshold) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);

xmins = boxes(:,1); ymins = boxes(:,2); 
xmaxs = boxes(:,1) + boxes(:,3); ymaxs = boxes(:,2) + boxes(:,4);

xmins = accumarray(componentIndices', xmins, [], @min);
ymins = accumarray(componentIndices', ymins, [], @min);
xmaxs = accumarray(componentIndices', xmaxs, [], @max);
ymaxs = accumarray(componentIndices', ymaxs, [], @max);

merged_boxes = [xmins, ymins, xmaxs-xmins, ymaxs-ymins];