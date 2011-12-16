function epsilon = one_leg_trajectory( channel, n_of_ants )
    %ONE_LEG_TRAJECTORY Experiment with one-legged channel and 'n_of_ants' ants
	% In [CCBW98] an experiment is described where desert ants were trained to go to a tube, 
	% walk through it to a feeder, walk back through it and then return to their nest. 
	% The point of interest was on the returning after leaving the channel. The authors 
	% manipulated the channels from the training situation. The experts could witness that 
	% most animals at first still walked in the same direction as in the training situation, 
	% but then changed the direction towards the nest. They supposed that the desert ants could 
	% remember that at the end of the tunnel they had to walk in a certain direction to find 
	% their nest. After a certain time they started to follow the global vector. 
    
    % Environment
    area = Area(1000,1000);          % Create an area with size 10m^2
    area.nest = [500, 50];           % Nest position
    area.feeder = [420,500];         % Feeder position
        
    % Ants
    ant = Ant(area.nest);            % Create ant at nest
    ant.random_params = [pi/4, 0.3]; % Random parameters
	
    %%%%%%%%%% Initialization %%%%%%%%%%
    % Clear figure screen and hold the graphics
    clf; hold on;
    axis equal;
    xlim([0, area.size(1)]);
    ylim([0, area.size(2)]);

    %%%%%%%%%% Main loop %%%%%%%%%%%%%%
    for ants=1:n_of_ants
        % Starting conditions
        ant.del_landmark(1);                         % Delete first landmark
        testing_channel = Channel(500,500,422,500);  % Set testing channel
        plotting_channel = testing_channel;          % Set plotting channel      
        target = testing_channel.entrance;           % Set target
        done = 0;                                    % Ant not done yet
        
        while ~done
            cla;    % Clear axes
            
            % Foraging, ant goes to nest like trained
            if ant.status == 0
                if ant.move_to(target)
                    if target == testing_channel.entrance;
                        % put landmark at channel entrance
                        ant.put_landmark();     
                        target = testing_channel.exit;
                    elseif target == testing_channel.exit                        
                        target = area.feeder;
                    elseif target == area.feeder
                        % Ant walks back through new channel
                        plotting_channel = channel;
                        ant.landmarks(1).pos = channel.exit;
                        target = channel.entrance;
                    elseif target == channel.entrance
                        target = channel.exit;
                    elseif target == channel.exit
                        target = area.nest;
                        ant.status = 1;
                    end
                end
                
            % Returning to the nest
            elseif ant.status == 1
                 if ant.follow_local_v()
                       if ant.follow_global_v();
                           % Reset: Put ant to nest
                           ant.reset(area.nest);
                           target = [500,500];
                           done = 1;
                       end
                 end
            end

            % Plot
            area.plot_nest();
            area.plot_feeder();
            plotting_channel.plot();
            ant.plot();

            % Debugging: Different 
            text(10, area.size(2)-60, strcat('\phi = ', int2str(ant.phi*180/pi), '°'));
            text(10, area.size(2)-100, strcat('l = ', int2str(ant.l)));

            pause(0.001);  % Pause 0.001 seconds 
        end
    end
end



