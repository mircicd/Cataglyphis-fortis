classdef Ant < handle
    %ANT class
    %   Describes the entity ant.
    
    properties
        pos = [0, 0];               % Position
        speed = 1;                  % Movement speed
        global_v = [0, 0];          % Global vector
        im = imread('ant.png');     % Image to plot
    end
    
    methods 
        function arrived = move_to(obj, x, y)
            % Makes the ant move to the point specified by x and y
            % Returns 1 if the ant arrived at the point
            
            arrived = 0;
            
            x_dist = x - obj.pos(1);    % Horizontal distance
            y_dist = y - obj.pos(2);    % Vertical distance
            if abs(x_dist) > 5 || abs(y_dist) > 5
                dist = sqrt(x_dist^2 + y_dist^2);   % Euclidean distance
                obj.pos(1) = obj.pos(1) + (obj.speed*x_dist)/dist;  % Move ant along x-axis
                obj.pos(2) = obj.pos(2) + (obj.speed*y_dist)/dist;  % Move ant along y-axis
            else
                arrived = 1;
            end
        end
        function plot(obj)
            % Plots the ant
            image(obj.pos(1), obj.pos(2), obj.im);
            %plot (Ant_pos(1), Ant_pos(2), '.'); % Alternative
        end
    end
    
end

