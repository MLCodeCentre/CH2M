function [assets, Pcs] = findAssetsInImage(assets, image, min_x, max_x, max_y, year, camera_params)

% initial filter to get only assets nearby
asset_location = [assets.XCOORD, assets.YCOORD, zeros(size(assets.YCOORD))];
image_location = [image.Northing, image.Easting, 0];

asset_relative_location = bsxfun(@minus, asset_location, image_location);
asset_distance = sqrt((asset_relative_location(:,1).^2 + asset_relative_location(:,2).^2));

nearby_assets = assets(asset_distance<100,:);

num_assets = size(nearby_assets,1);
Pcs = [];
boxes = [];
pixels = [];

for asset_num = 1:num_assets
    asset = nearby_assets(asset_num,:);
    [asset_length, asset_width, asset_height, asset_z] = getAssetDimensions(asset);
    
    a = [asset.XCOORD, asset.YCOORD, asset_z]';
    c = [image.Northing, image.Easting, 0]';
    W = a-c;
    pan = image.Heading;
    tilt = image.Tilt;
    roll = image.Roll;
    %Pc = toCameraCoords(W,pan,tilt,roll);
    Pc = toCameraCoords(W,pan,0,0);
    [u,v,w,h,U,V] = getBoundingBox(Pc(2),Pc(1),Pc(3),year,...
                                   asset_length,asset_width,asset_height,camera_params);
    Pcs = [Pcs; Pc'];
    boxes = [boxes; u,v,w,h];
    [u,v] = getPixelsFromCoords(Pc(2),Pc(1),Pc(3),camera_params(year));
    pixels = [pixels; u,v];
end

if size(Pcs,1) > 0
    % getting Photos with positive x;
    Pcs_positive_x = Pcs(:,2) > min_x;
    Pcs = Pcs(Pcs_positive_x,:);
    boxes = boxes(Pcs_positive_x,:);
    pixels = pixels(Pcs_positive_x,:);

    % getting Photos with positive x;
    Pcs_small_enough_x = Pcs(:,2) < max_x;
    Pcs = Pcs(Pcs_small_enough_x,:);
    boxes = boxes(Pcs_small_enough_x,:);
    pixels = pixels(Pcs_small_enough_x,:);

    % getting Photos with small enough y;
    Pcs_less_than_max_y = abs(Pcs(:,1)) < max_y;
    Pcs = Pcs(Pcs_less_than_max_y,:);
    boxes = boxes(Pcs_less_than_max_y,:);
    pixels = pixels(Pcs_less_than_max_y,:);

    % are pixels in picture
    good_pixels = pixels(:,1) < 2560 & pixels(:,1) > 50 & pixels(:,2) < 2000  & pixels(:,2) > 50;
    Pcs = Pcs(good_pixels,:);
    boxes = boxes(good_pixels,:);
    pixels = pixels(good_pixels,:);
end
assets = [pixels, boxes];