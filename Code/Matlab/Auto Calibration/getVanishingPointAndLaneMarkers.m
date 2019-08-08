function [vanishingPoint,laneMarkers] = getVanishingPointAndLaneMarkers(image)

close all 

% extracting region of interest
rgbImg = imread(image);
roiImg = getROI(rgbImg,500,1200);
imshow(roiImg)

% edge detection
subplot(1,2,1)
edgesImg = edgeDetection(roiImg);
imshow(edgesImg)

% line extraction by hough transform
[H,theta,rho] = hough(edgesImg);
peaks = houghpeaks(H,500,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(edgesImg,theta,rho,peaks,'FillGap',100,'MinLength',3);

% finding vanishing point from longest lines on each side
subplot(1,2,2)
plotLines(lines,rgbImg)
figure
[vanishingPoint,laneMarkers] = findLinesAndIntersection(lines,rgbImg);

%

end

function blurImg = edgeDetection(rgbImg)
    % using a simple thresholding on grey scale to find road marking
    grayImg = rgb2gray(rgbImg);
    %grayFilt = imbinarize(grayImg,0.85);
    grayFilt = grayImg > 230;
    maskedGrayImg = bsxfun(@times, grayImg, cast(grayFilt, 'like', grayImg));
    edgesImg = maskedGrayImg;
    blurImg = imgaussfilt(edgesImg,3);
    blurImg = edge(blurImg,'canny');
end

function roiImg = getROI(img,xbuff,ybuff)
    % find region of interest - the road surface. Creates a trapezium from
    % the bottom corners of the image to 2 pinched corners ybuff from the
    % top of the image and xbuff from the side.
    
    m = size(img,2); n = size(img,1);
    % corners of the trapezium
    tl = [0+xbuff,0+ybuff]; tr = [m-xbuff,0+ybuff];
    bl = [0,n]; br = [m,n];
    
    % creating mask and applying
    x = [tl(1), tr(1), br(1), bl(1)];
    y = [tl(2), tr(2), br(2), bl(2)];   
    mask = poly2mask(x,y,n,m);
    roiImg = bsxfun(@times, img, cast(mask, 'like', img));
    
end

function plotLines(lines,img)
    imshow(img), hold on
    max_len = 0;
    
    for k = 1:length(lines)
       angle = lines(k).theta
       if abs(angle) < 60
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
       end
    end
    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
end