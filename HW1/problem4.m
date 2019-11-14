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
Jreference = robot.jacob0(q)

%%  *** ADD YOUR CODE BELOW ***
% Calculate the robot Jacobian:

syms q1 q2 q3 q4 q5


dhtable(1,:) = [0 0 q1 0];
dhtable(2,:) = [0 0 0 q2];
dhtable(3,:) = [-pi/2 0 q3 0];
dhtable(4,:) = [0 0 0 q4-pi/2];
dhtable(5,:) = [-pi/2 a4 0 q5-pi/2];
dhtable(6,:) = [-pi/2 a5 0 0];

% Calculate the Jacobian Matrix

T01 = tdh(dhtable(1,:));
T12 = tdh(dhtable(2,:));
T23 = tdh(dhtable(3,:));
T34 = tdh(dhtable(4,:));
T45 = tdh(dhtable(5,:));
T56 = tdh(dhtable(6,:));

T02 = T01*T12;
T03 = T02*T23;
T04 = T03*T34;
T05 = T04*T45;
T06 = T05*T56;


 p = T06(1:3,4);
 z = T06(1:3,3);
 
 A = [diff(p,q1), diff(p,q2), diff(p,q3), diff(p,q4), diff(p,q5)];
 A = subs(A, [q1,q2,q3,q4,q5],[q(1),q(2),q(3),q(4),q(5)]);
 
 B = [[0;0;0], T02(1:3,3),[0;0;0],T04(1:3,3),T05(1:3,3)];
 B = subs(B, [q1,q2,q3,q4,q5],[q(1),q(2),q(3),q(4),q(5)]);
 J = double([A;B])

%% *** TESTS --- DO NOT TOUCH THE CODE BELOW ***
% Verify the numerical correctness
assert(norm(J-Jreference(:,1:5)) < eps(5), ...
    'Test failed. Check your forward kinematics for mistakes.');

disp('Success! You can now move to problem 5.');