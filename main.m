%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Main script     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Contains data initialization
% Entry point for program execution


%%%%%%% Variables & Objects %%%%%%%

% General
time = 0;
timestep = 1;
duration = 10000;

% Ant
clear ant;
ant = Ant;

% Environment
clear area;
area = Area;

% Testing
test_x = 0;
test_y = 0;

%%%%%%%%%% Initialization %%%%%%%%%%
% Clear figure screen and hold the graphics
clf; hold on;
axis equal;
xlim([0, area.size(1)]);
ylim([0, area.size(2)]);

%%%%%%%%%% Main loop %%%%%%%%%%%%%%
for time = 0:timestep:duration
    cla; % Clear axes
    if ant.move_to(test_x, test_y)
        test_x = randi(area.size(1));
        test_y = randi(area.size(2));
    end
    ant.plot();    
    
    % Debugging
    text(10, area.size(2)-20, strcat('x: ', int2str(test_x)));
    text(10, area.size(2)-60, strcat('y: ', int2str(test_y)));
    
    pause(0.01);
end


