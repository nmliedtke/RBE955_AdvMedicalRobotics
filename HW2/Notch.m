classdef Notch
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        height
        width
        distance% distance above notch to next notch
        orientation
    end
    
    methods
        function obj = Notch(height,width,distance,orientation)
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            obj.height = height;
            obj.width = width;
            obj.distance = distance;
            obj.orientation = orientation;
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

