function maxLocations = localise(sequenceLength,classificationError)

% find a random sequence in the list
assetListLoad = load('assetList');
assetList = assetListLoad.assetList;
nAssets = size(assetList,1);
targetSequenceEnd = randi([sequenceLength, nAssets]);

targetSequence = assetList(targetSequenceEnd-sequenceLength+1:targetSequenceEnd,[1,4])';
targetSequence = reshape(targetSequence,1,[]);

% randomly remove

% create all possible sequences of length length
sequences = createSequenceVectors(assetList,sequenceLength);

% calculate hamming distance between all vectors.
%hammingDist = pdist2(targetSequence,sequences,'hamming');
%maxLocations = sum(hammingDist == min(hammingDist));
%plot(hammingDist)
nSequences = size(sequences,1);
for iSequence = 1:nSequences
   editDist(iSequence) = edr(targetSequence,sequences(iSequence,:),0.1);  
end

%plot(editDist)
maxLocations = sum(editDist == min(editDist));