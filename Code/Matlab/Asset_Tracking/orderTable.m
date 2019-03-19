function orderedTable = orderTable(assetTable)
%orderedTable Reorders asset table so that assets are roughly ordered by location. 
%
% assets are ordered by distance from an anchor which is at the start of the A27.
% In future releases this anchor will need to configurable for user with 
% other roads.
%
%   INPUTS:
%       assetTable: Assets to be ordered [(nAssets,nCols) TABLE]
%   OUTPUTS:
%       orderedTable: Ordered Asets [(nAssets,nCols) TABLE]

% euclidian distance of each asset from anchor
anchor = [472995.326, 106020.104];
distanceFromAnchor = ...
    sqrt((assetTable.XCOORD - anchor(1)).^2 + (assetTable.YCOORD - anchor(2)).^2);
% order by distance from anchor
assetTable = [assetTable, table(distanceFromAnchor)];
orderedTable = sortrows(assetTable,'distanceFromAnchor');
% delete the distances
orderedTable.distanceFromAnchor = [];
