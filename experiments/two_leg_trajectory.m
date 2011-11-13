function epsilon = two_leg_trajectory( a, b, alpha, n_of_ants )
%TWO_LEG_TRAJECTORY 
    % Timing
    global time;
    %global timestep;
    global duration;
    global itt;    % Iteration time
    %global period; % Iteration period
    
    % Environment
    area = Area(1000,1000); % Create an area with size 10m^2
    area.nest = [100, 50];
    
    % Ants
    ant = Ant(area.nest);
    ant.m_mode = 1;
    
    % Channel
    rad = alpha*(pi/180);   % Convert angle to radian
    channel = Channel(100, 100, 100, 100+a, 100+cos(rad-(pi/2))*b, (100+a)-sin(rad-(pi/2))*b);
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
        done = 0;
        while ~done
            tic; % Start time measurement
            cla; % Clear axes
            % Foraging
            if ant.status == 0
                if ant.move_to(target)
                    if target == channel.entrance;
                        target = channel.nodes(3:4);
                    elseif target == channel.nodes(3:4)
                        target = channel.exit;
                    elseif target == channel.exit
                        ant.status = 1;
                        % Compute epsilon
                        eps_correct = angle( (area.nest(1)-ant.pos(1)) + (area.nest(2)-ant.pos(2))*1i ); % Compute correct angle directed to the nest
                        epsilon(ants) = abs((ant.phi-pi)-eps_correct); % Compute difference to the ant's global vector
                        epsilon(ants) = epsilon(ants)*(180/pi); % Convert to degrees
                    end
                end
            % Returning to the nest
            elseif ant.status == 1
                if ant.pos(1) > area.nest(1) && ant.pos(2) > area.nest(2)    
                    ant.follow_global_v();
                else
                    ant.status = 0;
                    ant.phi = 0;
                    ant.l = 0;
                    target = channel.entrance;
                    ant.pos = area.nest;
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
            text(10, area.size(2)-20, strcat('ang = ', int2str(ant.ang*180/pi), '°'));
            text(10, area.size(2)-60, strcat('\phi = ', int2str(ant.phi*180/pi), '°'));
            text(10, area.size(2)-100, strcat('l = ', int2str(ant.l)));
            text(200, area.size(2)-20, strcat('t = ', num2str((time*100)/duration),'%'));
            text(200, area.size(2)-60, strcat('(x,y) = (', int2str(ant.pos(1)),',',int2str(ant.pos(2)),')'));
            text(200, area.size(2)-100, strcat('itt = ', num2str(itt)));
            text(400, area.size(2)-20, strcat('local v = [',int2str(ant.local_v(1)),', ',int2str(ant.local_v(2)),']'));


            pause(0.001);
            %pause(period-toc);   % Stop time measurement and keep period synchronized to 0.05s
            itt = toc;    
        end
    end
end

