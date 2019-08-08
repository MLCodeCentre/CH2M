function assets = loadAssets(road,assetType)
    % loads assets of type assetType
    assetDBF = sprintf('%s.dbf',assetType);
    [assetData,fieldNames] = dbfRead(fullfile(dataDir(),road,'Inventory',assetDBF));
    assets = cell2table(assetData,'VariableNames',fieldNames);
end