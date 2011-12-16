function crooked_corridor(n_of_ants)
% Describes an experiment where the ant is forced to walk through a
% a corridor of black cylinders and return back to their nest.
% The difference here is, that the corridor is crooked about 45°.
% The trails are recorded to watch the ants behaviour under influence of
% the visual landmarks.

%Input:
% n_of_ants: Amount of ants that run the experiment with the given inputs.

    % Environment
    area = Cylinder_Area(1500,1500,1300,300,6); % Create an area with size 15m^2 and constructs the Cylinders
    area.nest = [1200, 30];
    area.feeder = [100, 1200];
    
    %%%%%%%% Crook the Corridor %%%%%%%%%
    i = area.amount;
    j = area.amount*2;
    % Cylinders are shifted to built a crooked corridor
    while i > 0
        area.cylinders(i) = area.cylinders(i) - 160*(i);
        area.cylinders(j) = area.cylinders(j) - 90;
        i = i - 1;
        j = j - 1;
    end
    u = 6;
    v = 12;
    
    while u > 1
        area.cylinders(u) = area.cylinders(u) + 30;
        area.cylinders(v) = area.cylinders(v) - 85;
        v = v - 2;
        u = u - 2;
    end
   
    % Ants
    ant = Ant(area.nest);
    ant.random_params = [pi/3, 0.3];
    ant.k = 0.13;

    %%%%%%%%%% Initialization %%%%%%%%%%
    % Clear figure screen and hold the graphics
    clf; hold on;
    axis equal;
    xlim([0, area.size(1)]);
    ylim([0, area.size(2)]);      
    
    %%%%%%%%%% Main loop %%%%%%%%%%%%%%
    for ants = 1: n_of_ants    
        % Generates a random number in the intervall [-60,120]
        % Is used to determine how close the ant approaches to Cylinder.
        a = -60;
        b = 120;  
        rand_n = a + (b-a).*rand(1);
        
        % After starting from the nest, which nearby cylinder gets chosen
        c = rand;
        % (Chances 50%)        
        if c > 0.5
            target = [area.cylinders(1)-rand_n area.cylinders(7)];  
        else
            target = [area.cylinders(2)-rand_n area.cylinders(8)];
        end
        
        done = 0;
           while ~done
                tic; % Start time measurement
                cla; % Clear axes
                % Foraging
                if ant.status == 0
                    if ant.move_to(target)
                        if target == [area.cylinders(1)-rand_n area.cylinders(7)]
                            ant.put_landmark_at(area.cylinders(1,:)+ 20);
                            n = length(ant.landmarks);
                            ant.landmarks(n).range = 110; % Determines the Range of the landmark.
                            rand_n = a + (b-a).*rand(1);  % Generates new approach range( how close to come to the cylinder.)  
                            % Decides with a chance of 30% which of the 3 next cylinder to approach
                            c = rand;
                            if c <= 1/3
                                target = [area.cylinders(2) + rand_n area.cylinders(8)];
                            elseif c > 1/3 && c <= 2/3
                                target = [area.cylinders(3) - rand_n area.cylinders(9)];
                            else
                                target = [area.cylinders(4) + rand_n area.cylinders(10)];
                            end          
                        elseif target == [area.cylinders(2) - rand_n area.cylinders(8)]
                            ant.put_landmark_at(area.cylinders(2,:)+ 20);
                            n = length(ant.landmarks);
                            ant.landmarks(n).range = 110; % Determines the Range of the landmark.
                            rand_n = a + (b-a).*rand(1);   
                            target = [area.cylinders(4) + rand_n area.cylinders(10)];
                        elseif target == [area.cylinders(2) + rand_n area.cylinders(8)]
                            ant.put_landmark_at(area.cylinders(2,:)+ 20);
                            n = length(ant.landmarks);
                            ant.landmarks(n).range = 110; 
                            rand_n = a + (b-a).*rand(1);
                            % Decides with a chance of 25%/75% next Cylinder to approach
                            % Cylinder which is more far away, has less chance
                            c = rand;
                            if c <= 1/4
                                target  = [area.cylinders(3)-rand_n area.cylinders(9)];
                            else
                                target = [area.cylinders(4)+rand_n area.cylinders(10)];
                            end      
                        elseif target == [area.cylinders(3)-rand_n area.cylinders(9)]
                            ant.put_landmark_at(area.cylinders(3,:) + 20);
                            n = length(ant.landmarks);
                            ant.landmarks(n).range = 110; 
                            rand_n = a + (b-a).*rand(1);
                            % Decides with a chance of 25%/75% next approach                            
                            c = rand;
                            if c <= 1/4
                                target = [area.cylinders(4)+rand_n area.cylinders(10)];
                            else
                                target = [area.cylinders(5) - rand_n area.cylinders(11)];
                            end
                        elseif target == [area.cylinders(4)+rand_n area.cylinders(10)]
                            ant.put_landmark_at(area.cylinders(4,:) + 20);
                            n = length(ant.landmarks);
                            ant.landmarks(n).range = 110; 
                            rand_n = a + (b-a).*rand(1);
                            % Decides with a chance of 25%/75% next approach
                            c = rand;
                            if c <= 1/4
                                target = [area.cylinders(5) - rand_n area.cylinders(11)];
                            else
                                target = [area.cylinders(6) + rand_n area.cylinders(12)];
                            end        
                        elseif target == [area.cylinders(5) - rand_n area.cylinders(11)]
                            n = length(ant.landmarks);
                            ant.landmarks(n).range = 110; % Determines the Range of the landmark.
                            ant.put_landmark_at(area.cylinders(5,:) + 20);
                            rand_n = a + (b-a).*rand(1);
                            % Decides with a chance of 25%/75% next approach
                            if c <= 1/4
                                target = [area.cylinders(6) + rand_n area.cylinders(12)];
                            else
                                target = area.feeder;
                            end
                        elseif target == [area.cylinders(6) + rand_n area.cylinders(12)]
                            n = length(ant.landmarks);
                            ant.landmarks(n).range = 110; % Determines the Range of the landmark.
                            ant.put_landmark_at(area.cylinders(6,:) + 20);
                            target = area.feeder;
                        elseif target == area.feeder
                            ant.status = 1;
                        end
                    end
                % Returning to Nest
                elseif ant.status == 1
                    if ant.follow_local_v();
                        if  ~ant.follow_global_v()
                        else
                            ant.reset(area.nest);
                            ant.landmarks = [];
                            done = 1;
                        end   
                    end
                end
                % Plot
                area.plot_nest();
                area.plot_feeder();
                area.plot_cylinders();
                ant.plot();

                pause(0.001);
            end
    end
end

