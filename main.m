%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Main script     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% http://www.cs.ubc.ca/~murphyk/Software/matlabTutorial/html/objectOriented.html
% Contains data initialization
% Entry point for program execution


%%%%%%% Variables & Objects %%%%%%%

% Timing
time = 0;
timestep = 1;
duration = 10000;
itt = 0;    % Iteration time
period = 0.05; % Iteration period

% Ant
clear ant;
ant = Ant;
ant.pos = [100, 100];
ant.phi = pi/2;
ant.speed = 1.25;  % = 25cm/s

% Environment
clear area;
area = Area(1000,1000); % Create an area with size 10m^2

% Testing
test_x = 100;
test_y = 600;
arrived = 0;

%%%%%%%%%% Initialization %%%%%%%%%%
% Clear figure screen and hold the graphics
clf; hold on;
axis equal;
xlim([0, area.size(1)]);
ylim([0, area.size(2)]);

%%%%%%%%%% Main loop %%%%%%%%%%%%%%
for time = 0:timestep:duration
    tic; % Start time measurement
    cla; % Clear axes
    if ~arrived
        if ant.move_to(test_x, test_y)
            if test_x == 300
                arrived = 1;
            end
            test_x = 300;
            test_y = 400;
        end
    else
        ant.follow_global_v();
    end
       
    line([95,95], [100,600]);
    line([95,295], [600,400]);
    ant.plot();
    % Debugging
    text(10, area.size(2)-20, strcat('ang = ', int2str(ant.ang*180/pi), '°'));
    text(10, area.size(2)-60, strcat('\phi = ', int2str(ant.phi*180/pi), '°'));
    text(10, area.size(2)-100, strcat('l = ', int2str(ant.l)));
    text(200, area.size(2)-20, strcat('t = ', num2str((time*100)/duration),'%'));
    text(200, area.size(2)-60, strcat('(x,y) = (', int2str(ant.pos(1)),',',int2str(ant.pos(2)),')'));
    text(200, area.size(2)-100, strcat('itt = ', num2str(itt)));
    
    
    %pause(0.00001);
    pause(period-toc);   % Stop time measurement
    itt = toc;    
end


