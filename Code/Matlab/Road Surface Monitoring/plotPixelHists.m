function plotPixelHists(surface)

%surface_blur = imgaussfilt(surface,2);
surface = imadjust(double(surface),[0.2,0.5]);
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
pixels = double(surface(:));
pixels = pixels(pixels>0 & pixels < 126);
imshow(surface)
subplot(1,2,2)
histogram(pixels);
