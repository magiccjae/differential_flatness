function drawTrajectory(x_r,P)
    pn = x_r(5);
    pe = x_r(6);
    pd = x_r(7);
    
    persistent trajectory_handle;
    
    figure(5); hold on;
    scatter3(pn,pe,pd);
    xlim([-5 5]);
    ylim([-5 5]);
    zlim([-3 3]);
    

end