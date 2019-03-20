
Lengths = 1:8;
itters = 50;

nLocations = zeros(itters,length(Lengths));

for Length = Lengths
   for i = 1:itters
       nLocations(i,Length) = localise(Length);
   end
end
    
boxplot(nLocations)
ylabel('Number of optimal sequences')
xlabel('Sign post sequence length')