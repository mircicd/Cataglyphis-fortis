function reached_nest = natural_foraging(n_of_ants, lm_distance)
    % NATURAL FORAGING
    % This experiment recreates roughly a natural foraging sitation where
    % all the implemented navigational modules are collaborating and thus
    % 'guiding' the ant throughout its trip in a best possible way.
    % The ant starts in the center of a 10m^2 area. In every run, a feeder
    % site is put on a random place. The ant picks random points on the
    % area and moves to them. As soon as it gets near to the feeder, its
    % walks towards the feeders center to collect food, and then moves back
    % to the nest, guided by the global vector. During the ants' trip it 
    % sets landmarks after certain distances, which additionally help the 
    % ant when moving back to the nest.
    
    % Output:
    % reached_nest: Whether or not the ant found the way back to the nest
    
    % Input:
    % n_of_ants: Amount of ants that run the test
    % lm_distance: Landmark distance. Interval at which the ant sets
    % landmarks

    % Output
    reached_nest = zeros(1,n_of_ants);
    
    % Environment
    area = Area(1000,1000); % Create an area with size 10m^2
    area.nest = [500, 500];

    %%%%%%%%%% Initialization %%%%%%%%%%
    % Clear figure screen and hold the graphics
    clf; hold on;
    axis equal;
    xlim([0, area.size(1)]);
    ylim([0, area.size(2)]);

    %%%%%%%%%% Main loop %%%%%%%%%%%%%%
    
    for ants=1:n_of_ants % Loops through the specified amount of ants
        
        % Put the feeder at a randomly generated position between 100 and
        % 900 on the area
        area.feeder = [randi(800)+100, randi(800)+100];
        % Create an ant and put it at the nest
        ant = Ant(area.nest);
        % Create a special landmark (so that the ant later on 'sees' the
        % nest from a certain distance (the landmarks' range) and can
        % return to it
        ant.put_landmark_at(area.nest);
        ant.landmarks(1).length = 0;
        ant.landmarks(1).range = 80;

        % Create special landmark for the feeder site
        ant.put_landmark_at(area.feeder);
        ant.landmarks(2).length = 0;
        ant.landmarks(2).range = 80;

        % Set initial random target
        target = [randi(1000), randi(1000)];
        % Set parameters for random walk
        ant.random_params = [pi/4, 0.3];
        % Temporary variables
        done = 0;
        % Variable that holds the distance the last landmark was set
        put_after = 0;
        
        % Main loop
        while ~done
            cla; % Clear axes
            
            % Phase 1: Foraging
            ant.show_trail = 1;
            if ant.status == 0
                if max(ismember(ant.within_landmark, ant.landmarks(2)))
                    % The ant has crossed the feeder landmark and walks
                    % now towards the center
                    if ant.move_to(ant.landmarks(2).pos)
                        % The ant collected food and returns back to the
                        % nest
                        ant.status = 1;
                    end
                else
                    if abs(ant.l-put_after) > lm_distance
                        % The ant covered the required distance to set a
                        % landmark
                        put_after = ant.l;
                        ant.put_landmark();
                    end
                    % The ant walks towards its target
                    if ant.move_to(target)
                        % Arrived at target, set new random target
                        target = [randi(1000), randi(1000)];
                    end
                end
                
            % Phase 2: Returning to the nest
            elseif ant.status == 1
                if max(ismember(ant.within_landmark, ant.landmarks(1)))
                    % The ant has crossed the nest landmarks and walks now
                    % towards the center
                    if ant.move_to(ant.landmarks(1).pos)
                        % The ant arrived at the nest and completed the run
                        done = 1;
                        reached_nest(ants) = 1;
                    end
                else
                    % The ant first follows local vectors on its way home
                    if ant.follow_local_v()
                        % If the local vectors are used up, it follows the
                        % global vector
                        if ant.follow_global_v()
                            % The ant walked back its calculated covered
                            % distance but did not return at the nest.
                            % The and completed the run.
                            done = 1;
                            reached_nest(ants) = 0;
                        end
                    end
                end
            end
            
            % Plot
            ant.plot();
            area.plot_nest();
            area.plot_feeder();

            % Debugging
            text(10, area.size(2)-60, strcat('\phi = ', int2str(ant.phi*180/pi), '°'));
            text(10, area.size(2)-100, strcat('l = ', int2str(ant.l)));

            pause(0.001);
        end
        % Reset the ants' properties and put it back to the nest for the
        % next run
        ant.reset(area.nest);
    end
end
