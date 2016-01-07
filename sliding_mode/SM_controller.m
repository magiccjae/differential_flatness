function output = SM_controller(input,P)

z_r     = input(1);
zdot_r  = input(2);
zddot_r = input(3);
z       = input(4);
zdot    = input(5);
t       = input(6);

% Initialize Integrator
persistent nu;
persistent e_prior_;
if t == 0
    nu      = 0;
    e_prior_ = 0;
end

% Define error
e    = z - z_r;
edot = zdot - zdot_r;

% Update integrator
nu = nu + (e+e_prior_)*P.Ts/2; % Eqn 7
e_prior_ = e;

s = edot + P.alpha*e + P.lambda*nu;  % Eqn 6
Fg = ground_effect(z); % Eqn 2/4
u = P.mass*P.gravity - Fg + P.mass*(zddot_r - P.alpha*edot - P.lambda*e) - P.Gamma*sat(s,P.epsilon); % Eqn 9

output = u;
end

function out=sat(in,epsilon)

if in >= epsilon,
    out = 1;
elseif in <= -epsilon,
    out = -1;
else
    out = in/epsilon;
end
end
