%% Advanced Topics in Surgical Robotics - B Term 2019
%  Homework 1 - Problem 1 - Modified DH Convention

function T = tdh(q)
    alpha = q(1);
    a = q(2); 
    d = q(3);
    phi = q(4);
    
    %% ENTER YOUR CODE BELOW
    
    T = [cos(phi)               -sin(phi)               0               a;...
         sin(phi)*cos(alpha)    cos(phi)*cos(alpha)     -sin(alpha)     -d*sin(alpha);...
         sin(phi)*sin(alpha)    cos(phi)*sin(alpha)     cos(alpha)      d*cos(alpha);...
         0                      0                       0               1];
    % T = ?
end