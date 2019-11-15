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
        
        function maxStrain = calcMaxStrain(obj,q)
            deltaL = q(1);
            alpha = q(2);
            tau = q(3);
            
            innerR = obj.innerD/2
            outerR = obj.outerD/2
            yBar = innerR + ((obj.outerD - obj.innerD)/4)
            k = (deltaL)/(obj.notches(1).height*(innerR+ yBar) - deltaL*yBar)
            
            
            maxStrain = (k*(outerR-yBar))/(1+yBar*k);
            
            if maxStrain >= 0.08
                warning('Maximum Strain for NiTi has been calculated as exceeded')
            end
            % None of the q's in problem 2 exceed the maximum strain of
            % NiTi
            % A delta L of 2.65 mm exceeds the maximum recoverable strain
            % for NiTi
        end
        
        function Ts = fkine(obj,q)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            allDeltaL = q(1);
            alpha = q(2);
            tau = q(3);
            
            k = zeros(obj.num_notches,1);
            
            T01 = [1,0,0,0; 0,1,0,0; 0,0,1,tau; 0,0,0,1];
            T12 = [cosd(alpha), -sind(alpha), 0, 0; ...
                sind(alpha), cosd(alpha),0,0;...
                0,0,1,0;...
                0,0,0,1];
            T02 = T01*T12;
            Tfinal = T02;
            Ts = zeros(4,4,obj.num_notches*2 + 1);
            Ts(:,:,1) = T02;
            for n = 1:obj.num_notches
                deltaL = allDeltaL
                innerR = obj.innerD/2;
                yBar = innerR + ((obj.outerD - obj.innerD)/4);
                k = (deltaL)/(obj.notches(n).height*(innerR+ yBar) - deltaL*yBar);
                s = obj.notches(n).height/(1+yBar*k);
                
                if k == 0
                    
                    notchT = [1, 0, 0, 0;...
                        0, 1, 0, 0;...
                        0, 0, 1, s;...
                        0, 0, 0, 1];
                    
                else
                    notchT = [cos(k*s), 0, sin(k*s), (1-cos(k*s))/k;...
                    0, 1, 0, 0;...
                    -sin(k*s), 0, cos(k*s), sin(k*s)/k;...
                    0,0,0,1];
                end
                
                
                distanceT = [1,0,0,0; 0,1,0,0; 0,0,1,obj.notches(n).distance; 0,0,0,1];
                
                Tfinal = Tfinal * notchT;
                Ts(:,:,n*2) = Tfinal;
                Tfinal = Tfinal * distanceT;
                Ts(:,:,n*2+1) = Tfinal;
            end
            
        end
        
        
        
        function Ts = fkine2(obj,q)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            allDeltaL = q(1,:);
            alpha = q(2,1);
            tau = q(3,1);
            
            k = zeros(obj.num_notches,1);
            
            T01 = [1,0,0,0; 0,1,0,0; 0,0,1,tau; 0,0,0,1];
            T12 = [cosd(alpha), -sind(alpha), 0, 0; ...
                sind(alpha), cosd(alpha),0,0;...
                0,0,1,0;...
                0,0,0,1];
            T02 = T01*T12;
            Tfinal = T02;
            Ts = zeros(4,4,obj.num_notches*2 + 1);
            Ts(:,:,1) = T02;
            for n = 1:obj.num_notches
                deltaL = allDeltaL(n)
                innerR = obj.innerD/2;
                yBar = innerR + ((obj.outerD - obj.innerD)/4);
                k = (deltaL)/(obj.notches(n).height*(innerR+ yBar) - deltaL*yBar);
                s = obj.notches(n).height/(1+yBar*k);
                
                if k == 0
                    
                    notchT = [1, 0, 0, 0;...
                        0, 1, 0, 0;...
                        0, 0, 1, s;...
                        0, 0, 0, 1];
                    
                else
                    thetaN = obj.notches(n).orientation;
                    Ttemp1 = [cos(thetaN) -sin(thetaN) 0 0; sin(thetaN) cos(thetaN) 0 0; 0 0 1 0; 0 0 0 1];
                   arcT = [cos(k*s), 0, sin(k*s), (1-cos(k*s))/k;...
                    0, 1, 0, 0;...
                    -sin(k*s), 0, cos(k*s), sin(k*s)/k;...
                    0,0,0,1];
                
                    Ttemp2 = [cos(-thetaN) -sin(-thetaN) 0 0; sin(-thetaN) cos(-thetaN) 0 0; 0 0 1 0; 0 0 0 1];
                
                    notchT = Ttemp1 * arcT * Ttemp2;
    
                end
                
                
                distanceT = [1,0,0,0; 0,1,0,0; 0,0,1,obj.notches(n).distance; 0,0,0,1];
                
                Tfinal = Tfinal * notchT;
                Ts(:,:,n*2) = Tfinal;
                Tfinal = Tfinal * distanceT;
                Ts(:,:,n*2+1) = Tfinal;
            end
            
        end
  
    end
    
end

