function [ F ] = ground_effect( z )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if z > 0.4
    z = 0.4;
elseif z < 0
    z = 0;
end
f = -78.2*z^2 + 63.1*z + 47.3;  % Paper's mapping to thrust percentage
F = 0.031*f+0.283;              % Paper's mapping to Newtons

%F = 0;

end

