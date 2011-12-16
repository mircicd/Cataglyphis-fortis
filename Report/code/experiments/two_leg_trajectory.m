function epsilon = two_leg_trajectory( a, b, alpha, k, n_of_ants )
%TWO_LEG_TRAJECTORY 
% Describes an experiment where the ant is forced to walk through a
% two-legged channel. At the end of the channel, it finds food and starts
% to head back for its nest. Due to the approximative way the ant keeps
% computing its mean direction (and thus the direction back to the nest),
% errors occur. These errors can be pointed out by manipulating the angle
% between the two elements of the channel.

% Output: 
% epsilon: returns the error angle produced by the ant.
% Inputs:
% a, b: Lengths of the channel-legs.
% alpha: Angle between the two legs.
% k: Normalization constant used in the approximative computation.
% n_of_ants: Amount of ants that run the experiment with the given inputs.


    %%%%%%%%%% Initialization %%%%%%%%%%
    % Environment
    area = Area(1000,1000); % Create an area with size 10m^2
    area.nest = [100, 50];  % Place the nest at Position (100, 50)

    % Output
    epsilon = zeros(length(k),length(alpha),n_of_ants);
    
    % Clear figure screen and hold the graphics
    clf; hold on;
    axis equal;
    xlim([0, area.size(1)]);
    ylim([0, area.size(2)]);

    %%%%%%%%%% Main loops %%%%%%%%%%%%%%
    for i=1:length(k) % Loops through the specified constants k
        for j=1:length(alpha) % Loops through the specified angles alpha
            % Create a new ant and place it to the nest
            ant = Ant(area.nest);
            
            % Channel
            rad = alpha(j)*(pi/180);   % Convert angle to radian
            % Create a channel with the given parameters
            channel = Channel(100, 100, 100, 100+a, 100+cos(rad-(pi/2))*b, (100+a)-sin(rad-(pi/2))*b);
            % Place the feeder at the channel exit
            area.feeder = channel.exit;
            
            for ants=1:n_of_ants % Loops through the specified amount of ants
                % Set the constant k according to the input
                ant.k = k(i);
                % Temporary variables
                target = channel.entrance;
                done = 0;
                while ~done
                    cla; % Clear axes
                    
                    % Phase 1: Foraging
                    if ant.status == 0
                        % Ant moves to target
                        if ant.move_to(target)
                            % Ant arrived at the target, set new target
                            if target == channel.entrance;
                                target = channel.nodes(3:4);
                            elseif target == channel.nodes(3:4)
                                target = channel.exit;
                            elseif target == channel.exit
                                % Ant arrived at the feeder
                                ant.status = 1;
                                % Compute epsilon (error angle)
                                eps_correct = angle( (area.nest(1)-ant.pos(1)) + (area.nest(2)-ant.pos(2))*1i ); % Compute correct angle directed to the nest
                                epsilon(i, j, ants) = abs((ant.phi-pi)-eps_correct); % Compute difference to the ant's global vector
                                epsilon(i, j, ants) = epsilon(i, j, ants)*(180/pi); % Convert to degrees
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
                end % While loop
            end % Ant loop
        end % Alpha loop
    end % k loop
end

