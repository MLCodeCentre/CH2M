function [assets_in_image1, assets_in_image2] = findAllAssetsOfType(image1,image2,asset_data_table,camera_params)

assets_in_image1 = [];
assets_in_image2 = [];

assets = findAssetsInImage(asset_data_table, image1, 7, 50, 50, 'Year1', camera_params);
num_assets_image1 = size(assets,1);
for asset_num = 1:num_assets_image1
    assets_in_image1 = [assets_in_image1; assets(asset_num,:)];
end

assets = findAssetsInImage(asset_data_table, image2, 7, 50, 50, 'Year2', camera_params);
num_assets_image2 = size(assets,1);
for asset_num = 1:num_assets_image2
    assets_in_image2 = [assets_in_image2; assets(asset_num,:)];
end
