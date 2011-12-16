classdef Cylinder_Area < handle
% Describes the area where all the experiments are held which include black
% cylinders as visual landmarks.
    
    properties
        amount;             % amount of cylinders
        cylinders;          % 2x6 Matrix, containing all the X,Y coordinates of the cylinders
        landmark_route;     % Displays the Training route 
        size = [0,0];       % Area size
        feeder = [0, 0];    % Feeder position
        nest = [0, 0];      % Nest position
        nest_two = [0 0];   % Second Nest position ( used for "moved_nest" experiment.
    end
    
    methods
        
        % Creation procedure of the Cylinder Area
        function obj = Cylinder_Area(length_x, length_y, start_x,start_y,n_of_cylinders)
            xlim([0, length_x]); % Length of the area in X direction
            ylim([0, length_y]); % Length of the area in Y direction
            obj.size = [length_x, length_y];
            obj.cylinders = zeros(n_of_cylinders,2);    
            obj.amount = n_of_cylinders;% amount of cylinders on the area
    
            
            % Sets the feeder position
            obj.feeder(1) = start_x-200;
            obj.feeder(2) = start_y + obj.amount*200;
            
            % Sets the nest position
            obj.nest(1) = start_x - 85;
            obj.nest(2) = start_y - 50;
            
            obj.cylinders(1,:) = [start_x start_y]; % Stores position of cylinder 1
            
            k = 2; % Starts storing at Cylinder 2 ( 1st one is stored allready
            
            % Places all Cylinders on the Map
            for i = 1:obj.amount
                start_y = start_y + 170;
            % Alternaterly left or right side of the corridor
                if mod(i,2) == 0
                    start_x = start_x + 270;
                else
                    start_x = start_x - 270;
                end
                
                % Stores The coordinates of the Cylinders 
                if k  <= obj.amount  
                    obj.cylinders(k,:) = [start_x start_y];
                    k = k+1;
                 end
  
                hold on
                axis square;
            end
        end
        
        % Plots all the Cylinders into the map
        function plot_cylinders(obj)
            for i = 1: obj.amount
                rectangle('Position',[obj.cylinders(i,:),40,40], 'Curvature', [1,1], 'FaceColor', 'k');
            end
        end
        
        %Plots the training/landmark route (moved_nest experiment) 
        function plot_landmark_route(obj)
           obj.landmark_route = rectangle('Position',[550,0,350,1500], 'Curvature', [0,0], 'FaceColor', [0.9, 0.9, 0.9]);
        end
        
        % Plots two nests that are used for "moved_nest" experiment 
        function plot_new_nest(obj,n)
            if n == 1
                % plots nest two 'N2' 
                text(obj.nest_two(1)-5, obj.nest_two(2), 'N2');
                rectangle('Position',[obj.nest_two(1)-10,obj.nest_two(2)-10,40,20]);
            elseif n == 2
                % plots nest one 'N1'
                obj.nest_two = [obj.nest(1)-5 obj.nest(2)];
                text(obj.nest(1)-5, obj.nest(2), 'N1');
                rectangle('Position',[obj.nest(1)-10,obj.nest(2)-10,40,20]);                
            end
        end
        
        % Plots the regular nest 
        function plot_nest(obj)
            text(obj.nest(1)-5, obj.nest(2), 'N');
            rectangle('Position',[obj.nest(1)-10,obj.nest(2)-10,20,20]);
        end
        
        % plots the feeder 
        function plot_feeder(obj)
            text(obj.feeder(1)-5, obj.feeder(2), 'F');
            rectangle('Position',[obj.feeder(1)-10,obj.feeder(2)-10,20,20]);
        end
    end
    
end

