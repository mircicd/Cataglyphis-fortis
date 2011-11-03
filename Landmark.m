classdef Landmark < handle
    %LANDMARK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pos;       % Position
        range;     % Covered range
        ang;       % Angle in which direction the local vector points to
        local_v;   % Local vector stored at the landmark
        length;    % Length of local vector
    end
    
    methods
        function obj = Landmark(varargin)
            % Constructor
            % Supports creation from both an angle and vector components
            obj.range = 50;
            obj.length = 100;
            if nargin == 3
                % Create with angle, e.g.: landmark = Landmark(x, y, phi);
                obj.pos = [varargin{1}, varargin{2}];
                obj.ang = varargin{3};
                obj.local_v = [obj.length*cos(obj.ang), obj.length*sin(obj.ang)];
            elseif nargin == 4
                % Create with components, e.g.: landmark = Landmark(x, y, u, v);
                obj.pos = [varargin{1}, varargin{2}];
                obj.local_v = [obj.length*varargin{3}/50, obj.length*varargin{4}/50];
                obj.ang = angle(varargin{3} + varargin{4}*1i);
            end
        end
        
        function plot(obj)
            % Plots the Landmark with its corresponding local vector
            r = 10; x = obj.pos(1); y = obj.pos(2); t = 0:.01:2*pi;
            plot(r*cos(t)+x,r*sin(t)+y, 'black'); % Plot circle
            plot(obj.range*cos(t)+x,obj.range*sin(t)+y, 'yellow'); % Plot range
            %quiver(x, y, 50*cos(obj.ang), 50*sin(obj.ang)); % Plot local vector
            plot([obj.pos(1), obj.pos(1)+obj.length*cos(obj.ang)], [obj.pos(2), obj.pos(2)+obj.length*sin(obj.ang)], 'black');
            text(obj.pos(1)-5, obj.pos(2), 'L');
        end
    end
    
end

