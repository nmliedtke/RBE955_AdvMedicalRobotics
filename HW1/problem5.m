%% Advanced Topics in Surgical Robotics - B Term 2019
%  Homework 1 - Problem 5 - Inverse Kinematics of the C-arm
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

% Define the desired position:
pd = [1.5 3 1.5]';

% Define the starting configuration...
q0 = q';
qi = q0;

% ...and the starting position:
T = robot.fkine(q0);

pi = transl(T)';


% Iteratively get closer to the desired configuration:
while norm(pd - pi) > 1e-3
    
    % Calculate the Jacobian matrix for the robot at the current location
    J = robot.jacob0(qi);
    J = J(1:3,1:5);
    
   
    
    %%  *** ADD YOUR CODE BELOW ***
     Jinv = pinv(J)
    Ttemp = robot.fkine(qi);
    Ptemp = transl(Ttemp)';
    e = pd - Ptemp
    
    
     
     deltaQ = Jinv * e
    
    % Update qi to get it closer to qd
    qi = qi + [deltaQ; 0];
    T = robot.fkine(qi);
    pi = transl(T)';
    
    % Animate the robot
    robot.teach(qi');
end

disp('Success! You have now completed homework 1.');