classdef Ant < handle
    %ANT class
    %   Describes the entity ant.
    properties
        % Basic
        status = 0;                 % Movement status (either 0 for foraging or 1 for returning or 2 for random search)
        pos;                        % Position on the area
        
        % Movement
        speed = 3;                  % Movement speed
        global_v = [0, 0];          % Global vector
        local_v = [0, 0];           % Local vector
        mean_v = [0, 0];            % Mean vector
        target = [0, 0];            % Target (used for directed and local vector movement)
        random_params = [0, 1];     % Angle (in radian) and drift factor for random walk
        ang = 0;                    % Current moving angle
        phi = 'null';               % Mean angle
        l = 0;                      % Mean distance
        k = 0.13;                   % Normalization constant for deriving the mean angle
        
        % Other
        show_trail = 0;             % Whether the ants trail will be plotted
        landmarks;                  % List of landmarks
        trail = [0, 0];             % Walking trail
        trails = cell(1);           % Container with all trails
        trail_color = 'blue';       % Color of the trails
        
        im = imread('ant.png');     % Image to plot
    end
    
    methods 
        % Construction & Basic Operations
        function obj = Ant(pos)
            % Creates an ant at the specified position
            obj.pos = pos;          % Puts the ant to the given position
            obj.trail = pos;        % Sets the starting point of the trail to the ants' initial position
            obj.trails{1} = pos;    % Empty (dummy) trail
        end 
        
        function reset(obj, pos)
            % Resets the ant's attributes
            obj.status = 0;         % Set status to 'foraging'
            obj.reset_global_v;     % Reset the global vector
            obj.target = [0, 0];    % Reset current target
            obj.pos = pos;          % Put the ant back to 'pos'
        end
        % Moving
        function arrived = move_to(obj, target)
            % Lets the ant move to the point specified by target
            % Returns 1 if the ant has arrived at the point
            
            arrived = 0;
            dist = target - obj.pos;       % Distance vector between the current
                                           % position and the target
            e_dist = norm(dist);           % Euclidean distance
            
            if e_dist >= obj.speed         % If the distance is bigger than the ants' step
                                           % (i.e. the ant has not arrived yet
                % Move the ant
                old_ang = obj.ang;                         % Save old angle
                obj.ang = angle(dist(1) + dist(2)*1i);     % Compute new angle
                delta = mod(obj.ang - old_ang, 2*pi);      % Compute current turning angle
                if delta > pi                              % and adjust the range
                    delta = delta -2*pi;                   % to -pi <= delta <= pi
                end
                % Compute a random angle between -alpha <= ran <= alpha,
                % where alpha = random_params(1) is the random movement
                % angle
                ran = 2*obj.random_params(1)*rand-obj.random_params(1);
                % Compute the drift for random walk with random_params(2)
                drift = obj.random_params(2)*delta;
                % Apply the random values to the ants' old angle
                obj.ang = old_ang + ran + drift;
                
                % Compute the move vector for this step
                move = [cos(obj.ang)*obj.speed, sin(obj.ang)*obj.speed];
                % Advance position by the move vector
                obj.pos = obj.pos + move;
           
                obj.update_global_v();          % Update global vector
                obj.update_local_v();           % Update local vector
                
                if obj.show_trail
                    % Builds up the trail behind the ant
                    n = size(obj.trail);
                    if norm(obj.trail(n(1),:)-obj.pos) > 5
                        % Extend the trail with a new point
                        obj.trail = [obj.trail; obj.pos];
                    end
                else
                    if length(obj.trail) > 2
                        % Save the trail
                        obj.trails{length(obj.trails)+1} = obj.trail;
                    end
                    obj.trail = obj.pos;
                end
            else
                arrived = 1;
            end    
        end

        % Landmarks
        function put_landmark(obj)
            % Puts a landmark at the current position with the current
            % global vector as local vector
            obj.landmarks = [obj.landmarks, Landmark(obj.pos(1), obj.pos(2), obj.global_v(1), obj.global_v(2))];
        end
        
        function put_landmark_at(obj, place)
            % Put a landmark at the given position with the current 
            % global vector as local vector
            obj.landmarks = [obj.landmarks, Landmark(place(1), place(2), obj.global_v(1), obj.global_v(2))];
        end
        
        function del_landmark(obj, i)
            % Removes landmark with index i
            obj.landmarks = [obj.landmarks(1:i-1), obj.landmarks(i+1:length(obj.landmarks))];
        end
        function landmark = within_landmark(obj)
            % Returns a list of landmarks in whose range the ant is
            n = length(obj.landmarks);
            landmark = []; % Default case - the ant is not within a landmark
            for i=n:-1:1
                % Distance between the ant and landmark i
                dist = sqrt( (obj.pos(1)-obj.landmarks(i).pos(1))^2 + ((obj.pos(2)-obj.landmarks(i).pos(2)))^2 );
                if dist < obj.landmarks(i).range
                    % If the ant lies within range, extend the list of
                    % landmarks
                    landmark = [landmark, obj.landmarks(i)];
                end
            end
        end
        % Vectors
        function update_global_v(obj)
            % Update the ant's global vector
            if strcmp(obj.phi, 'null')                 % Check for default value
                obj.phi = obj.ang;
            end
            delta = mod(obj.ang - obj.phi, 2*pi);      % Compute angle delta
            if delta > pi                              % Scale range to -pi<=delta<=pi
                delta = delta -2*pi;
            end
            % Compute covered distance for the current step
            obj.l = obj.l + (1 - abs(delta)/(pi/2));   % Mean distance
            % Compute mean direction for the current step
            % Version 1
            %obj.phi = (obj.l*obj.phi + obj.phi + delta)/(obj.l + 1);
            % Version 2
            obj.phi = mod(obj.phi,2*pi) + obj.k * ((pi+delta)*(pi-delta)*delta)/obj.l;
            
            if obj.phi > pi                            % Scale range to -pi<=phi<=pi
                obj.phi = obj.phi - 2*pi;
            end
            % Compute global vector
            obj.global_v = [70*cos(obj.phi + pi), 70*sin(obj.phi + pi)];
            % Compute mean vector
            obj.mean_v = [70*cos(obj.phi), 70*sin(obj.phi)];
        end
        function reset_global_v(obj)
            % Resets the global vector and its dependent properties
            obj.global_v = [0,0];
            obj.ang = 0;
            obj.phi = 'null';
            obj.l = 0;
        end
        function arrived = follow_global_v(obj)
            % Lets the ant follow the global vector
            obj.show_trail = 1;         % Enables the trail
            arrived = 1;                % Default case
            if obj.l > 5
                % If there's still a distance to travel,
                % keep following the global vector
                obj.move_to(obj.pos+obj.global_v);
                arrived = 0;            % The ant is still on its way
            end
        end
        function update_local_v(obj)
            % Keeps the local vector associated with the last visited
            % landmark
            % Get all landmarks the ant walks on
            current_landmark = obj.within_landmark();
            if length(current_landmark) > 1
                % If there are multiple landmarks, pick the first
                current_landmark = current_landmark(1);
            end
            if current_landmark ~= 0
                % Get the local vector associated with the current landmark
                obj.local_v = current_landmark.local_v;
            else
                % The ant lost its local vector
                obj.local_v = [0, 0];
            end
        end
        function arrived = follow_local_v(obj)
            % Lets the ant follow the local vector (if there is any)
            obj.show_trail = 1;     % Enables trail
            if obj.within_landmark ~= 0
                % As long as the ant lies within the landmark, it keeps
                % the local vector and updates the place it points to
                obj.target = obj.pos + obj.local_v;
            end
            arrived = 1;
            if obj.target ~= 0
                % The local vector is not processed yet
                arrived = 0;
                % Plot local vector
                plot([obj.pos(1),obj.target(1)], [obj.pos(2), obj.target(2)], 'magenta', 'LineWidth', 2);
                
                if obj.move_to(obj.target)
                    % The ant arrived at the point the local vector points
                    % to and resets this point (the target)
                    arrived = 1;
                    obj.target = [0, 0];
                end
            end
        end
            
        % Other
        function plot(obj)
            % Plot the ant as a point
            plot(obj.pos(1), obj.pos(2), '.');
            
            % Plot landmarks
            for i=1:length(obj.landmarks)
                obj.landmarks(i).plot();
            end
            % Plot mean vector
            % plot([obj.pos(1),obj.pos(1)+70*cos(obj.phi)],[obj.pos(2), obj.pos(2)+70*sin(obj.phi)], 'red');
            % Plot global vector
            plot([obj.pos(1),obj.pos(1)+obj.global_v(1)],[obj.pos(2), obj.pos(2)+obj.global_v(2)],'red', 'LineWidth', 2);
            
            % Plot current trail
            plot(obj.trail(:,1), obj.trail(:,2), obj.trail_color);
            % Plot previous trails
            for i=1:length(obj.trails)
                plot(obj.trails{i}(:,1), obj.trails{i}(:,2), obj.trail_color);
            end
            obj.show_trail = 0;
        end
    end
    
end

