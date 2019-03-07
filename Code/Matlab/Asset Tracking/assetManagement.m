function assetManagement
close all;
% this script will collate several crops of a target from different dbf
% files containing asset
years = {'Year1','Year2'};
num_years = length(years);
road = 'A27';

nav_file_year1 = readtable(fullfile(dataDir(),road,'Year1','Nav','Nav.csv'));
nav_file_year2 = readtable(fullfile(dataDir(),road,'Year2','Nav','Nav.csv'));

min_x = 20;
max_y = 10;

asset_dbf_folder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');
asset_dbf_files = dir(fullfile(asset_dbf_folder,'*.dbf'));
num_dbf_files = size(asset_dbf_files,1);

for dbf_file_num = 1:num_dbf_files
    % loading database file and extracting the asset
    asset_dbf_file =  asset_dbf_files(dbf_file_num).name;
    asset_dbf_file_split = split(asset_dbf_file,'_');
    asset_type = asset_dbf_file_split{2};
    folder = fullfile(dataDir,road,'Assets',asset_type);
    status = mkdir(folder);
    
    if any(strcmp(asset_type,{'SNSF'}))==1
        [asset_data, field_names] = dbfRead(fullfile(asset_dbf_folder,asset_dbf_file));
        % if dbf files contain eastings and northings (some don't)
        if any(strcmp(field_names,'XCOORD'))
            asset_table = array2table(asset_data,'VariableNames',field_names);
            num_assets = size(asset_table,1);
        
            % iterating through each asset in the dbf file
            for asset_num = 1:num_assets
                
                %figure
                %set(gcf,'Visible','off');
                asset = asset_table(asset_num,:);
                % get photo 10m away from assets.
                % for each year
                for year_num = 1:num_years
                    if strcmp(asset_type,'CCTV')
                        asset_width = 1;
                        asset_length = 1;
                        asset_height = asset.HEIGHT{1} + 1;
                    elseif strcmp(asset_type,'DRGU')
                        asset_width = 0.5;
                        asset_length = 0.5;
                        asset_height = 0;
                    elseif strcmp(asset_type,'DRMH')
                        asset_width = 0.5;
                        asset_length = 0.5;
                        asset_height = 0;
                    elseif strcmp(asset_type,'EBIT')
                        asset_width = 0.5;
                        asset_length = 0.5;
                        asset_height = 0;
                    elseif strcmp(asset_type,'SNSF')
                        asset_width = asset.WIDTH{1};
                        asset_length = 0;
                        asset_height = asset.MOUNTING_H{1} + asset.HEIGHT{1} + 1;
                    elseif strcmp(asset_type,'SNPS')
                        asset_width = 1;
                        asset_length = 0;
                        asset_height = asset.HEIGHT{1} + 1;
                    end
                    
                    year = years{year_num};
                    if strcmp(year,'Year1')
                        nav_file = nav_file_year1;
                    elseif strcmp(year,'Year2')
                        nav_file = nav_file_year2;
                    end
                    
                    [image, box, U, V] = getClosestImage(nav_file, asset.XCOORD{1}, asset.YCOORD{1}, road, year, 2, min_x, max_y, asset_length, asset_width, asset_height);
                    if isempty(image) == 1
                        disp('Error no image')
                        break;
                    end
                    u = box(1); v = box(2); w = box(3); h = box(4);
                    % finding asset width and height if it exists
                    
                    %[x,y,w,h] = getBoundingBox(image,1,asset_width,asset_height);
                    if strcmp(year,'Year1')
                        I_year1 = imread(fullfile(dataDir,road,year,'Images',image.File_Name{1}));
                        crop_year1 = imcrop(I_year1,box);
                        box1 = box; U1 = U; V1 = V;
                        
                    elseif strcmp(year,'Year2')
                        I_year2 = imread(fullfile(dataDir,road,year,'Images',image.File_Name{1}));
                        crop_year2 = imcrop(I_year2,box);
                        box2 = box; U2 = U; V2 = V;
                    end
                end
                %
%                 if isempty(image) == 0
%                     %similarity = getImageSimilarity(crop_year1,crop_year2)
%                     similarity = 0.1;
%                     if similarity < 1
%                         figure('units','normalized','outerposition',[0 0 1 1])
%                         set(gcf,'Visible','off');
%                         
%                         subplot(1,num_years,1);
%                         imshow(I_year1);
%                         hold on
%                         %scatter(U1(:),V1(:),'bo')
%                         rectangle('Position',box1,'LineWidth',2,'LineStyle','--','EdgeColor','r');
%                         subplot(1,num_years,2);
%                         imshow(I_year2)
%                         hold on
%                         %scatter(U2(:),V2(:),'bo')
%                         rectangle('Position',box2,'LineWidth',2,'LineStyle','--','EdgeColor','r');
%                                                 
%                         file_name = strcat([num2str(asset_num)]);
%                         print(fullfile(folder,file_name),'-dpng')
%                         %saveas(gcf,fullfile(folder,file_name))
%                         close;
%                     end
                end 
            end % assets in asset_type
        end % if XCOORD in asset
    end % asset_type
end % db_files

end


