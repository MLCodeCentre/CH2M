function sequences = createSequenceVectors(assetList,length)
%CREATESEQUENCEVECTORS creates length long vectors of sequential assets.
%   Detailed explanation goes here
nAssets = size(assetList,1);
sequences = [];
for iAsset = length:nAssets
    sequence = assetList(iAsset-length+1:iAsset,[1,4])';
    sequence = reshape(sequence,1,[]);
    sequences = [sequences; sequence];
end
