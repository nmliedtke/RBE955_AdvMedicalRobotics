%% Advanced Topics in Surgical Robotics - B Term 2019
%  Homework 1 - Problem 1 - Modified DH Convention
clear, clc, close all

%% *** THIS SCRIPT TESTS THE VALIDITY OF `tdh' - YOU SHOULD NOT CHANGE THE CODE BELOW ***

% Let's define a test vector of DH parameters
alpha = pi/2;
a = 0.5;
d = 0.5;
phi = -pi/2;

% Invoke the `thd' function to get the corresponding homogenous
% transformation matrix
T = tdh([alpha, a, d, phi]);

% Verify that T is 4x4
assert(all(size(T) == [4 4]), ...
    'Test failed. The size of a homogeneous transformation matrix should be 4x4.');

% Verify that det(T) == 1
assert(det(T) - 1 < eps(5), ...
    'Test failed. The determinant of a homogeneous transformation matrix should be 1.');

% Test the correctness of the values in the homogeneous transformation
% matrix
Ttest = [0 1 0 0.5; 0 0 -1 -0.5; -1 0 0 0; 0 0 0 1];
assert(norm(T-Ttest) < eps(5), ...
    'Test failed. Check your tdh function for mistakes.');

disp('Success! You can now move to problem 2.');