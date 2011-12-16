classdef Landmark < handle
    %LANDMARK class
    %   Describes abstract landmarks set by the foraging ant
    
    properties
        pos;            % Position
        range = 80;     % Covered range
        ang;            % Angle in which direction the local vector points to
        local_v;        % Local vector stored at the landmark
        length = 100;   % Length of local vector
        color = 'black';% Color of the Landmark
    end
    
    methods
        function obj = Landmark(varargin)
            % Constructor
            % Supports creation from both an angle and vector components
            if nargin == 3
                % Create with angle, e.g.: landmark = Landmark(x, y, phi);
                obj.pos = [varargin{1}, varargin{2}];
                obj.ang = varargin{3}; 
                obj.local_v = [obj.length*cos(obj.ang), obj.length*sin(obj.ang)];
            elseif nargin == 4
                % Create with components, e.g.: landmark = Landmark(x, y, u, v);
                obj.pos = [varargin{1}, varargin{2}];
                obj.local_v = [obj.length*varargin{3}/70, obj.length*varargin{4}/70];
                obj.ang = angle(varargin{3} + varargin{4}*1i);
            end
        end
        
        function plot(obj)
            % Plots the Landmark with its corresponding local vector
            r = 10; % Radius of the inner circle
            % Plot small circle around 'L'
            rectangle('Position',[obj.pos(1)-r, obj.pos(2)-r, 2*r, 2*r], 'Curvature', [1,1]);
            % Plot range as circle
            rectangle('Position',[obj.pos(1)-obj.range, obj.pos(2)-obj.range, 2*obj.range, 2*obj.range], 'Curvature', [1,1], 'EdgeColor', 'r');
            % Plot local vector
            plot([obj.pos(1), obj.pos(1)+obj.length*cos(obj.ang)], [obj.pos(2), obj.pos(2)+obj.length*sin(obj.ang)], obj.color, 'LineWidth', 2);
            % Plot 'L'
            text(obj.pos(1)-5, obj.pos(2), 'L', 'Color', obj.color);
        end
    end
    
end

