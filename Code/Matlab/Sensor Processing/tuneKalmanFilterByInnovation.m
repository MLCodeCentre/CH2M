function tuneKalmanFilterByInnovation(navFile)

sigmaAccs = linspace(2,10,40);
sigmaGPSs = linspace(7,10,40);

navFile = navFile(1:1000,:); 

navFileSections = splitNavFile(navFile,false);
nSections = size(navFileSections,2);

sigmaInd = 1;
for sigmaAcc = sigmaAccs
    gpsInd = 1;
    for sigmaGPS = sigmaGPSs
        innovationSequences = [];
        for iSection = 1:nSections
            navFileSection = navFileSections{iSection};
            %[~,~,~,~,innovationSequence] = kalmanFilterConstantVel(navFileSection,sigmaAcc,sigmaGPS,false); % kalman filter
            [~,~,~,~,innovationSequence] = kalmanFilterPosition(navFileSection,sigmaAcc,sigmaGPS);
            innovationSequences = [innovationSequences,innovationSequence];
            N = size(innovationSequence,2);
            for k = 1:N-1
                i = k+1:min(k+100,N);
                C = (1/N)*innovationSequence(:,i)*innovationSequence(:,i-k)';
                Cii(k) = C(1,1);
                
                if k == 1
                   C0 = C; 
                end
            end
        end
         
        CiiVarThresh = (0.96/sqrt(N))*C0(1,1);
        metric = sum(abs(Cii)> CiiVarThresh)/N;
%        innovcov = cov(innovationSequences); 
%        innovmu = abs(mean(mean(innovationSequences)));  
%        pMgD = mvnpdf(innovationSequences,innovmu,innovcov);
%        logL = sum(log(pMgD));        
%        innovH = innovationSequences(:,3);
%        corrX = parcorr(innovX);
%        corrY = parcorr(innovY);
        %corrH = parcorr(innovH);
        %nCorrelation = sum(abs(corrX)>0.05) + sum(abs(corrY)>0.05);% + sum(abs(corrH)>0.05);
        fprintf('sigma_acc: %2.2f, sigma_gps: %2.2f, metric: %2.5f\n',sigmaAcc,sigmaGPS,metric)
        metrics(sigmaInd,gpsInd) = metric;
        gpsInd = gpsInd + 1;
    end
    sigmaInd = sigmaInd + 1;
end
cla
imagesc(sigmaGPSs,sigmaAccs,metrics)
ylabel('\sigma_{ACC} [m]');
xlabel('\sigma_{GPS} [m]');
set(gca,'YDir','normal')
c = colorbar;
c.Label.String = 'Percentage of correlated lags';

[i,j] = find(metrics==min(metrics(:)));
sigmaAccMax = sigmaAccs(i)
sigmaGPSMax = sigmaGPSs(j)