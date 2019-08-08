function [camera,PCDATE,PCTIME] = parseImageFileName(fileName)
% parses camera, pcdata and pctime from image file name.
    fileNameAndExt = strsplit(fileName,'.');
    fileName = fileNameAndExt{1};
    fileInfo = strsplit(fileName,'_');
    camera = str2num(fileInfo{1});
    PCDATE = str2num(fileInfo{2});
    PCTIME = str2num(fileInfo{3});
end