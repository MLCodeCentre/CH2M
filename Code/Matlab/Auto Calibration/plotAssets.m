function plotAssets(assetsImage,AssetType,plotBox)
% plots all assets, to hide the bounding box set plotBox to False, otherwise True.  
nAssets = size(assetsImage,1);
hold on
for iAsset = 1:nAssets
    % parse the columns of assetsImage
    uAsset = assetsImage(iAsset,1);
    vAsset = assetsImage(iAsset,2);
    box = assetsImage(iAsset,3:6);
    % plot bounding box if requested
    if plotBox
         rectangle('Position',box,'LineWidth',1,'LineStyle','-',...
               'EdgeColor','r','Curvature',0);
    end
    % plot pixels
    plot(uAsset,vAsset,'g+')
    text(uAsset,vAsset,AssetType,'color','m')
end
hold off