function fixGPSPolynomial(navFile)

THRESH = 300;
WINDOW_SIZE = 1;

% consider each PCDATE - first one first
PCDATES = unique(navFile.PCDATE);
nPCDATES = numel(PCDATES);
navFilePCDATE = navFile(navFile.PCDATE == PCDATES(2),:);
% set old headings as something else
navFilePCDATE.HEADINGOLD = navFilePCDATE.HEADING;

%X = navFilePCDATE.XCOORD;
%Y = navFilePCDATE.YCOORD;
headings = navFilePCDATE.HEADING;
plot(headings); title('HEADING'); hold on;
sections = generateSections(headings,THRESH);
nSections = size(sections,2);

% smooth each section and show.
%movRMS = dsp.MovingRMS('Method','Exponential weighting','Fo');
headingsSmoothed = [];
for iSection = 1:nSections
    % plot old and smoothed headings for the section
    headingSection = sections{iSection};
    headingSectionSmoothed = moveRMS(headingSection,WINDOW_SIZE);
    % fprintf('%d - %d\n',numel(headingSection),numel(headingSectionSmoothed))
    % create new full set of readings
    headingsSmoothed = [headingsSmoothed,headingSectionSmoothed'];
end

plot(headingSectionSmoothed); hold off;
navFilePCDATE.HEADING = headingsSmoothed';

plotHeadings(navFilePCDATE)


end

function sections = generateSections(headings,THRESH)
% identifies sections of consistent heading readings (once the vehicle turns
% though 360 it resets to zero) so RMS can be performed.
% find large differences 
headingChanges = diff(headings);
plot(headingChanges); title('Heading Changes')
changeIdx = find(abs(headingChanges) > THRESH);
nChanges = numel(changeIdx);
% collect section between large changes
if nChanges > 0
    sections = {}; % (nLargeChanges-1,LengthSection)
    % first section
    sections{1} = headings(1:changeIdx(1)-1);
    % loop through other sections
    for iChange = 1:nChanges-1
        sections{iChange+1} = headings(changeIdx(iChange):changeIdx(iChange+1)-1);
    end
    sections{end+1} = headings(changeIdx(end):end);
else
    sections = {headings};
end
end