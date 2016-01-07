function y_traj = testing_trajectory(t,P)

if(t <= P.takeoff_time)
    pn = 0;
    pe = 0;
    pd = P.height/P.takeoff_time*t; %P.height;
    pn_vel = 0;
    pe_vel = 0;
    pd_vel = P.height/P.takeoff_time; %0;
    pn_acc = 0;
    pe_acc = 0;
    pd_acc = 0;
    psi = 0;
    psi_vel = 0;
    psi_acc = 0;
else
    pn = 0;
    pe = 0;
    pd = P.height;
    pn_vel = 0;
    pe_vel = 0;
    pd_vel = 0;
    pn_acc = 0;
    pe_acc = 0;
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