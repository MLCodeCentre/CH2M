function [assetDimensions,assetZ] = getAssetDimensions(asset)
% getAssetDimensions Determines the true asset dimensions and height from the asset information if it is available.
%
%   INPUTS:
%       asset: Asset metadata [(1*nCols) TABLE].
%   OUTPUTS:
%       assetDimensions: Asset length, width and height [(1,3) ARRAY].
%       assetZ: Z position of asset [FLOAT].

% max height for asset heights. 
MAX_HEIGHT = 7;
fields  = asset.Properties.VariableNames;
% default dimensions.
assetWidth = 1;
assetHeight = 1;
assetLength = 0;
assetZ = 0;
% set height and width if they exist in the database
if any(strcmp('LENGTH',fields))
   assetLength = asset.LENGTH;
end
if any(strcmp('WIDTH',fields))
   assetWidth = max(0.5,asset.WIDTH);
end
if any(strcmp('HEIGHT',fields)) && isa(asset.HEIGHT,'double')
   assetHeight = asset.HEIGHT;
end
% adjust for suspiciously high heights and mounting heights
if any(strcmp('MOUNTING_H',fields))
   assetZ = asset.MOUNTING_H;
elseif assetHeight > MAX_HEIGHT
   assetZ = assetHeight;
   assetHeight = 1;
end
% over ride for gantry fixings. 
if any(strcmp('MOUNTING_M',fields)) && strcmp(asset.MOUNTING_M,'GANTRY')
    assetZ = asset.MOUNTING_H;
end

assetDimensions = [assetLength, assetWidth, assetHeight];