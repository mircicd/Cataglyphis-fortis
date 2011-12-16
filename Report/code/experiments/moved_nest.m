function moved_nest(n_of_ants)
% Describes an experiment where the ant is forced to walk through a
% landmark route containing a corridor of black cylinders.
% After being trained on that route the ants nest gets shifted to another
% position where the ant starts its foraging process once again.
% The landmark vectors are directed north as from the trainings procedure.
% After returning from the feeder some ants decide to follow the landmark
% route where as others decide to follow the global vector directly to the
% nest. The different trails are colored with different colors to show the
% difference of the trajectories.

%Input:
% n_of_ants: Amount of ants that run the experiment with the given inputs.

    % Environment
    area = Cylinder_Area(1500,1500,850,200,6); % Create an area with size 15m^2 and constructs the Cylinders
    area.nest = [125 1250];
    area.nest_two = [800, 1350];
    area.feeder = [750 100];

    % Ants
    ant = cell(1,n_of_ants);
   
    %%%%%%%%%% Initialization %%%%%%%%%%
    % Clear figure screen and hold the graphics
    clf; hold on;
    axis equal;
    xlim([0, area.size(1)]);
    ylim([0, area.size(2)]);
    
    do_training = 1; 
    yes = 0;
    
    %%%%%%%%%% Main loop %%%%%%%%%%%%%%
    for ants = 1:n_of_ants
        ant{ants} = Ant(area.nest);
        ant{ants}.random_params = [pi/3, 0.3];
        ant{ants}.k = 0.09;

        %%%%%%%%%%%% Wich trajectory the Ant chooses (red, green,blue) %%%%%%%%%%
        red = 0;
        green = 0;
        a = rand;
        if a <= 1/3
            target = [area.cylinders(4) area.cylinders(10)];
        elseif a > 1/3 && a <= 2/3
            target = [area.cylinders(2)-80 area.cylinders(8)];
            ant{ants}.trail_color = 'red';
            red = 1;
        elseif a > 2/3
            target = area.feeder;
            ant{ants}.trail_color = 'green';
            green = 1;
        end
        
        done = 0;
        while ~done
            tic; % Start time measurement
            cla; % Clear axes
            
            % Foraging
            if ant{ants}.status == 0

%               %%%%%%%%%%% Trainings situation %%%%%%%%%%%%%
                if do_training % First targets gets reset.
                    if yes < 1
                        ant{ants}.pos = area.nest_two;
                        target = [ area.cylinders(6)+ 95 area.cylinders(12) ];
                        yes = 1; 
                    end
%                   % Ant goes through corridor in trainings situation
                    if ant{ants}.move_to(target)
                        if target == [area.cylinders(6)+ 95 area.cylinders(12) ];
                            % The ants on the 'green' trail dont always follow the local vector
                            % Therefore some landmarks aren't put while trainings mode
                            if green ~= 1;
                               ant{ants}.put_landmark_at(area.cylinders(6,:));% Ant stores landmark at cylinder position
                               n = length(ant{ants}.landmarks);
                               ant{ants}.landmarks(n).range = 115; % Determines the Range of the landmark.
                            end
                           target = [area.cylinders(5)- 140 area.cylinders(11)]; % next target gets chosen.
                        elseif target == [area.cylinders(5)- 140 area.cylinders(11)]
                           ant{ants}.put_landmark_at(area.cylinders(5,:) + 20);
                           n = length(ant{ants}.landmarks);
                           ant{ants}.landmarks(n).range = 150;
                           target = [area.cylinders(4) + 85 area.cylinders(10) ];
                        elseif target == [area.cylinders(4) + 85 area.cylinders(10)]
                               ant{ants}.put_landmark_at(area.cylinders(4,:) + 20);
                               n = length(ant{ants}.landmarks);
                               % Range differs randomly for some Cylinders
                               if green ~= 1
                                ant{ants}.landmarks(n).range = 130;
                               else
                                   ant{ants}.landmarks(n).range = 70;
                               end
                           target = [area.cylinders(3) - 75 area.cylinders(9)];
                        elseif target == [area.cylinders(3) - 75 area.cylinders(9)]
                           ant{ants}.put_landmark_at(area.cylinders(3,:) + 20);
                           n = length(ant{ants}.landmarks);
                           ant{ants}.landmarks(n).range = 90;
                           target = [area.cylinders(2) + 100 area.cylinders(8)];
                        elseif target == [area.cylinders(2) + 100 area.cylinders(8)]
                           ant{ants}.put_landmark_at(area.cylinders(2,:) + 20)
                           n = length(ant{ants}.landmarks);
                           ant{ants}.landmarks(n).range = 130;
                           target = [area.cylinders(1) - 85 area.cylinders(7)];
                        elseif target == [area.cylinders(1) - 85 area.cylinders(7)]
                           ant{ants}.put_landmark_at(area.cylinders(1,:) + 20)
                           n = length(ant{ants}.landmarks);
                           ant{ants}.landmarks(n).range = 110;
                           target = area.feeder;
                        elseif target == area.feeder;
                            do_training = 0; % Finishes trainings situation
                            ant{ants}.reset(area.nest); % Ant are reset  
                        end
                    end
                

                %%%%%%%%%%% Foraging from second nest %%%%%%%%%%%%%%%%%%
                else
                    if ant{ants}.move_to(target)
                        if target == [area.cylinders(4), area.cylinders(10)]
                            target = [area.cylinders(2)+ 50 area.cylinders(8)];
                        elseif target == [area.cylinders(2)+ 50 area.cylinders(8)]
                            target = area.feeder();
                        elseif target == [area.cylinders(2)-80 area.cylinders(8)]
                            target = area.feeder();                  
                        elseif target == area.feeder();
                            ant{ants}.status = 1;                        
                        end
                    end
                end
            % Returning to Nest
            elseif ant{ants}.status == 1
                if red == 1;
                    if ant{ants}.follow_local_v();
                        if  ~ant{ants}.follow_global_v()
                        else
                            ant{ants}.reset(area.nest);
                            ant{ants}.landmarks = [];
                            done = 1;
                            do_training = 1;
                            yes = 0;
                        end   
                    end
                elseif green == 1;
                    if ant{ants}.follow_local_v();
                        if  ~ant{ants}.follow_global_v()
                        else
                            ant{ants}.reset(area.nest);
                            ant{ants}.landmarks = [];
                            done = 1;
                            do_training = 1;
                            yes = 0;
                        end   
                    end
                else
                   if ~ant{ants}.follow_global_v()
                   else
                            ant{ants}.reset(area.nest); % Ants are reset
                            ant{ants}.landmarks = []; % Landmarks are reset
                            done = 1;
                            do_training = 1; % Trainings mode is inserted for next ant
                            yes = 0;
                   end
                end
            end

            %Plot
            area.plot_landmark_route;
            area.plot_new_nest(1);
            area.plot_new_nest(2);
            area.plot_feeder();
            area.plot_cylinders();
            for i=1:n_of_ants
                if ant{i} ~= 0
                    ant{i}.plot();
                end
            end
            area.nest_two = [800, 1350]; 
            
            pause(0.001);
        end
    end
end

