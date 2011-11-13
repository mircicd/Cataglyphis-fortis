classdef Ant < handle
    %ANT class
    %   Describes the entity ant.
    properties
        pos;                        % Position
        speed = 5;               % Movement speed (equals 25cm/s)
        global_v = [0, 0];          % Global vector
        local_v = [0, 0];           % Local vector
        target = [0, 0];            % Target the local vector points to
        m_mode = 0;                 % Movement mode (randomness)
        status = 0;                 % Movement status (either 0 for foraging or 1 for returning)
        show_trail = 0;             % Whether the ants trail will be plotted
        ang = 0;                    % Current moving angle
        phi = 0;                    % Mean angle
        l = 0;                      % Mean distance
        landmarks;                  % List of landmarks
        trail = [0, 0];             % Walking trail
        
        im = imread('ant.png');     % Image to plot
    end
    
    methods 
        % Construction
        function obj = Ant(pos)
            % Creates an ant at the specified position
            obj.pos = [pos(1), pos(2)];
        end     
        % Moving
        function arrived = move_to(obj, target)
            % Makes the ant move to the point specified by x and y
            % Returns 1 if the ant arrived at the point
            
            arrived = 0;
            
            dist(1) = target(1) - obj.pos(1);    % Horizontal distance
            dist(2) = target(2) - obj.pos(2);    % Vertical distance
            e_dist = norm(dist);   % Euclidean distance
            
            if e_dist >= obj.speed
                % Move the ant
                if obj.m_mode == 1
                    ran = rand(1);                  % Random value between 0 and 1
                    move = [ran*((obj.speed*dist(1))/e_dist), (1-ran)*((obj.speed*dist(2))/e_dist)];
                elseif obj.m_mode == 0
                    move = [(obj.speed*dist(1))/e_dist, (obj.speed*dist(2))/e_dist];
                end
                obj.ang = angle(move(1) + move(2)*1i);% Compute current angle
                obj.pos(1) = obj.pos(1) + move(1);  % Move ant along x-axis
                obj.pos(2) = obj.pos(2) + move(2);  % Move ant along y-axis
           
                obj.update_global_v();          % Update the ant's global vector
                obj.update_local_v();           % Update the ant's local vector
                if obj.show_trail
                    % Forms the trail behind the ant
                    n = size(obj.trail);
                    if norm(obj.trail(n(1),:)-obj.pos) > 5
                        obj.trail = [obj.trail; obj.pos];
                    end
                else
                    %obj.trail = obj.pos;
                end
            else
                arrived = 1;
            end    
        end
        function random_search(obj)
            % Ant searches randomly for local vectors
            r = 100; % Radius where the ant searches
            current_position = obj.pos;
            %kreispunkt; % Point on circle with radius r
           
                xr = randi([0,r]); % random number between 0 and r
                yr = sqrt(1 - xr^2); % Calculate y-component for point on circle around current position
                
                % Generate random "bools"
                b1 = randi([0,1]); % bool 1
                b2 = rand([0,1]); % bool 2
         
                if b1
                    if b2
                        circle_point = [xr, yr];
                    else 
                        circle_point = [-xr, yr];
                    end
                else
                    if b2
                        circle_point = [xr, -yr];
                    else
                        circle_point = [-xr, -yr];
                    end
                end
                obj.move_to(circle_point);
                obj.move_to(current_position); % ant walks back
        end
        function arrived = move_through_channel(obj, channel)
            % Ant walks through channel
            obj.move_to(channel.entrance);
            for i=1:channel.n_of_legs
                obj.move_to(nodes(i));
            end
        end
        % Landmarks
        function put_landmark(obj)
            % Puts a landmark at the current position with the current
            % global vector
            obj.landmarks = [obj.landmarks, Landmark(obj.pos(1), obj.pos(2), obj.global_v(1), obj.global_v(2))];
        end
        function del_landmark(obj, i)
            % Removes landmark at the specified position
            obj.landmarks = [obj.landmarks(1:i-1), obj.landmarks(i+1:length(obj.landmarks))];
        end
        function landmark = within_landmark(obj)
            % Returns the current landmark the ant walks on
            landmark = 0; % Default case - the ant is not within a landmark
            n = length(obj.landmarks);
            for i=1:n
                % Distance between the ant and landmark i
                dist = sqrt( (obj.pos(1)-obj.landmarks(i).pos(1))^2 + ((obj.pos(2)-obj.landmarks(i).pos(2)))^2 );
                if dist < obj.landmarks(i).range
                    landmark = obj.landmarks(i);
                end
            end
        end
        % Vectors
        function update_global_v(obj)
            % Update the ant's global vector
            if obj.phi == 0
                obj.phi = obj.ang;
            end
            delta = obj.ang - obj.phi;      % Current turning angle
     
            % Version 1
            %obj.phi = (obj.l*obj.phi + obj.phi + delta)/(obj.l + 1);
            % Version 2
            k = 0.20;
            obj.l = obj.l + 1 - delta/(pi/2);   % Mean distance
            obj.phi = obj.phi + k * ((pi+delta)*(pi-delta)*delta)/obj.l;
            
            % Compute global vector
            obj.global_v = [50*cos(obj.phi + pi), 50*sin(obj.phi + pi)];
        end  
        function follow_global_v(obj)
            % Lets the ant follow its global vector
            obj.show_trail = 1;
            obj.move_to(obj.pos+obj.global_v);
        end
        function update_local_v(obj)
            % Keeps the local vector associated with the last visited
            % landmark
            current_landmark = obj.within_landmark();
            if current_landmark ~= 0
                obj.local_v = current_landmark.local_v;
            else
                obj.local_v = [0, 0];
            end
        end
        function arrived = follow_local_v(obj)
            % Lets the ant follow the local vector (if there is any)
            obj.show_trail = 1;
            if obj.within_landmark ~= 0
                obj.target = obj.pos + obj.local_v;
            end
            arrived = 1;
            if obj.target ~= 0
                arrived = 0;
                % Plot local vector
                plot([obj.pos(1),obj.target(1)], [obj.pos(2), obj.target(2)], 'magenta');
                
                if obj.move_to(obj.target)
                    arrived = 1;
                    obj.target = [0, 0];
                end
            end
        end
            
        % Other
        function plot(obj)
            % Plot the ant
            %obj.im = imrotate(obj.im, obj.ang);
            %obj.im = imrotate(obj.im, obj.ang, 'crop');
            %image(obj.pos(1)-15.5, obj.pos(2)-14, obj.im);
            plot(obj.pos(1), obj.pos(2), '.'); % Alternative
            
            % Plot landmarks
            for i=1:length(obj.landmarks)
                obj.landmarks(i).plot();
            end
            % Plot mean vector
            %quiver(obj.pos(1), obj.pos(2), 50*cos(obj.phi), 50*sin(obj.phi));
            % Plot global vector
            plot([obj.pos(1),obj.pos(1)+obj.global_v(1)],[obj.pos(2), obj.pos(2)+obj.global_v(2)], 'red');
            %quiver(obj.pos(1), obj.pos(2), obj.global_v(1), obj.global_v(2));
            
            % Plot the trail
            plot(obj.trail(:,1), obj.trail(:,2))
            obj.show_trail = 0;
        end
    end
    
end

