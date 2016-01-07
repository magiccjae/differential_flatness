% P.a_gains = attitude controller gains
% P.p_gains = position controller gains

%% Attitude controller gains

% From Cyphy paper, they suggest that the MikroKopter Quad has the
% following parameters for pitch and roll attitude response:
% wn_pitch = 5.39, zeta = 1
% wn_roll  = 5.21, zeta = 1

% Roll loop
    phi_max = 15*pi/180; % Max error
    P.T_phi_max = 2;     % Max torque available (saturation limit)

    % Choose damping coefficient
    z_roll = 0.7071;

    % Choose natural frequency
    wn_roll = sqrt(P.T_phi_max/phi_max/P.Jxx);

    % Choose gains
    P.a_gains.Kp_roll = P.T_phi_max/phi_max;
    P.a_gains.Ki_roll = 0;
    P.a_gains.Kd_roll = 2*wn_roll*z_roll*P.Jxx;

% Pitch loop
    theta_max = 15*pi/180; % Max error
    P.T_theta_max = 2;     % Max torque available (saturation limit)

    % Choose damping coefficient
    z_pitch = 0.8071;

    % Choose natural frequency
    wn_pitch = sqrt(P.T_theta_max/theta_max/P.Jyy);

    % Choose gains
    P.a_gains.Kp_pitch = P.T_theta_max/theta_max;
    P.a_gains.Ki_pitch = 0;
    P.a_gains.Kd_pitch = 2*wn_pitch*z_pitch*P.Jyy;

% Yaw rate loop
    psi_dot_max = 20*pi/180;
    P.T_psi_max = 1;   

    % Choose gains
    P.a_gains.Kp_yaw_rate = P.T_psi_max/psi_dot_max;
    P.a_gains.Ki_yaw_rate = 0;
    P.a_gains.Kd_yaw_rate = 0;

%% Position controller gains

% Altitude loop
    z_max = 1;     % Max error
    P.F_max = 40; % Max force available (saturation limit)

    % Choose damping coefficient
    z_z = 0.7071;

    % Choose natural frequency
    wn_z = sqrt(P.F_max/z_max/P.mass);

    % Choose gains
    P.p_gains.Kp_z = P.F_max/z_max;
    P.p_gains.Ki_z = 0;
    P.p_gains.Kd_z = 2*wn_z*z_z*P.mass;
    
    P.p_gains.z_ff = P.mass*P.gravity;

% x loop
    bsf_x = 15; % bandwidth seperation factor
    wn_x  = wn_pitch/bsf_x;
    z_x   = 0.7071;

    P.p_gains.Kp_x = wn_x^2/P.gravity;
    P.p_gains.Ki_x = 0;
    P.p_gains.Kd_x = 2*z_x*wn_x/P.gravity;

    P.pitch_c_max = theta_max;

% y loop
    bsf_y = 15; % bandwidth seperation factor
    wn_y  = wn_roll/bsf_y;
    z_y   = 0.7071;

    P.p_gains.Kp_y = wn_y^2/P.gravity;
    P.p_gains.Ki_y = 0;
    P.p_gains.Kd_y = 2*z_y*wn_y/P.gravity;

    P.roll_c_max = phi_max;

% Yaw loop
    psi_max = 20*pi/180;            % Max error
    P.yaw_rate_c_max = psi_dot_max; % Max yaw_rate available (saturation limit)

    % Choose gains
    P.p_gains.Kp_yaw = P.yaw_rate_c_max/psi_max;
    P.p_gains.Ki_yaw = 0;
    P.p_gains.Kd_yaw = 0;

