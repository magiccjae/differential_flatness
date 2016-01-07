% params
clear
P.Ts = 0.01;
times   = [1 50 50];
heights = [0 0.5 0];
%times = [4,4,4,4,4,4,4,4];
%heights = [0.2,0.4,0.6,0.7,0.6,0.4,0.2,0];
%heights = [1,2,1,0];

% Create step function for simulink altitude sequence

commanded_times = sort([0, cumsum(times(1:end-1))-P.Ts, cumsum(times)]);
tmp = [heights;heights];
commanded_altitude = tmp(:)';
P.altitude_sequence = [commanded_times;commanded_altitude]';

% % Mapping from z_step_input to z_reference
%  % pg 205 A. Tracking Control for Stepwise Altitude
%  P.T_model = 1;
%  P.wn      = 2*pi;
%  P.zeta    = 1;
%  % Eqn 5
%  P.tf_1 = tf(1,[P.T_model,1]);
%  P.tf_2 = tf([P.wn^2,0,0],[1,2*P.zeta*P.wn,P.wn^2]);
% 
% % Integral sliding mode controller
  P.alpha   = 1.55;
  P.epsilon = 0.2;
  P.Gamma   = 0.312;
%  
% % Phase-lead filter
% P.tau = 0.05;
% P.tau_m = 0.002; 
% P.T_m = 0.2; 
% 
 P.mass = 0.208; 
 P.gravity = 9.81; 
 P.lambda = 0.707;%1;

% 
 P.d_stdv = 0.04;
 P.d_bias = 0.12;
 %P.d_stdv = 0.0;
 %P.d_bias = 0;
 max(abs(randn(1000,1)*P.d_stdv)) + P.d_bias;
 

%steps = ceil((P.h_max-P.h0)/P.delta_h);
%times = 0:(2*steps+1)*P.tau;
%times = sort([times times(2:end-1)-P.Ts]);
%heights = P.h0:P.delta_h:P.delta_h

%altitude_commands = [0, 0; 14.99, 0; 15, 0.2; 14.99, 0.2; 15, 0.4; 24.99, 0.4; 25, 0.6; 35, 0.6];
