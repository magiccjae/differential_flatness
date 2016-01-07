function y_traj = trajectory(t,P)

if(t <= P.takeoff_time)
    pn = 0;
    pe = 0;
    pd = P.height/P.takeoff_time*t;
    pn_vel = 0;
    pe_vel = 0;
    pd_vel = P.height/P.takeoff_time;
    pn_acc = 0;
    pe_acc = 0;
    pd_acc = 0;
    psi = 0;
    psi_vel = 0;
    psi_acc = 0;
else
    pn = P.radius*sin(P.omega*t);
    pe = P.radius*cos(P.omega*t);
    pd = P.height;
    pn_vel = P.radius*P.omega*cos(P.omega*t);
    pe_vel = -P.radius*P.omega*sin(P.omega*t);
    pd_vel = 0;
    pn_acc = -P.radius*(P.omega^2)*sin(P.omega*t);
    pe_acc = -P.radius*(P.omega^2)*cos(P.omega*t);
    pd_acc = 0;
    psi = 0;
    psi_vel = 0;
    psi_acc = 0;
end
% position = [pn pe pd];
% velocity = [pn_vel pe_vel pd_vel];
% acceleration = [pn_acc pe_acc pd_acc];
% angular = [psi psi_vel psi_acc];
% y_traj = [position; velocity; acceleration; angular];
y_traj = [pn; pe; pd; pn_vel; pe_vel; pd_vel; pn_acc; pe_acc; pd_acc; psi; psi_vel];
end