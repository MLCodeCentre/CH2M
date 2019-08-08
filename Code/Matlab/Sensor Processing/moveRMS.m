function y = moveRMS(x,window)

% moving rsm.
x_length = size(x,1);
y = zeros(size(x));

for i = 1:size(x,1)
   
   wi = min([i-1,window,x_length-i]); 
  
   window_start = i - wi;
   window_end = i + wi;
   
   window_data = x(window_start:window_end);
   RMS = sqrt(sum(window_data.^2)/(2*window));
   y(i) = RMS;
end