function displayHists(particles,weights)

figure

subplot(3,2,1)
alphas = particles(:,1);
scatter(alphas,weights,'.')
xlabel('\alpha')
xlim([-pi/2,pi/2])

subplot(3,2,2)
betas = particles(:,2);
scatter(betas,weights,'.');
xlabel('\beta')
xlim([-pi/2,pi/2])

subplot(3,2,3)
gammas = particles(:,3);
scatter(gammas,weights,'.');
xlabel('\gamma')
xlim([-pi/2,pi/2])

subplot(3,2,4)
L1s = particles(:,4);
scatter(L1s,weights,'.');
xlabel('L1')
xlim([0,2])

subplot(3,2,5)
L2s = particles(:,5);
scatter(L2s,weights,'.');
xlabel('L2')
xlim([0,2])

subplot(3,2,6)
hs = particles(:,6);
scatter(hs,weights,'.');
xlabel('h')
xlim([0,3])