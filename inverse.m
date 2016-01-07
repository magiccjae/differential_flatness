function v_command = inverse(u, P)

    % input: 1-4 = u(inputs), 5-17 = x(states)
    
    up1 = u(1);
    up2 = u(2);
    up3 = u(3);
    up4 = u(4);
    
    phi = u(11);
    theta = u(12);
    psi = u(13);
    p = u(14);
    q = u(15);
    r = u(16);
    t = u(17);  % time
    
    R_psi = [cos(psi) sin(psi) 0;
             -sin(psi) cos(psi) 0;
             0 0 1];
    T_d = P.mass*sqrt(up1^2+up2^2+up3^2);
    
    w = R_psi'*[up1; up2; up3]*P.mass/(-T_d);
    
%     phi_d = asin(w(2));
%     theta_d = atan(-w(1)/w(3));
    phi_d = asin(-w(2));
    theta_d = atan(w(1)/w(3));
    
    R_angular = [1 sin(phi)*tan(theta) cos(phi)*tan(theta);
                 0 cos(phi) -sin(phi);
                 0 sin(phi)/cos(theta) cos(phi)/cos(theta)];
    angular_rate = R_angular*[p; q; r];
    
    r_d = cos(theta)/cos(phi)*up4-q*tan(phi);
%     persistent previous_theta
%     persistent previous_time
%     if t<P.Ts,
%         previous_theta = 0;
%         previous_time = 0;
%     end
%     theta_dot = 0;
%     if t-previous_time ~= 0
%         theta_dot = (theta_d-previous_theta)/(t-previous_time);
%     end
%     previous_time = t;
%     previous_theta = theta_d;
%     
%     r_d = angular_rate(3)*cos(theta_d)*cos(phi_d)-theta_dot*sin(phi_d);
    
    v_command = [T_d; phi_d; theta_d; r_d];
%     v_command = [T_d; 0; 0; 0];
%     v_command = [P.g*P.mass; 0; 0; 0];

end