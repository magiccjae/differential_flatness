function drawAircraft(uu,V,F,patchcolors)

    % process inputs to function
    pn       = uu(1);  % inertial North position     
    pe       = uu(2);  % inertial East position
    pd       = uu(3);           
    u        = uu(4);       
    v        = uu(5);       
    w        = uu(6);       
    phi      = uu(7);  % roll angle         
    theta    = uu(8);  % pitch angle     
    psi      = uu(9);  % yaw angle     
    p        = uu(10); % roll rate
    q        = uu(11); % pitch rate     
    r        = uu(12); % yaw rate    
    x_c      = uu(13); % x command 
    y_c      = uu(14); % y command
    z_c      = uu(15); % z command
    yaw_c    = uu(16); % yaw command
    t        = uu(17); % time

%     yaw_c    = uu(22); % yaw command
%     t        = uu(24); % time

    % define persistent variables 
    persistent spacecraft_handle;
    persistent commanded_position_handle;
    persistent center;
    view_range = 20;
    close_enough_tolerance = 0.9;
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf;
        grid on;
        hold on;
        spacecraft_handle = drawSpacecraftBody(V,F,patchcolors,...
                                               pn,pe,pd,phi,theta,psi,...
                                               [],'normal');
        commanded_position_handle = drawCommandedPosition(x_c,y_c,z_c,yaw_c,...
                                               []);
        title('Spacecraft')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the vieew angle for figure
        center = [pe;pn;pd];
        %axis([center(1)-view_range,center(1)+view_range,
        %      center(2)-view_range,center(2)+view_range,
        %      center(3)-view_range,center(3)+view_range]);
        axis([center(1)-view_range,center(1)+view_range, ...
              center(2)-view_range,center(2)+view_range, ...
              center(3)-view_range,center(3)+view_range]);
        hold on
        
    % at every other time step, redraw base and rod
    else
        
        %figure(1);
        pos = [pe;pn;pd];
        close_enough_tolerance*[view_range;view_range;view_range] - abs(pos - center);
        if (min(close_enough_tolerance*[view_range;view_range;view_range] - abs(pos-center)) < 0)
            center = pos;
        end
        
        axis([center(1)-view_range,center(1)+view_range, ...
              center(2)-view_range,center(2)+view_range, ...
              center(3)-view_range,center(3)+view_range]);
        drawSpacecraftBody(V,F,patchcolors,...
                           pn,pe,pd,phi,theta,psi,...
                           spacecraft_handle);
        drawCommandedPosition(x_c,y_c,z_c,yaw_c,...
                           commanded_position_handle);
    end
end

  
%=======================================================================
% drawSpacecraft
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawSpacecraftBody(V,F,patchcolors,...
                                     pn,pe,pd,phi,theta,psi,...
                                     handle,mode)
  V = rotate(V', phi, theta, psi)';  % rotate spacecraft
  V = translate(V', pn, pe, pd)';  % translate spacecraft
  % transform vertices from NED to XYZ (for matlab rendering)
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  V = V*R;
  
  if isempty(handle),
  handle = patch('Vertices', V, 'Faces', F,...
                 'FaceVertexCData',patchcolors,...
                 'FaceColor','flat',...
                 'EraseMode', mode);
  else
    set(handle,'Vertices',V,'Faces',F);
    drawnow
  end
end

function handle = drawCommandedPosition(x_c, y_c, z_c, yaw_c,...
                                     handle)
  V = translate([0; 0; 0], x_c, y_c, z_c)';  % translate spacecraft
  % transform vertices from NED to XYZ (for matlab rendering)
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  V = V*R;
  
  if isempty(handle),
  handle = plot3(V(1),V(2),V(3),'*','markersize',10);
  else
    set(handle,'xdata',V(1),'ydata',V(2),'zdata',V(3));
    drawnow
  end
end

%%%%%%%%%%%%%%%%%%%%%%%
function XYZ=rotate(XYZ,phi,theta,psi)
  % define rotation matrix
  R_roll = [...
          1, 0, 0;...
          0, cos(phi), -sin(phi);...
          0, sin(phi), cos(phi)];
  R_pitch = [...
          cos(theta), 0, sin(theta);...
          0, 1, 0;...
          -sin(theta), 0, cos(theta)];
  R_yaw = [...
          cos(psi), -sin(psi), 0;...
          sin(psi), cos(psi), 0;...
          0, 0, 1];
  R = R_yaw*R_pitch*R_roll;
  % rotate vertices
  XYZ = R*XYZ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function XYZ = translate(XYZ,pn,pe,pd)
  XYZ = XYZ + repmat([pn;pe;pd],1,size(XYZ,2));
end

  