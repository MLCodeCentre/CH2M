function localised = localise(sequenceLength,classificationError)

    % find a random sequence in the list
    assetListLoad = load('assetList');
    assetList = assetListLoad.assetList;
    nAssets = size(assetList,1);
    targetSequenceEnd = randi([sequenceLength, nAssets]);
    while targetSequenceEnd < sequenceLength
        targetSequenceEnd = randi([sequenceLength, nAssets]);
    end
    targetSequence = assetList(targetSequenceEnd-sequenceLength+1:targetSequenceEnd,[4])';
    targetSequence = reshape(targetSequence,1,[]);

    %% firstly get ground truth with zero classification error.
    %delete from true sequence and calculate new sequences
    nDelete = ceil(sequenceLength*classificationError);
    iDelete = randperm(sequenceLength,nDelete);
    while any(iDelete == sequenceLength)
       iDelete = randperm(sequenceLength,nDelete);
    end

    %targetSequenceError = reshape(targetSequence,2,[]);
    targetSequenceError = targetSequence();
    if nDelete > 0
        targetSequenceError(iDelete) = [];
        %targetSequenceError = reshape(targetSequenceError,1,[]);
    end

    sequencesError = createSequenceVectors(assetList,sequenceLength-nDelete);
    targetSequenceErrorInd = targetSequenceEnd-(sequenceLength-nDelete)+1;
    % calculate hamming distance between all vectors.
    nSequences = size(sequencesError,1);
    for iSequence = 1:nSequences
       dist(iSequence) = distanceMetric(targetSequenceError,sequencesError(iSequence,:));
    end
    %plot(editDist)
    minSeqInd = find(dist==min(dist));

    if length(minSeqInd) > 1
        localised = 0;
    elseif minSeqInd == targetSequenceErrorInd
        localised = 1;
    else
        localised = 0;
    end

end

function distance = distanceMetric(sequenceA,sequenceB)
   %distance = edr(sequenceA,sequenceB,0.05);
   distance = pdist2(sequenceA,sequenceB,'hamming');
end


