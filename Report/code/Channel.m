classdef Channel < handle
    %CHANNEL Class
    %   Describes an n-leg channel
    
    properties
        n_of_legs;      % Number of legs
        entrance;       % Entrance coordinates
        exit;           % Exit coordinates
        nodes;          % Nodes of the channel
    end
    
    methods
        
        function obj = Channel(varargin)
            % Constructor
            % Provides inputs from 1 leg up to 3 legs Inputs are nodes
            if nargin == 4
                % Creates Channel with 2 nodes, e.g.: channel = Channel(x1, y1, x2, y2);
                obj.n_of_legs = 1;
                obj.entrance = [varargin{1}, varargin{2}];
                obj.exit = [varargin{3}, varargin{4}];
                obj.nodes = [varargin{1}, varargin{2}, varargin{3}, varargin{4}];
            elseif nargin == 6
                % Creates Channel with 3 nodes, e.g.: channel = Channel(x1, y1, x2, y2, x3, y3);
                obj.n_of_legs = 2;
                obj.entrance = [varargin{1}, varargin{2}];
                obj.exit = [varargin{5}, varargin{6}];
                obj.nodes = [varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}, varargin{6}];
            elseif nargin == 8
                % Creates Channel with 4 nodes, e.g.: channel = Channel(x1, y1, x2, y2, x3, y3, x4, y4);
                obj.n_of_legs = 3;
                obj.entrance = [varargin{1}, varargin{2}];
                obj.exit = [varargin{7}, varargin{8}];
                obj.nodes = [varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}, varargin{6}, varargin{7}, varargin{8}];
            end
        end
        
        function plot(obj)
            % Plots the channel            
            for i=1:2:2*obj.n_of_legs
                
                % Width of channel
                w = 10;    
                % Direction vector
                v = [obj.nodes(i+2)-obj.nodes(i), obj.nodes(i+3)-obj.nodes(i+1)];
                % Direction vector with length w
                vn = w*(v/sqrt((obj.nodes(i+2)-obj.nodes(i))^2+(obj.nodes(i+3)-obj.nodes(i+1))^2));    
                % Orthogonal vector to direction vector
                vr = [-(obj.nodes(i+3)-obj.nodes(i+1)),obj.nodes(i+2)-obj.nodes(i)];    
                % Orthogonal vector to direction vector with lenght w
                vrn = w*(vr/sqrt((-obj.nodes(i+2)+obj.nodes(i))^2+(obj.nodes(i+3)-obj.nodes(i+1))^2));   
                
                % Wall points
                wp11 = [obj.nodes(i)+vn(1)+vrn(1), obj.nodes(i+1)+vn(2)+vrn(2)];    % wall point 1.1
                wp12 = [obj.nodes(i+2)-vn(1)+vrn(1), obj.nodes(i+3)-vn(2)+vrn(2)];  % wall point 1.2
                wp21 = [obj.nodes(i)+vn(1)-vrn(1), obj.nodes(i+1)+vn(2)-vrn(2)];    % wall point 2.1
                wp22 = [obj.nodes(i+2)-vn(1)-vrn(1), obj.nodes(i+3)-vn(2)-vrn(2)];  % wall point 2.2
                
                % Connect adjacent wall points
                line([wp11(1),wp12(1)],[wp11(2),wp12(2)], 'Color', [0,0,0]);
                line([wp21(1),wp22(1)],[wp21(2),wp22(2)], 'Color', [0,0,0]);
                   
            end
            text(obj.nodes(1)-5,obj.nodes(2)+5,'E');
        end         
    end      
end

