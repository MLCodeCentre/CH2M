function [localised, localisationTime] = particleFilter(nItters,classificationError)
close all
    
assetListLoad = load('assetList');
assetList = assetListLoad.assetList;
nAssets = size(assetList,1);

%% Particle Filter
% calculate largest set of sequences instantiate weights as equal
sequences = createSequenceVectors(assetList,1);
weights = ones(nAssets,1)/nAssets;

targetInd = randi([1, 300]);

nTruePosts = 0;
nSeenPosts = 0;
observations = [];

showplot = false;
showOutput = false;
% if showplot
%     pos = [-0.875,0,0.875,0.901851851851852];
%     figure('units','normalized','outerposition',[0 0 1 1])
%     set(gcf,'position',pos)
% end
localised = 0;
itter = 1;
nPosts = 1;
while itter <= nItters
    % see a new observation and create all sequence vectors
    % true index as move down the road
    % if a sign post is not seen, delete that observations
    nTruePosts = nTruePosts + 1;
    if showOutput
        fprintf('---------Iteration %d---------\n',itter)
    end
    
    if rand > classificationError
        nSeenPosts = nSeenPosts + 1;
        % shift weights along if second observation
        if nSeenPosts > 1
            for iAsset = 2:nAssets
                weightsShifted(iAsset) = weights(iAsset-1);
            end
            weightsShifted(1) = 0;
            weights = weightsShifted;
        end
        
        % the indices at which a sign post was seen, this to create the
        % correct observation
        observation = assetList(targetInd,[1,4]);
        observations = [observations, observation];
        % create sequences of correct length
        sequences = createSequenceVectors(assetList,nSeenPosts);

        % calculate edit distance between all sequence and observation
        nSequences = size(sequences,1);
        %distance = pdist2(observations,sequences,'hamming');
        for iSequence = 1:nSequences
                %distance(iSequence+nSeenPosts-1,1) = edr(observations,sequences(iSequence,:),0.05);
                distance(iSequence+nSeenPosts-1,1) = pdist2(observations,sequences(iSequence,:),'hamming');
        end      
        if nSeenPosts > 1
            distance(1:nSeenPosts-1) = 100;
        end
        
        % update weights
        pOgivenD = normpdf(distance,0,0.1);
        weightsTilde = weights.*pOgivenD;
        weights = weightsTilde/sum(weightsTilde);
        expectation = round(sum(weights.*(1:nAssets)'));
        maxInds = find(weights==max(weights));
        
        % plot
        if showplot
            subplot(ceil(nItters/2),2,itter)
            plot(1:nAssets,weights,'.')
            %xlabel('Signpost')
            %ylabel('Weight')
            title(sprintf('%d Observations, %d missed',nSeenPosts,nPosts-nSeenPosts));
            hold on
            vline(targetInd,'r--',sprintf('%d',targetInd))
            nMaxInds = length(maxInds)
%             for iMaxInd = 1:nMaxInds
%                 vline(maxInds(iMaxInd),'r--',sprintf('%d',maxInds(iMaxInd)))
%             end
            hold off
        end       
        % displaying results
        if showOutput
            fprintf('Signpost found\n')     
        end
        itter = itter + 1;
    else
        if showOutput
            fprintf('Signpost missed\n')
        end
    end
    
    if showOutput
        fprintf('Calculated location: %g\n',maxInds)
        fprintf('True location: %d\n',targetInd)
    end
    maxInds = find(weights==max(weights));
    if length(maxInds) == 1
        if targetInd == maxInds
            localisationTime = itter;
            localised = 1;
            break
        end
    end
    targetInd = targetInd + 1;
    nPosts = nPosts + 1;
end
localisationTime = itter;
if showplot == true
    suplabel('Signpost')
    suplabel('Weight','y')
end
end



