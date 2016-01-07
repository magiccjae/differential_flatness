clear; clc; close all;

P.Ts = 0.01;

% add all subdirectories to current path
addpath(genpath(pwd));

P.takeoff_time = 10;
P.height = -5; %-1.5;     % desired height
P.one_lap = 10;   % expected time for one lap
P.omega = 2*pi/P.one_lap;
P.radius = 5;
P.g = 9.81;     % gravity

% physical parameters of airframe
P.gravity = 9.81;
P.mass    = 3.81;
P.Jxx     = 0.060224;
P.Jyy     = 0.122198;
P.Jzz     = 0.132166;

P.L  = 0.25;
P.k1 = 1; %2.98*10e-6;
P.k2 = 1; %2.98*10e-6;
P.mu = 1;

% first cut at initial conditions
P.pn0    = 0;  % initial North position
P.pe0    = 0;  % initial East position
P.pd0    = 0;  % initial Down position (negative altitude)
P.u0     = 0;  % initial velocity along body x-axis
P.v0     = 0;  % initial velocity along body y-axis
P.w0     = 0;  % initial velocity along body z-axis
P.phi0   = 0;  % initial roll angle
P.theta0 = 0;  % initial pitch angle
P.psi0   = 0;  % initial yaw angle
P.p0     = 0;  % initial body frame roll rate
P.q0     = 0;  % initial body frame pitch rate
P.r0     = 0;  % initial body frame yaw rate

% sketch parameters
P.nRotors = 4;
sketch_copter;

% compute gains
compute_gains;

% time constant for dirty derivative filter
P.tau = 0.15;

% % state space design
A = [zeros(3) eye(3) zeros(3,1);
     zeros(3) zeros(3) zeros(3,1);
     zeros(1,3) zeros(1,3) 0];

B = [zeros(3) zeros(3,1);
     eye(3) zeros(3,1);
     zeros(1,3) 1];

C = [eye(3) zeros(3,4);
     zeros(1,6) 1];

% Q = diag([10 10 10 100 100 100 10]);
Q = C'*C;
R = 1*eye(4);

[K,S,E] = lqr(A,B,Q,R);

P.K = K;
