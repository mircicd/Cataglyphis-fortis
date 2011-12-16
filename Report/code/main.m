%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Main script     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Contains experiments
% Entry point for program execution

clear;
path('experiments\',path); 
% Set random seed
RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', 56355));



%%%%%% Experiments %%%%%%

% Two-leg trajectory
alphas = 0:5:180;
k = [0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20];
epsilon_two_leg = two_leg_trajectory (600, 300, alphas, k, 1)
csvwrite('two-leg trajectory.csv', epsilon_two_leg);

% Three-leg trajectory
epsilon_three_leg = three_leg_trajectory(700, 300, 300, 10)
csvwrite('three-leg trajectory.csv', epsilon_three_leg);


% One-leg trajectory with default channel
channel = Channel(421,500,599,600);
one_leg_trajectory(channel,3);

% Crooked corridor
crooked_corridor(10)

% Corridor of black cylinders
corridor_of_black_cylinders(1);

% Moved nest
moved_nest(10)

% Natural foraging
natural_foraging(10, 80)


