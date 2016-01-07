function y = attitude_controller(uu,P)
%
% attitude controller for hexacopter
%

% process inputs
thrust_c   = uu(1);  % commanded thrust (thrust)
roll_c     = uu(2);  % commanded roll (rad)
pitch_c    = uu(3);  % commanded pitch (rad)
yaw_rate_c = uu(4);  % commanded yaw_rate (rad/s)

NN = 4;
% pn    = uu(1+NN);  % inertial North position
% pe    = uu(2+NN);  % inertial East position
% pd    = uu(3+NN);  % inertial Down position
% u     = uu(4+NN);  % velocity in North direction
% v     = uu(5+NN);  % velocity in East direction
% w     = uu(6+NN);  % velocity in Down direction
phi   = uu(7+NN);  % roll angle
theta = uu(8+NN);  % pitch angle
% psi   = uu(9+NN);  % yaw angle
% p     = uu(10+NN); % body frame roll rate
% q     = uu(11+NN); % body frame pitch rate
r     = uu(12+NN); % body frame yaw rate

NN = NN+12;
t = uu(1+NN);   % time

% define PID loops
persistent pid_roll;
persistent pid_pitch;
persistent pid_yaw_rate;

% Initialize autopilot
if t==0
    % Initialize PID loops
    pid_roll = SimplePID('pid_roll', ...
        P.a_gains.Kp_roll, P.a_gains.Ki_roll, P.a_gains.Kd_roll, ...
        P.Ts, P.tau, P.T_phi_max);
    pid_pitch = SimplePID('pid_pitch', ...
        P.a_gains.Kp_pitch, P.a_gains.Ki_pitch, P.a_gains.Kd_pitch, ...
        P.Ts, P.tau, P.T_theta_max);
    pid_yaw_rate = SimplePID('pid_yaw_rate', ...
        P.a_gains.Kp_yaw_rate, P.a_gains.Ki_yaw_rate, P.a_gains.Kd_yaw_rate, ...
        P.Ts, P.tau, P.T_psi_max);
end

% Attitude control
T_phi   = pid_roll.computeCommand(roll_c, phi); 
T_theta = pid_pitch.computeCommand(pitch_c, theta);   
T_psi   = pid_yaw_rate.computeCommand(yaw_rate_c, r);
F       = thrust_c;

% control outputs
delta = [F; T_phi; T_theta; T_psi];
% delta = [39; 0; 0; 0];
y = [delta];

end