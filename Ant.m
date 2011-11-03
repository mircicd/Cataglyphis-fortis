classdef Ant < handle
    %ANT class
    %   Describes the entity ant.
    properties
        pos;                        % Position
        speed = 0;                  % Movement speed
        global_v = [0, 0];          % Global vector
        local_v = [0, 0];           % Local vector
        target = [0, 0];            % Target the local vector points to
        ang = 0;                    % Current moving angle
        phi = 0;                    % Mean angle
        l = 0;                      % Mean distance
        landmarks;                  % List of landmarks
        
        im = imread('ant.png');     % Image to plot
    end
    
    methods 
        % Construction
        function obj = Ant(pos_x, pos_y)
            % Creates an ant at the specified position
            obj.pos = [pos_x, pos_y];
        end     
        % Moving
        function arrived = move_to(obj, x, y)
            % Makes the ant move to the point specified by x and y
            % Returns 1 if the ant arrived at the point
            
            arrived = 0;
            
            x_dist = x - obj.pos(1);            % Horizontal distance
            y_dist = y - obj.pos(2);            % Vertical distance
            dist = sqrt(x_dist^2 + y_dist^2);   % Euclidean distance
            
            if dist >= obj.speed
                % Move the ant
                move_x = (obj.speed*x_dist)/dist;
                move_y = (obj.speed*y_dist)/dist;
                obj.ang = angle(move_x + move_y*1i);% Compute current angle
                obj.pos(1) = obj.pos(1) + move_x;  % Move ant along x-axis
                obj.pos(2) = obj.pos(2) + move_y;  % Move ant along y-axis
                
                obj.update_global_v();          % Update the ant's global vector
                obj.update_local_v();           % Update the ant's local vector
            else
                arrived = 1;
            end    
        end
        function found = search(obj)
            %
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
            k = 0.15;
            obj.l = obj.l + 1 - delta/(pi/2);   % Mean distance
            obj.phi = obj.phi + k * ((pi+delta)*(pi-delta)*delta)/obj.l;
            
            % Compute global vector
            obj.global_v = [50*cos(obj.phi + pi), 50*sin(obj.phi + pi)];
        end  
        function follow_global_v(obj)
            % Lets the ant follow its global vector
            obj.move_to(obj.pos(1)+obj.global_v(1), obj.pos(2)+obj.global_v(2));
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
            if obj.within_landmark ~= 0
                obj.target = obj.pos + obj.local_v;
            end
            arrived = 1;
            if obj.target ~= 0
                arrived = 0;
                % Plot local vector
                plot([obj.pos(1),obj.target(1)], [obj.pos(2), obj.target(2)], 'magenta');
                
                if obj.move_to(obj.target(1), obj.target(2))
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
        end
    end
    
end

