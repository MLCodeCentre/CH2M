function [image, box, target_pixels] = getAssetImage(asset,year,road,nav_file,dataDir,camera_params)

[asset_length, asset_width, asset_height, asset_z] = getAssetDimensions(asset);
asset_dims = [asset_width,asset_length,asset_height];

min_x = 7;
max_y = 20;
max_x = 50;
% getting image
[image, box,target_pixels] = getClosestImage(nav_file, asset.XCOORD, asset.YCOORD, asset_z,...
                                                    road, year, 2, min_x, max_x, max_y, ...
                                                    asset_length, asset_width, asset_height, camera_params);


                    