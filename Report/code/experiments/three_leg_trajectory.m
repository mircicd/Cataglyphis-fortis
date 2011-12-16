function epsilon = three_leg_trajectory( a, b, c, n_of_ants )
%THREE_LEG_TRAJECTORY 
% Same setup as two-leg trajectory but with three legs.

% Output: 
% epsilon: returns the error angle produced by the ant.
% Inputs:
% a, b, c: Lenghts of the channel legs
% n_of_ants: Amount of ants that run the experiment with the given inputs.

    % Environment
    area = Area(1000,1000); % Create an area with size 10m^2
    area.nest = [100, 50];
    
    % Ants
    ant = Ant(area.nest);
    
    % Channel
    channel = Channel(100, 100, 100, 100+a, 100+b, 100+a, 100+b, (100+a)-c);
    area.feeder = channel.exit;
    
    % Temporary variables
    target = channel.entrance;
    
    % Output
    epsilon = zeros(1,n_of_ants);

    %%%%%%%%%% Initialization %%%%%%%%%%
    % Clear figure screen and hold the graphics
    clf; hold on;
    axis equal;
    xlim([0, area.size(1)]);
    ylim([0, area.size(2)]);

    %%%%%%%%%% Main loop %%%%%%%%%%%%%%
    for ants=1:n_of_ants
        done = 0;   % Status of the current run
        while ~done
            tic; % Start time measurement
            cla; % Clear axes
            % Phase 1: Foraging
            if ant.status == 0
                % Ant moves to target
                if ant.move_to(target)
                    % Ant arrived at the target, set new target
                    if target == channel.entrance;
                        target = channel.nodes(3:4);
                    elseif target == channel.nodes(3:4)
                        target = channel.nodes(5:6);
                    elseif target == channel.nodes(5:6)
                        target = channel.exit;
                    elseif target == channel.exit
                        % Ant arrived at the feeder
                        ant.status = 1;
                        % Compute epsilon (error angle)
                        eps_correct = angle( (area.nest(1)-ant.pos(1)) + (area.nest(2)-ant.pos(2))*1i ); % Compute correct angle directed to the nest
                        epsilon(ants) = abs((ant.phi-pi)-eps_correct); % Compute difference to the ant's global vector
                        epsilon(ants) = epsilon(ants)*(180/pi); % Convert to degrees
                    end
                end
            % Phase 2: Returning to the nest
            elseif ant.status == 1
                % Set up parameters for random walk
                ant.random_params = [pi/4, 0.3];
                % Ant follows its global vector back to the nest
                if ant.follow_global_v()
                    % Ant covered up its calculated distance and
                    % arrived at the nest (best case)
                    % Put the ant back to the nest to start the
                    % next run
                    ant.reset(area.nest);
                    target = channel.entrance;
                    done = 1;
                end
            end

            % Plot
            area.plot_nest();
            area.plot_feeder();
            channel.plot();
            line([channel.exit(1), area.nest(1)], [channel.exit(2), area.nest(2)], 'LineStyle', ':', 'Color', [1,0,0]);
            ant.plot();

            % Debugging
            text(10, area.size(2)-60, strcat('\phi = ', int2str(ant.phi*180/pi), '°'));
            text(10, area.size(2)-100, strcat('l = ', int2str(ant.l)));
            

            pause(0.001);
        end
    end
end

