function output = diff_flat(y_traj,P)

pn = y_traj(1);
pe = y_traj(2);
pd = y_traj(3);
pn_vel = y_traj(4);
pe_vel = y_traj(5);
pd_vel = y_traj(6);
pn_acc = y_traj(7);
pe_acc = y_traj(8);
pd_acc = y_traj(9);
psi = y_traj(10);
psi_vel = y_traj(11);

x_r = [pn; pe; pd; pn_vel; pe_vel; pd_vel; psi];
% u_r = [pn_acc; pe_acc; pd_acc+P.g; psi_vel];

u_r = [pn_acc; pe_acc; pd_acc-P.g; psi_vel];

output = [u_r; x_r];

%     position = y_traj(1,1:end);
%     velocity = y_traj(2,1:end);
%     acceleration = y_traj(3,1:end);
%     angular = y_traj(4,1:end);
% 
%     x_r = [position(1,1); position(1,2); position(1,3); velocity(1,1); velocity(1,2); velocity(1,3); angular(1,1)];
%     u_r = [acceleration(1,1); acceleration(1,2); acceleration(1,3)-P.g; angular(1,2)];

end