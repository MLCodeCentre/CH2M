function simval = getImageSimilarity(image1, image2)

% resize 1 into 2
[image2rows, image2cols, image2chans] = size(image2);
image1_resized = imresize(image1,[image2rows, image2cols]);

simval = ssim(image1_resized,image2);
