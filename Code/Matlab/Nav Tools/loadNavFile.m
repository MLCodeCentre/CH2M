function navFile = loadNavFile(road)
%LOADNAVFILE loads nav file for survey and corrects the headings.
    % loads navFile.
    navDBF = sprintf('%s.dbf',road);
    [navData,fieldNames] = dbfRead(fullfile(dataDir,road,'Nav',navDBF));
    navFile = cell2table(navData,'VariableNames',fieldNames);
    navFile.PCDATE = str2double(navFile.PCDATE);
    navFile.PCTIME = str2double(navFile.PCTIME);
    %correctHeadings
    %disp('correcting headings')
    %navFile = fixHeadingsCentralDiff(navFile);
end