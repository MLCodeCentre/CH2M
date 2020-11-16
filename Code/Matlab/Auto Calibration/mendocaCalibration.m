function mendocaCalibration

load('C:\Users\ts1454\Projects\Jacobs\Code\Matlab\Auto Calibration\Correspondences\A43FundamentalMatricesandNPoints.mat')
nMatrices = size(fundamentalMatrixNPoints,1);
total_points = sum(fundamentalMatrixNPoints(:,1,4));

for iMatrix = 1:nMatrices
    F = fundamentalMatrixNPoints(iMatrix,:,1:3)



end