function gaussianSmoothing(navFile)
    x = navFile.XCOORD;
    t = navFile.GPSTIMES;
    nX = size(x,1);
    sigma = 10;
    for iX = 1:nX
        xSmooth(iX) = sum(Kernel(t(iX),t,sigma).*x(iX))/sum(Kernel(t(iX),t,sigma));
    end
    
    plot(xSmooth); hold on; plot(x)
end
function w = Kernel(t,tj,sigma)
    w = exp(-((t-tj).^2)/2*sigma^2);
end