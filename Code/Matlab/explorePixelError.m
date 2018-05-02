function explorePixelError

lambda_range = 0.001:0.001:0.05;
scale_range = 0:0.0001:0.01;

errors = zeros(length(lambda_range),1);
size(errors)
i = 1;
for lambda = lambda_range
    errors(i) = cameraDisplacements(i,0.001);
    i = i + 1;
end

plot(lambda_range,errors)
colorbar()
xlabel('lambda')
ylabel('error')

% figure();
% errors = zeros(length(scale_range),1);
% size(errors)
% i = 1;
% for scale = scale_range
%     errors(i) = cameraDisplacements(0.02,scale);
%     i = i + 1;
% end
% 
% plot(scale_range,errors)
% colorbar()
% xlabel('scale')
% ylabel('error')

