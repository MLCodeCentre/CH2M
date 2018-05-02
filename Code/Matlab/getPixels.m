function [u,v] = getPixels(x_img,y_img,cx,cy,sx,sy)   
    u = x_img/sx + cx;
    v = y_img/sy + cy;
end