close all

classificationErrors = 0:0.1:0.4;

Length = 3;
itters = 200;

localisationAccuracy = zeros(itters,length(classificationErrors));

errorCounter = 1;
for iError = classificationErrors
   for iItter = 1:itters
       localised = localise(Length,iError);
       localisationAccuracy(iItter,errorCounter) = localised;
   end
   errorCounter = errorCounter + 1
end

mean(localisationAccuracy)
bar(classificationErrors,mean(localisationAccuracy))
xlabel('Detection Error')
ylabel('Localisation Accuracy')
title('n=3')