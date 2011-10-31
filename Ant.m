classdef Ant < handle
    %ANT class
    %   Describes the entity ant.
    
    properties
        pos = [0, 0];               % Position
        speed = 0;                  % Movement speed
        global_v = [0, 0];          % Global vector
        local_v = [0, 0];
        ang = 0;                    % Current moving angle
        phi = 0;                  % Mean angle
        l = 0;                    % Mean distance
        landmarks = Landmark;
        
        im = imread('ant.png');     % Image to plot
    end
    
    methods 
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
            else
                arrived = 1;
            end    
        end
        function update_global_v(obj)
            % Update the ant's global vector
            
            delta = obj.ang - obj.phi;      % Current turning angle
     
            % Version 1
            %obj.phi = (obj.l*obj.phi + obj.phi + delta)/(obj.l + 1);
            % Version 2
            k = 0.1;
            obj.l = obj.l + 1 - delta/(pi/2);   % Mean distance
            obj.phi = obj.phi + k * ((pi+delta)*(pi-delta)*delta)/obj.l;
            
            
            % Compute global vector
            obj.global_v(1) = 50*cos(obj.phi + pi);
            obj.global_v(2) = 50*sin(obj.phi + pi);
        end
        function follow_global_v(obj)
            % Lets the ant follow its global vector
            obj.move_to(obj.pos(1)+obj.global_v(1), obj.pos(2)+obj.global_v(2));
        end
        function set_landmark(obj, landmark)
        end
        function get_local_v(obj, landmark)
        end
        function found = search(obj)
        end
        function plot(obj)
            % Plot the ant
            %obj.im = imrotate(obj.im, obj.ang);
            %obj.im = imrotate(obj.im, obj.ang, 'crop');
            %image(obj.pos(1)-15.5, obj.pos(2)-14, obj.im);
            plot(obj.pos(1), obj.pos(2), '.'); % Alternative
            
            % Plot mean vector
            %quiver(obj.pos(1), obj.pos(2), 50*cos(obj.phi), 50*sin(obj.phi));
            % Plot global vector
            quiver(obj.pos(1), obj.pos(2), obj.global_v(1), obj.global_v(2));
        end
    end
    
end

