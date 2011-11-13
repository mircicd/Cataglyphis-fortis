classdef Channel < handle
    %CHANNEL Class
    %   Describes an n-leg channel
    
    properties
        n_of_legs; % number of legs
        entrance; % coordinates of the entrance to the channel
        exit; % coordinates of the exit of the channel
        nodes; % Nodes stored in a vector
    end
    
    methods
        
        function obj = Channel(varargin)
            % Constructor
            % Provides inputs from 1 leg up to 3 legs
            % Inputs are nodes
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
            % Plots the channel as a line            
            for i=1:2:2*obj.n_of_legs
                line([obj.nodes(i),obj.nodes(i+2)],[obj.nodes(i+1),obj.nodes(i+3)], 'Color', [0,0,0]);       
            end
            text(obj.nodes(1)-5,obj.nodes(2)-5,'Entrance');
            %text(obj.nodes(2*obj.n_of_legs+1)-5,obj.nodes(2*obj.n_of_legs+2)-5,'Exit');
        end  
        
    end  
    
end

