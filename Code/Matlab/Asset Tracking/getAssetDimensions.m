function [asset_length, asset_width, asset_height, asset_z] = getAssetDimensions(asset)

fields  = asset.Properties.VariableNames;

asset_width = 1;
asset_height = 1;
asset_length = 0;
% set height and width
if any(strcmp('LENGTH',fields))
   asset_length = asset.LENGTH;
end
if any(strcmp('WIDTH',fields))
   asset_width = asset.WIDTH;
end
if any(strcmp('HEIGHT',fields)) && isa(asset.HEIGHT,'double')
   asset_height = asset.HEIGHT;
end

if any(strcmp('MOUNTING_H',fields))
   asset_z = asset.MOUNTING_H;
elseif asset_height > 7
   asset_z = asset_height;
   asset_height = 1;
else
   asset_z = 0;
end

if any(strcmp('MOUNTING_M',fields)) && strcmp(asset.MOUNTING_M,'GANTRY')
    asset_z = asset.MOUNTING_H;
end

asset_width = max(0.5,asset_width);
asset_dims = [asset_width,asset_length,asset_height];