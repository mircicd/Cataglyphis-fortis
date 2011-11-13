%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Main script     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Contains data initialization
% Entry point for program execution

clear;
path('experiments\',path); 
%%%%%%% Variables & Objects %%%%%%%

% Timing
global time;
time = 0;
global timestep;
timestep = 1;
global duration;
duration = 10000;
global itt;    % Iteration time
itt = 0;
global period; % Iteration period
period = 0.05;


%%%%%% Experiments %%%%%%
epsilon_two_leg = two_leg_trajectory (600, 300, 135, 3)
epsilon_three_leg = three_leg_trajectory(700, 300, 300, 3)


