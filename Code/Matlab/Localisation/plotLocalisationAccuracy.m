close all

Lengths = 1:5;
itters = 200;

localised = zeros(itters,length(Lengths));

for Length = Lengths
    Length
   for i = 1:itters
       localised(i,Length) = localise(Length,0);
   end
end
    
bar(Lengths,mean(localised))
ylabel('Localisation Accuracy')
xlabel('n')
%xlim([0.5,5.5])