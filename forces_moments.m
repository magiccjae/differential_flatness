% forces_moments.m
%   Computes the forces and moments acting on the airframe. 

function out = forces_moments(uu, P)    
    
%     pn      = uu(1);
%     pe      = uu(2);
    pd      = uu(3);
%     u       = uu(4);
%     v       = uu(5);
%     w       = uu(6);
%     phi     = uu(7);
%     theta   = uu(8);
%     psi     = uu(9);
%     p       = uu(10);
%     q       = uu(11);
%     r       = uu(12);
    thrust  = uu(13);
    l       = uu(14);
    m       = uu(15);
    n       = uu(16);
    
    fz = thrust;  % + ground_effect(pd);
    
    forces_moments = [fz; l; m; n];
    out = forces_moments;

end

function out = ground_effect(pd)
    z = -pd;
    
    if z > 1
        out = 0;
        return;
    end
    
    if z < 0.2
        z = 0.2;
    end
    a =  -55.3516;
    b =  181.8265;
    c = -203.9874;
    d =   85.3735;
    e =   -7.6619;
    
    avg = 0.0;
    sig = 1.19;
    noise = sig*randn + avg;
    
    out = a*z*z*z*z + b*z*z*z + c*z*z + d*z + e + noise;

end

