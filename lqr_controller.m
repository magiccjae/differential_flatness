function u_tilde = lqr_controller(x_tilde,P)
    u_tilde = -P.K*x_tilde;
%     u_tilde = zeros(4,1);
end