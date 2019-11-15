classdef Wrist
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        innerD
        outerD
        num_notches
        notches
    end
    
    methods
        function obj = Wrist(innerD, outerD, num_notches, notches)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.innerD = innerD;
            obj.outerD = outerD;
            obj.num_notches = num_notches;
            obj.notches = notches;
        end
        
        function T = fkine(obj,q)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            deltaL = q(1);
            alpha = q(2);
            tau = q(3);
            
            k = zeros(obj.num_notches,1)
            
            T01 = [1,0,0,0; 0,1,0,0; 0,0,1,tau; 0,0,0,1];
            T12 = [cos(alpha), -sin(alpha), 0, 0; ...
                sin(alpha), cos(alpha),0,0;...
                0,0,1,0;...
                0,0,0,1];
            T02 = T01*T12;
            Tfinal = T02;
            for n = 1:obj.num_notches
                innerR = obj.innerD/2;
                yBar = innerR + ((obj.outerD - obj.innerD)/2);
                k = (deltaL)/(obj.notches(n).height*(innerR+ yBar) - deltaL*yBar);
                s = obj.notches(n).height/(1+yBar*k);
                
                notchT = [cos(k*s), 0, sin(k*s), (1-cos(k*s))/k;...
                    0, 1, 0, 0;...
                    -sin(k*s), 0, cos(k*s), sin(k*s)/k;...
                    0,0,0,1]
                
                distanceT = [1,0,0,0; 0,1,0,0; 0,0,1,obj.notches(i).distance; 0,0,0,1]
                
                Tfinal = Tfinal * notchT * distanceT;
            end
            
        end
    end
end
