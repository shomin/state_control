function [pd_cmd,  curr_state] = xyz_traj(curr_state, quad, gains, traj)
%function [pd_cmd curr_state] = xyz_traj (curr_state, quad, gains, target)

    %Trajectory controller with integral gain
    
    max_asin = sin(20*pi/180);
    max_thint=50;
    max_xyint=0.4;
    pd_cmd = asctec_PDCmd('empty');

    

    
    %gotta deal with this still
    use_vicon_rpy=0;
    
    
    
    %---------------   
    
    kp_x = gains.kp_x;
    kd_x = gains.kd_x;
    ki_x = gains.ki_x;
    
    kp_y = gains.kp_y;
    kd_y = gains.kd_y;
    ki_y = gains.ki_y;
    
    kp_z = gains.kp_z;
    kd_z = gains.kd_z;
    ki_z = gains.ki_z;
    
    % traj is in form [x   y   z   psi   time]
    
    timer=curr_state.state_timer;
    
    traj_time = traj(:,5);
    
    ind = find(traj_time<=timer,1,'last');
    if(isempty(ind))
        ind=1;
    end
    
    x_des=traj(ind,1);
    y_des=traj(ind,2);
    z_des=traj(ind,3);
    psides=traj(ind,4);

    
    curr_state.x_des = x_des;
    curr_state.y_des = y_des;
    curr_state.z_des = z_des;    
    curr_state.psi_des=psides;
    
    x_est=curr_state.x_est;
    y_est=curr_state.y_est;
    z_est=curr_state.z_est;
    xd_est=curr_state.xd_est;
    yd_est=curr_state.yd_est;
    zd_est=curr_state.zd_est;
    psi=curr_state.psi;
    phi=curr_state.phi;
    theta=curr_state.theta;

    th_trim = quad.th_trim;
    phi_trim = quad.phi_trim;
    theta_trim = quad.theta_trim;
    yaw_trim = quad.yaw_trim;
    
    delTint = curr_state.delT;

    ti = [x_des y_des z_des]-[x_est y_est z_est];
    li = sqrt(sum(ti.*ti));
    ti = ti./li;
    
    if(ind~=length(traj(:,5)))
        speed=sqrt(sum(((traj(ind+1,1:3)-traj(ind,1:3)).^2)))/(traj(ind+1,5)-traj(ind,5));
    else
        speed=sqrt(sum(((traj(ind,1:3)-traj(ind-1,1:3)).^2)))/(traj(ind,5)-traj(ind-1,5));
    end
    
    %speed=.1;
     
    xd_des = speed*ti(1);
    yd_des = speed*ti(2);
    zd_des = speed*ti(3);
        


    %calculate integral errors
    xybodyint = delTint * [cos(psi), sin(psi); -sin(psi), cos(psi)]*[x_des-x_est;y_des-y_est];
    zbodyint = delTint * (z_des-z_est);

    phi_int=curr_state.phi_int;
    th_int=curr_state.th_int;
    theta_int=curr_state.theta_int;

    phi_int = phi_int + ki_y*-xybodyint(2);
    theta_int = theta_int + ki_x*xybodyint(1);
    th_int = th_int + ki_z*zbodyint;

    th_int = max(min(th_int,max_thint),-max_thint);
    phi_int = max(min(phi_int,max_xyint),-max_xyint);
    theta_int = max(min(theta_int,max_xyint),-max_xyint);

    curr_state.phi_int = phi_int;
    curr_state.th_int = th_int;
    curr_state.theta_int = theta_int;        


    th_base = 88;

    
    th_cmd = th_base+kp_z*(z_des-z_est) + kd_z*(zd_des - zd_est)+th_int+th_trim;
    
    ux = kp_x*(x_des - x_est) + kd_x*(xd_des - xd_est);
    uy = kp_y*(y_des - y_est) + kd_y*(yd_des - yd_est);
    
    phides = ux*sin(psi) - uy*cos(psi)+phi_trim + phi_int;
    thetades = ux*cos(psi) + uy*sin(psi)+theta_trim + theta_int;
    
    phides = asin(max(min(phides,max_asin),-max_asin));
    thetades = asin(max(min(thetades,max_asin),-max_asin));
    
    %think about changing these
    pd_cmd.kp_pitch = 220;
    pd_cmd.kd_pitch = 18.9;
    pd_cmd.kp_roll = 220;
    pd_cmd.kd_roll = 18.9;
    pd_cmd.kd_yaw = 33;
    
    kp_yaw = 150;
    psi_diff = mod(psides - psi,2*pi);
    psi_diff = psi_diff - (psi_diff>pi)*2*pi;
    pd_cmd.yaw_delta = kp_yaw * (psi_diff)+yaw_trim;
    th_cmd = max(min(th_cmd,200),0);
    pd_cmd.thrust = round(th_cmd);


    if(use_vicon_rpy)
        pd_cmd.kp_pitch = 0;
        pd_cmd.kp_roll = 0;
        pd_cmd.roll = 0;
        pd_cmd.pitch = 0;
        pd_cmd.roll_delta = 220 * (phides-phi);
        pd_cmd.pitch_delta = 220 * (thetades-theta);
    else
        pd_cmd.roll = phides;
        pd_cmd.pitch = thetades;
    end
    
    if(ind==length(traj(:,5)))
        pd_cmd=[];
    end
    
end