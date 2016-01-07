param

time = 20;
figure(1); hold on; grid on;
for i=1:0.1:time
    y_traj = trajectory(i,P);
%     scatter(y_traj(1,1),y_traj(1,2));
    scatter3(y_traj(1,1),y_traj(1,2),y_traj(1,3));
    xlim([-3 3]);
    ylim([-3 3]);
    zlim([0 3]);    
end

% [u_r,x_r] = diff_flat(y_traj,P);