function assets = findAssetsInImage(assets, image, min_x, max_x, max_y, year, camera_params)

num_assets = size(assets,1);
Pcs = [];
boxes = [];
pixels = [];

for asset_num = 1:num_assets
    asset = assets(asset_num,:);
    [asset_length, asset_width, asset_height, asset_z] = getAssetDimensions(asset);
    
    a = [asset.XCOORD, asset.YCOORD, asset_z]';
    c = [image.Northing, image.Easting, 0]';
    W = a-c;
    pan = image.Heading;
    Pc = toCameraCoords(W,pan,0,0);
    %Pc = toCameraCoords(W,pan,tilt,roll);
    [u,v,w,h,U,V] = getBoundingBox(Pc(2),Pc(1),Pc(3),year,...
                                   asset_length,asset_width,asset_height,camera_params);
    Pcs = [Pcs; Pc'];
    boxes = [boxes; u,v,w,h];
    [u,v] = getPixelsFromCoords(Pc(2),Pc(1),Pc(3),camera_params(year));
    pixels = [pixels; u,v];
end

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
good_pixels = pixels(:,1) < 2500 & pixels(:,1) > 50 & pixels(:,2) < 2000  & pixels(:,2) > 50;
Pcs = Pcs(good_pixels,:);
boxes = boxes(good_pixels,:);
pixels = pixels(good_pixels,:);

assets = [pixels, boxes];