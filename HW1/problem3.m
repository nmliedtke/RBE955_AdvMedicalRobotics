%% Advanced Topics in Surgical Robotics - B Term 2019
%  Homework 1 - Problem 3 - Forward Kinematics of the C-arm
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
Tref = robot.fkine(q);
Tref = Tref.T;
zref = Tref(1:3,3);
pref = Tref(1:3,4);

%%  *** ADD YOUR CODE BELOW ***
% Given the calculate the forward kinematics
dhtable = zeros(6,4);
dhtable(1,:) = [0 0 q(1) 0];
dhtable(2,:) = [0 0 0 q(2)];
dhtable(3,:) = [-pi/2 0 q(3) 0];
dhtable(4,:) = [0 0 0 q(4)-pi/2];
dhtable(5,:) = [-pi/2 a4 0 q(5)-pi/2];
dhtable(6,:) = [-pi/2 a5 0 0];

T01 = tdh(dhtable(1,:));
T12 = tdh(dhtable(2,:));
T23 = tdh(dhtable(3,:));
T34 = tdh(dhtable(4,:));
T45 = tdh(dhtable(5,:));
T56 = tdh(dhtable(6,:));

T06 = T01*T12*T23*T34*T45*T56;

 p = T06(1:3,4)
 z = T06(1:3,3)

%% *** TESTS --- DO NOT TOUCH THE CODE BELOW ***

% Verify that z is a unit vector
assert(norm(z) == 1, ...
    'Test failed. z must be a unit vector.');

% Verify the correctness of z
assert(norm(zref - z) < eps(5), ...
    'Test failed. Check your calculation of z for mistakes.');

% Verify the correctness of p
assert(norm(pref - p) < eps(5), ...
    'Test failed. Check your calculation of p for mistakes.');

disp('Success! You can now move to problem 4.');