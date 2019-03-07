function [asset_length, asset_width, asset_height, asset_z] = getAssetDimensions(asset)

fields  = asset.Properties.VariableNames;
if any(strcmp('MOUNTING_H',fields))
    asset_z = asset.MOUNTING_H;
else
    asset_z = 0;
end

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
   if asset.HEIGHT > 7
       asset_z = asset.HEIGHT;
   else
       asset_height = asset.HEIGHT;
   end
end

asset_width = max(0.5,asset_width);
asset_dims = [asset_width,asset_length,asset_height];