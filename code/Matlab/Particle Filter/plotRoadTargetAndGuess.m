function plotRoadTargetAndGuess(image_file, u_target, v_target, u_guess, v_guess)

figure;

I = imread(image_file);
imshow(I);
hold on

plot(u_target, v_target, 'r*')
plot(u_guess, v_guess, 'b*')

end

