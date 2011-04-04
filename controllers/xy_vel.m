function [pd_cmd curr_state] = xy_vel(curr_state, quad, gains, xy, speed)
%function pd_cmd = xy_vel(curr_state, quad, gains, xy, vel)

    pd_cmd = asctec_PDCmd('empty');

    %hardcoded stuff
    max_asin = sin(50*pi/180);
    maxthcmd = 180;
    min_error = .15;
    
    pd_cmd.kp_pitch = 126.8;
    pd_cmd.kd_pitch = 18;
    pd_cmd.kp_roll = 126.8;
    pd_cmd.kd_roll = 18;
    pd_cmd.kd_yaw = 18;

    kp_yaw = 55;
    
    
    ti = [xy(1) xy(2)]-[curr_state.x_des curr_state.y_des];
    li = sqrt(sum(ti.*ti));
    ti = ti./li;
    ni = [-ti(2),ti(1)];

    gamma = atan2(ti(2),ti(1));

    e = [curr_state.x_est,curr_state.y_est] - xy;
    vel = [curr_state.xd_est,curr_state.yd_est];


    kp_x = gains.kp_x;
    kd_x = gains.kd_x;
    kp_y = gains.kp_y;
    kd_y = gains.kd_y;
    kp_z = gains.kp_z;
    kd_z = gains.kd_z;
    psi = curr_state.psi;

    
    th_trim = quad.th_trim;
    phi_trim = quad.phi_trim;
    theta_trim = quad.theta_trim;
    yaw_trim = quad.yaw_trim;

    
    ut = kd_x*(speed - sum(vel.*ti));
    un = kp_y*(-sum(e.*ni)) + kd_y*(-sum(vel.*ni));

    z_des=curr_state.z_des;
    z_est=curr_state.z_est;
    zd_est = curr_state.zd_est;
    
    zd_des=0;

    th_cmd = 88.0+kp_z*(z_des-z_est) + kd_z*(zd_des - zd_est)+th_trim;


    phides = ut*sin(psi-gamma) - un*cos(psi-gamma)+phi_trim;
    thetades = ut*cos(psi-gamma) + un*sin(psi-gamma)+theta_trim;

    phides = asin(max(min(phides,max_asin),-max_asin));
    thetades = asin(max(min(thetades,max_asin),-max_asin));





    psi_diff = mod(curr_state.psi_des - psi,2*pi);
    psi_diff = psi_diff - (psi_diff>pi)*2*pi;
    pd_cmd.yaw_delta = kp_yaw * (psi_diff)+yaw_trim;

    th_cmd = max(min(th_cmd,maxthcmd),0);
    pd_cmd.thrust = round(th_cmd);
    pd_cmd.roll = phides;
    pd_cmd.pitch = thetades;
    
    if(norm(e)<min_error)
        pd_cmd=[];
        curr_stat.x_des=xy(1);
        curr_stat.y_des=xy(2);
    end

end


            