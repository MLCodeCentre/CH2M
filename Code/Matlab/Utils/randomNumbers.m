function r = randomNumbers(a,b,n)
% returns n random numbers between a and b.
r = (b-a).*rand(n,1) + a;
end