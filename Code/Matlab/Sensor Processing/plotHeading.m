function plotHeading(x,y,theta,col)
        plot(x,y,sprintf('%so',col))
        x2=x+(1*sin(deg2rad(theta)));
        y2=y+(1*cos(deg2rad(theta)));
        plot([x,x2],[y,y2],sprintf('%s--',col));
end