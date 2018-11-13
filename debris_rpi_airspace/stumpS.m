%{
function [outputArg1,outputArg2] = stumpS(inputArg1,inputArg2)
%STUMPS Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end
%}

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
function s = stumpS(z) 
% ~~~~~~~~~~~~~~~~~~~~~~ 
%{   
This function evaluates the Stumpff function S(z) according   to Equation 3.52.     
z - input argument   
s - value of S(z)     User M-functions required: none 
%} 
% ----------------------------------------------    
if z > 0     
    s = (sqrt(z) - sin(sqrt(z)))/(sqrt(z))^3; 
elseif z < 0     
    s = (sinh(sqrt(-z)) - sqrt(-z))/(sqrt(-z))^3; 
else
    s = 1/6;
end % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 