function c = stumpC(z)
%STUMPC Summary of this function goes here
%   Detailed explanation goes here
if z > 0     
    c = (1 - cos(sqrt(z)))/z; 
elseif z < 0     
    c = (cosh(sqrt(-z)) - 1)/(-z); 
else
    c = 1/2; 
end
end

