function pd_cmd = hover_at_xyz(curr_state, quad, gains, xyz_and_psi)
%function pd_cmd = hover_at_xyz(curr_state, quad, gains, xyz)


    %hardcoded stuff
    max_asin = sin(50*pi/180);
    maxthcmd = 180;
    
    xd_des = 0; 
    yd_des=0; 
    zd_des=0;
    
    pd_cmd.kp_pitch = 130;%126.8;
    pd_cmd.kd_pitch = 18.9;
    pd_cmd.kp_roll = 130;%126.8;
    pd_cmd.kd_roll = 18.9;
    pd_cmd.kd_yaw = 33;
    
    pd_cmd.r_des = 0;
    kp_yaw = 150;
    
    
    %pulling the normal gains
    kp_x = gains.kp_x;
    kd_x = gains.kd_x;
    kp_y = gains.kp_y;
    kd_y = gains.kd_y;
    kp_z = gains.kp_z;
    kd_z = gains.kd_z;
    
    %target from xyz argument
    x_des = xyz_and_psi(1);
    y_des = xyz_and_psi(2);
    z_des = xyz_and_psi(3);
    
    if(length(xyz_and_psi)==3)
        psi_des=0;
    else
        psi_des = xyz_and_psi(4);
    end

    %current position and speed from curr_state
    x_est=curr_state.xyz_est(1);
    y_est=curr_state.xyz_est(2);
    z_est=curr_state.xyz_est(3);
    
    xd_est=curr_state.xyzd_est(1);
    yd_est=curr_state.xyzd_est(2);
    zd_est=curr_state.xyzd_est(3);
    
    %phi = curr_state.phi;  %Don't need current phi for controller
    %theta = curr_state.theta;   %Don't need current theta for controller
    
    psi = curr_state.psi;
    
    %trims from the quadrotor-specific argurment
    th_trim = quad.th_trim;
    phi_trim = quad.phi_trim;
    theta_trim = quad.theta_trim;
    yaw_trim = quad.yaw_trim;
    
    
    
    
    
    th_cmd = 88.0+kp_z*(z_des-z_est) + kd_z*(zd_des - zd_est)+th_trim;
    ux = (kp_x*(x_des - x_est) + kd_x*(xd_des - xd_est));
    uy = (kp_y*(y_des - y_est) + kd_y*(yd_des - yd_est));

    phides = ux*sin(psi) - uy*cos(psi)+phi_trim;
    thetades = ux*cos(psi) + uy*sin(psi)+theta_trim;

    phides = asin(max(min(phides,max_asin),-max_asin));
    thetades = asin(max(min(thetades,max_asin),-max_asin));

    th_cmd = max(min(th_cmd,maxthcmd),0);
    pd_cmd.thrust = round(th_cmd);
    pd_cmd.roll = phides;
    pd_cmd.pitch = thetades;
    
    psi_diff = mod(psi_des - psi,2*pi);
    psi_diff = psi_diff - (psi_diff>pi)*2*pi;
    pd_cmd.yaw_delta = kp_yaw * (psi_diff)+yaw_trim;

end