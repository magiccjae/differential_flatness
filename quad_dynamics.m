function [sys,x0,str,ts,simStateCompliance] = quad_dynamics(t,x,u,flag,P)

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(P);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u,P);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(P)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 12;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 19; %12;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [P.pn0; P.pe0; P.pd0; P.u0; P.v0; P.w0; P.phi0; P.theta0; P.psi0; P.p0; P.q0; P.r0];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%

% Double Checked March 4
function sys=mdlDerivatives(t,x,uu,P)

    pn      = x(1);
    pe      = x(2);
    pd      = x(3);
    u       = x(4);
    v       = x(5);
    w       = x(6);
    phi     = x(7);
    theta   = x(8);
    psi     = x(9);
    p       = x(10);
    q       = x(11);
    r       = x(12);
    F       = uu(1);
    T_phi   = uu(2);
    T_theta = uu(3);
    T_psi   = uu(4);
    
    % state derivative vector
    x_dot = zeros(12,1);
    
    % calculate sines and cosines once for convenience and efficiency
    cp = cos(phi);
    sp = sin(phi);
    ct = cos(theta);
    st = sin(theta);
    tt = tan(theta);
    cs = cos(psi);
    ss = sin(psi);
    
     % translational kinematics model
    tkm = [ct*cs sp*st*cs-cp*ss cp*st*cs+sp*ss; 
           ct*ss sp*st*ss+cp*cs cp*st*ss-sp*cs;
           -st   sp*ct          cp*ct];
       
    x_dot(1:3) = tkm*[u; v; w];
    
    % translational dynamics model
    tdm1 = [r*v-q*w; 
            p*w-r*u; 
            q*u-p*v];
       
    tdm2 = [-P.gravity*st; 
             P.gravity*ct*sp; 
             P.gravity*ct*cp];
       
    x_dot(4:6) = tdm1 + tdm2 + (1/P.mass)*[-P.mu*u; -P.mu*v; -F];
    
    % rotational kinematic model
    rkm = [1 sp*tt cp*tt;
           0 cp    -sp;
           0 sp/ct cp/ct];
       
    x_dot(7:9) = rkm*[p; q; r];
    
    % rotational dynamics model
    rdm1 = [(P.Jyy-P.Jzz)/P.Jxx*q*r;
            (P.Jzz-P.Jxx)/P.Jyy*p*r;
            (P.Jxx-P.Jyy)/P.Jzz*p*q];
        
    rdm2 = [1/P.Jxx 0       0;
            0       1/P.Jyy 0;
            0       0       1/P.Jzz];
        
    x_dot(10:12) = rdm1 + rdm2*[T_phi; T_theta; T_psi];

sys = x_dot;
% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
    pn      = x(1);
    pe      = x(2);
    pd      = x(3);
    u       = x(4);
    v       = x(5);
    w       = x(6);
    phi     = x(7);
    theta   = x(8);
    psi     = x(9);
    p       = x(10);
    q       = x(11);
    r       = x(12);
    
    % calculate sines and cosines once for convenience and efficiency
    cp = cos(phi);
    sp = sin(phi);
    ct = cos(theta);
    st = sin(theta);
    tt = tan(theta);
    cs = cos(psi);
    ss = sin(psi);
    
     % translational kinematics model
    tkm = [ct*cs sp*st*cs-cp*ss cp*st*cs+sp*ss;
           ct*ss sp*st*ss+cp*cs cp*st*ss-sp*cs;
           -st   sp*ct          cp*ct];
       
    x_diff = [pn; pe; pd; tkm*[u; v; w]; psi];

    
sys = [x; x_diff];
% sys = x;

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
