function [closest_asset, u_asset, v_asset, box] = findClosestAsset(assets,image,u,v,params,year)

camera_params = params(year);
num_assets = size(assets,1);

fields  = assets.Properties.VariableNames;
for asset_num = 1:num_assets
    asset = assets(asset_num,:);
    A = [asset.XCOORD, asset.YCOORD,0]';
    C = [image.Northing, image.Easting,0]';
    Pw = A-C;
    pan = image.Heading;
    Pc = toCameraCoords(Pw,pan,0,0);

    y(asset_num,1) = Pc(1);
    x(asset_num,1) = Pc(2);
    % now calculate pixels this asset would be in in the image. 
    if any(strcmp('MOUNTING_H',fields))
        z(asset_num,1) = asset.MOUNTING_H;
    else
        z(asset_num,1) = 0;
    end
    [u_asset(asset_num,1),v_asset(asset_num,1)] = ...
    getPixelsFromCoords(x(asset_num,1), y(asset_num,1), z(asset_num,1), params(year));
    pixel_distance(asset_num,1) = sqrt((u-u_asset(asset_num,1)).^2 + (v-v_asset(asset_num,1)).^2);
end

asset_table =[assets,table(x,y,z,u_asset,v_asset,pixel_distance)];
% filter out negative xs and big ys
asset_table = asset_table(asset_table.x > 0 & asset_table.x < 100, :);
asset_table = asset_table(abs(asset_table.y) < 50, :);
% filter out large pixel distances
asset_table = asset_table(asset_table.pixel_distance < 500, :);

closest_asset = asset_table(asset_table.pixel_distance == min(asset_table.pixel_distance(:)),:);
% pixels
u_asset = closest_asset.u_asset;
v_asset = closest_asset.v_asset;

if isempty(closest_asset)
    box = [];
else
    [asset_length, asset_width, asset_height, asset_z] = getAssetDimensions(closest_asset);  
    %asset_pos = [closest_asset.x, closest_asset.y, closest_asset.z];
    %asset_dims = [asset_length,asset_width,asset_height];
    
    [box_x,box_y,box_w,box_h,~,~] = getBoundingBox(closest_asset.x, closest_asset.y, asset_z,...
                                                   year, asset_length, asset_width, asset_height, params);
    box = [box_x,box_y,box_w,box_h];
end