%% Advanced Topics in Surgical Robotics - B Term 2019
%  Homework 2 - Problem 1 - Frenet-Serret Frames
clear, clc, close all


% Let's define a set of arc parameters to describe our curve
arcLength = 10e-3; %[m]
k         = 100;    % Curvature [m^-1]
tau       = 100;     % Torsional Profile [m^-1]

%% *** DO NOT TOUCH THE CODE IN THIS SECTION - SKIP TO LINE 42 ***

% Create lambda functions to represent local curvature and torsion along the curve
kFun   = @(s, arcLength) k .* ones(1,length(arcLength));
tauFun = @(s, arcLength) tau .* ones(1,length(arcLength));


% We will now write down the system of differential equations that define
% the Frenet-Serret frames.
% Note:
% t = [x(1) x(2) x(3)]
% n = [x(4) x(5) x(6)]
% b = [x(7) x(8) x(9)]
f = @(s,x) [kFun(s,arcLength)*x(4);
            kFun(s,arcLength)*x(5);
            kFun(s,arcLength)*x(6);
            -kFun(s,arcLength)*x(1) + tauFun(s,arcLength)*x(7);
            -kFun(s,arcLength)*x(2) + tauFun(s,arcLength)*x(8);
            -kFun(s,arcLength)*x(3) + tauFun(s,arcLength)*x(9);
            -tauFun(s,arcLength)*x(4);
            -tauFun(s,arcLength)*x(5);
            -tauFun(s,arcLength)*x(6)];

% Use ode45 to solve the above system of differential equations
[l,y] = ode45(f, ...      % differential equations to be solved
    0:1e-4:arcLength, ... % range where we wish to calculate the solution
    [0 0 1 1 0 0 0 1 0]); % initial conditions

% Extrapolate the t, n, and b vectors
t = [y(:,1) y(:,2) y(:,3)]'
n = [y(:,4) y(:,5) y(:,6)]';
b = [y(:,7) y(:,8) y(:,9)]';

%% Time to calculate the 3D coordinates of the points along the arc
arc = zeros(3, size(l, 1));
for i = 1:size(t,2)
   arc(:,i) = trapz(t(:,1:i)')
end
% YOUR CODE HERE


%% Make an animation showing the Frenet-Serret frames along the curve
figure
plot3(arc(1,:), arc(2,:), arc(3,:), 'LineWidth',3,'Color',(1/256)*[255 128 0]);
hold on, axis equal, grid on
xlabel('X [m]'), ylabel('Y [m]'), zlabel('Z [m]'),
set(gca,'FontSize',16);
title('3D Curve and corresponding Frenet-Serret Frames');

%triad('scale', 5e-3/2, 'linewidth', 2.5);
triad('scale', 10, 'linewidth', 2.5);
%h = triad('scale', 5e-3/2, 'linewidth', 2.5);
h = triad('scale', 10, 'linewidth', 2.5);


for ii = 2 : size(l, 1)
    rot = [n(:,ii) b(:,ii) t(:,ii)];
    transl = arc(:,ii);
    T = [rot transl; 0 0 0 1]
    
    h.Matrix = T;
    %set(h,'Matrix', T)
    pause(0.1);
    drawnow
end