classdef Area < handle
    %AREA class
    %   Describes the testing area and its basic elements
    
    properties
        size;
        feeder_pos = [0, 0];
        nest_pos = [0, 0];
    end
    
    methods
        function obj = Area(size_x, size_y)
            obj.size = [size_x, size_y];
        end
    end
    
end

