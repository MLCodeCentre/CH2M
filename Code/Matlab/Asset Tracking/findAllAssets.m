function [assets_in_image1, asset_types_in_image1, assets_in_image2, asset_types_in_image2] = findAllAssets(image1,image2,asset_types,dataDir,road,camera_params)

assets_in_image1 = [];
assets_in_image2 = [];
asset_types_in_image1 = [];
asset_types_in_image2 = [];

asset_types = asset_types(~cellfun('isempty',asset_types));

for asset_type_ind = 1:numel(asset_types)
    asset_type = asset_types{asset_type_ind};
    asset_type_info = strsplit(asset_type,' ');
    asset_type = asset_type_info{1};
    
    asset_dbf_folder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');   
    asset_dbf_files = dir(fullfile(asset_dbf_folder,['*',asset_type,'*.dbf']));
    
    if isempty(asset_dbf_files) == 0
        asset_dbf_file = asset_dbf_files(1);
        [asset_data, field_names] = dbfRead(fullfile(asset_dbf_folder,asset_dbf_file.name));
        asset_data_table = cell2table(asset_data,'VariableNames',field_names);
        if any(strcmp('XCOORD',field_names))
            
            assets = findAssetsInImage(asset_data_table, image1, 7, 40, 30, 'Year1', camera_params);
            num_assets_image1 = size(assets,1);
            for asset_num = 1:num_assets_image1
                assets_in_image1 = [assets_in_image1; assets(asset_num,:)];
                asset_types_in_image1 = [asset_types_in_image1; asset_type];
            end
            
            assets = findAssetsInImage(asset_data_table, image2, 7, 40, 30, 'Year2', camera_params);
            num_assets_image2 = size(assets,1);
            for asset_num = 1:num_assets_image2
                assets_in_image2 = [assets_in_image2; assets(asset_num,:)];
                asset_types_in_image2 = [asset_types_in_image2; asset_type];
            end
        end
    end
    
end





