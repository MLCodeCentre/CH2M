nPosts = 1:6;
errors = 0:0.1:0.3;
nRuns = 400;

localisedTotal = [];
errorInd = 1;
for error = errors

    localised = zeros(nRuns,length(nPosts));
    localisationItters = zeros(nRuns,length(nPosts));
    i = 1;
    for nPost = nPosts
        j = 1;
        for iRun = 1:nRuns
            try
                [runLocalised,runLocalisationItters] = particleFilter(nPost,error);
            catch exception
                disp('errored')
            end
            localised(j,i) = runLocalised;
            localisationItters(j,i) = runLocalisationItters;
            j = j + 1;
        end
        i = i + 1;
    end

localisedTotal = [localisedTotal; mean(localised)];
errorInd = errorInd + 1
end

figure
bar(nPosts,localisedTotal')
legendCell = cellstr(num2str(errors', '%1.1f'));
leg = legend(legendCell,'Location','northwest');
leg.Title.String = 'Detection Error';
xlabel('n')
ylabel('Localisation accuracy')

% figure
% boxplot(localisationItters)
% set(gca,'XTickLabel',errors)
% xlabel('Detection error')
% ylabel('Number of signposts till localisation')