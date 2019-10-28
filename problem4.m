%% Advanced Topics in Surgical Robotics - B Term 2019
%  Homework 1 - Problem 4 - Differential Kinematics of the C-arm
clear, clc, close all

%% *** DO NOT TOUCH THE CODE IN THIS SECTION - SKIP TO LINE 24 ***
% Create and display the kinematic chain

a4 = 0.3;
a5 = 1;

robot = SerialLink([...
    PrismaticMDH('a', 0, 'alpha', 0, 'theta', 0, 'qlim', [2 5]) ...
    RevoluteMDH('a', 0, 'alpha', 0, 'd', 0) ...
    PrismaticMDH('a', 0, 'alpha', -pi/2, 'theta', 0, 'qlim', [2 5]) ...
    RevoluteMDH('a', 0, 'alpha', 0, 'd', 0, 'offset', -pi/2) ...
    RevoluteMDH('a', a4, 'alpha', -pi/2, 'd', 0, 'offset', -pi/2) ...
    PrismaticMDH('a', a5, 'alpha', -pi/2, 'theta', 0, 'qlim', [0 0]) ...
    ], 'name', 'C Arm');

q = [2 0 2 0 0 0];
robot.teach(q);
Jreference = robot.jacob0(q);

%%  *** ADD YOUR CODE BELOW ***
% Calculate the robot Jacobian:
dhtable = zeros(6,4);
dhtable(1,:) = [0 0 q(1) 0];
dhtable(2,:) = [0 0 0 q(2)];
dhtable(3,:) = [-pi/2 0 q(3) 0];
dhtable(4,:) = [0 0 0 q(4)-pi/2];
dhtable(5,:) = [-pi/2 a4 0 q(5)-pi/2];
dhtable(6,:) = [-pi/2 a5 0 0];

% Calculate the Jacobian Matrix
% J = ?

%% *** TESTS --- DO NOT TOUCH THE CODE BELOW ***

% Verify the numerical correctness
assert(norm(J-Jreference(:,1:5)) < eps(5), ...
    'Test failed. Check your forward kinematics for mistakes.');

disp('Success! You can now move to problem 5.');