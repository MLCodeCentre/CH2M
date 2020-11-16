function findNavFileNoImage(navFile,road)
% this function loops through the nav file and finds rows that don't match
% up to an image. 
imageDir = fullfile(dataDir(),road,'Images');
nNav = size(navFile,1);
nNoImage = 0;
fixedNav = [];
for iNav = 1:nNav
    navImage = navFile(iNav,:);
    image = sprintf('2_%d_%d.jpg',navImage.PCDATE,navImage.PCTIME);
    if ~isfile(fullfile(imageDir,image))
        nNoImage = nNoImage + 1
        image
    else
        fixedNav = [fixedNav; navImage];
    end
end
writetable(fixedNav,fullfile(dataDir(),road,'Nav','Nav.csv'));


