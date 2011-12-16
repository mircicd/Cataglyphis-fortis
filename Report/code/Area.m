classdef Area < handle
    %AREA class
    %   Describes the testing area and its basic elements
    
    properties
        size;
        feeder = [0, 0];
        nest = [0, 0];
    end
    
    methods
        function obj = Area(size_x, size_y)
            obj.size = [size_x, size_y];
        end
        
        function plot_nest(obj)
            text(obj.nest(1)-5, obj.nest(2), 'N');
            rectangle('Position',[obj.nest(1)-10,obj.nest(2)-10,20,20]);
        end
        
        function plot_feeder(obj)
            text(obj.feeder(1)-5, obj.feeder(2), 'F');
            rectangle('Position',[obj.feeder(1)-10,obj.feeder(2)-10,20,20]);
        end
    end
    
end

