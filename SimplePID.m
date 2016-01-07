classdef SimplePID < handle
    %SimplePID Provides basic PID loop control 
    %   Sample usage:
    %     pid = SimplePID(name,kp,ki,kd,Ts,tau,limit)
    %     u   = pid.computeCommand(y_c, y)
    
    % Todo: Option for passing in derivative directly
    
    properties
        KP = 0
        KD = 0
        KI = 0
        integrator = 0
        differentiator = 0
        y_d1 = 0
        error_d1 = 0
        name = ''
        Ts = 0.01
        tau = 5
        limit = 1
    end
    
    methods
        function PID = SimplePID(name,kp,ki,kd,Ts,tau,limit)
            PID.name  = name;
            PID.KP    = kp;
            PID.KI    = ki;
            PID.KD    = kd;
            PID.Ts    = Ts;
            PID.tau   = tau;
            PID.limit = limit;
            
        end
        
        function u = computeCommand(PID,y_c, y)
            
            dif_error_flag = 1;
            
            error = y_c - y;
            PID.integrator = PID.integrator + (PID.Ts/2)*(error + PID.error_d1);
          
            if dif_error_flag
               PID.differentiator = (2*PID.tau-PID.Ts)/(2*PID.tau+PID.Ts)*PID.differentiator ...
                   + 2/(2*PID.tau+PID.Ts)*(error - PID.error_d1);
               u_unsat = PID.KP * error + PID.KI * PID.integrator + PID.KD * PID.differentiator;
            else
               PID.differentiator = (2*PID.tau - PID.Ts)/(2*PID.tau + PID.Ts)*PID.differentiator...
                  + 2/(2*PID.tau + PID.Ts)*(y - PID.y_d1);
               u_unsat = PID.KP * error + PID.KI * PID.integrator - PID.KD * PID.differentiator;
            end
            
            PID.error_d1 = error;
            PID.y_d1 = y;
            
            u = PID.sat(u_unsat);
       
            % Integrator anti-windup
            if PID.KI~=0
                PID.integrator = PID.integrator + PID.Ts/PID.KI * (u - u_unsat);
            end
        end
        
        function out = sat(PID,in)
            if in > PID.limit
                out = PID.limit;
            elseif in < -PID.limit
                out = -PID.limit;
            else
                out = in;
            end
        end
        
    end
end

