function exploreError(coords,thetaSolve,systemParams)
    
    nPoints = 500;

    % roll angle
    alphaStar = thetaSolve(1);
    alphaChanges = linspace(-0.5,0.5,nPoints);
    alphaThetaSolve = thetaSolve;

    % tilt angle
    betaStar = thetaSolve(2);
    betaChanges = linspace(-0.5,0.5,nPoints);
    betaThetaSolve = thetaSolve;
    
    % pan angle
    gammaStar = thetaSolve(3);
    gammaChanges = linspace(-0.5,0.5,nPoints);
    gammaThetaSolve = thetaSolve;

    % x0 
    x0Star = thetaSolve(4);
    x0Changes = linspace(-1,1,nPoints);
    x0ThetaSolve = thetaSolve;

    % y0 
    y0Star = thetaSolve(5);
    y0Changes = linspace(-2,2,nPoints);
    y0ThetaSolve = thetaSolve;

    % height
    hStar = thetaSolve(6);
    hChanges = linspace(-1,1,nPoints);
    hThetaSolve = thetaSolve;

    % focal length
    fStar = thetaSolve(7);
    fChanges = linspace(-200,200,nPoints);
    fThetaSolve = thetaSolve;

    for iPoint = 1:nPoints

        % roll angle
        alphaThetaSolve(1) = alphaStar + alphaChanges(iPoint);
        alphaFval(iPoint) = cameraEquationFunction(alphaThetaSolve,coords,systemParams);
        
        % tilt angle
        betaThetaSolve(2) = betaStar + betaChanges(iPoint);
        betaFval(iPoint) = cameraEquationFunction(betaThetaSolve,coords,systemParams);
        
        % pan angle
        gammaThetaSolve(3) = gammaStar + gammaChanges(iPoint);
        gammaFval(iPoint) = cameraEquationFunction(gammaThetaSolve,coords,systemParams);
        
        % x0
        x0ThetaSolve(4) = x0Star + x0Changes(iPoint);
        x0Fval(iPoint) = cameraEquationFunction(x0ThetaSolve,coords,systemParams);

        % y0
        y0ThetaSolve(5) = y0Star + y0Changes(iPoint);
        y0Fval(iPoint) = cameraEquationFunction(y0ThetaSolve,coords,systemParams);
    
        % height
        hThetaSolve(6) = hStar + hChanges(iPoint);
        hFval(iPoint) = cameraEquationFunction(hThetaSolve,coords,systemParams);

        % focal length
        fThetaSolve(7) = fStar + fChanges(iPoint);
        fFval(iPoint) = cameraEquationFunction(fThetaSolve,coords,systemParams);

    end
        
    figure; hold on;
    plot(betaFval);
    plot(gammaFval);
    ylabel('fval');
    xlabel('Parameter change')
    yval = get(gca,'ylim');
    plot([nPoints/2,nPoints/2], yval, 'k--');
    set(gca,'xtick',[])
    legend({'\beta','\gamma','\theta^*'})

    figure; hold on;
    plot(alphaFval);
    plot(x0Fval);
    plot(y0Fval);
    plot(hFval);
    plot(fFval);
    ylabel('fval');
    xlabel('Parameter change')
    yval = get(gca,'ylim');
    plot([nPoints/2,nPoints/2], yval, 'k--');
    set(gca,'xtick',[])
    legend({'\alpha','x_0','y_0','h','f','\theta^*'})
end