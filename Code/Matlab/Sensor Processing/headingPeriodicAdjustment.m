function headingPeriodicAdjustment(heading,headingIMU)
% Adjust heading to line up with heading IMU when it goes through 360.
heading;
if heading > headingIMU && headingIMU
    heading = heading - 360;
elseif headingIMU > heading && heading < 0
    heading = heading + 360;
elseif headingIMU > heading && heading > 0
    heading = heading + 360;
else
    a = 1;
end

end