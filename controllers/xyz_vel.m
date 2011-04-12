function [pd_cmd,  curr_state] = xyz_vel (curr_state, quad, gains, target, speed, accelrate)
%function [pd_cmd curr_state] = xyz_vel (curr_state, quad, gains, target, speed)

    %THIS INCLUDES THE PARALLEL TRACKING ERROR AND INTEGRAL FEEDBACK
    %this is an x-y-z velocity type controller
    %ti is the tangent vector
    %ni is the normal vector in the
    
    max_asin = sin(50*pi/180);
    max_thint=50;
    max_xyint=0.4;
    pd_cmd = asctec_PDCmd('empty');

    
    if(curr_state.first_run_in_state)
        curr_state.first_run_in_state=0;
        startpose=[curr_state.x_est curr_state.y_est curr_state.z_est];
        curr_state.startpose=startpose;
    else
        startpose=curr_state.startpose;
    end

    %---------------
    %deal with these
    

    use_vicon_rpy=1;
    
    
    
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
    
    if(length(target)==3)
        target(4)=curr_state.psi_des;
    end

    
    %find tangent line and length
    ti = target(1:3)-startpose;
    li = sqrt(sum(ti.*ti));
    ti = ti./li;
    
    psides=target(4);
    
    psi=curr_state.psi;

    th_trim = quad.th_trim;
    phi_trim = quad.phi_trim;
    theta_trim = quad.theta_trim;
    yaw_trim = quad.yaw_trim;
    
    x_est=curr_state.x_est;
    y_est=curr_state.y_est;
    z_est=curr_state.z_est;
    
    xd_est=curr_state.xd_est;
    yd_est=curr_state.yd_est;
    zd_est=curr_state.zd_est;
    
    phi=curr_state.phi;
    theta=curr_state.theta;

    if(isempty(accelrate))
        %expected_time = li/speed;

        timer=curr_state.state_timer;
        
        x_des = startpose(1) +  timer * speed * ti(1);
        y_des = startpose(2) +  timer * speed * ti(2);
        z_des = startpose(3) +  timer * speed * ti(3);
     
        xd_des = speed*ti(1);
        yd_des = speed*ti(2);
        zd_des = speed*ti(3);
        
      
    else
        timer=curr_state.state_timer;

        t_ramp = speed/accelrate;
        d_ramp = (speed^2) / (accelrate*2);
        
        if(li<(2*d_ramp))
            
            %just ramp up then ramp down immediately cause it is too short
            t_miniramp = sqrt(2*(li/2)/accelrate);
            %expectedtime = 2*t_miniramp;
            
            if(timer<t_miniramp)
                             
                voft = accelrate * (timer);
                doft = accelrate * ((timer)^2)/2;
                
            else
                t_after = timer-t_miniramp;
                
                voft = (t_miniramp * accelrate) - (accelrate * t_after);
                doft = li/2 + (t_miniramp * accelrate * (t_after))  - (accelrate * (t_after)^2/2);
            end

        else
            %there is some stall time in the middle where we hold speed
            d_middle = li-2*d_ramp;
            t_middle = d_middle/speed;
            %expectedtime = 2*t_ramp + t_middle;
            
            if(timer<t_ramp)
                
                voft = accelrate * (timer);
                doft = accelrate * (timer)^2/2;
                
            elseif(timer<(t_ramp + t_middle))
                t_after = timer - t_ramp;
                voft = speed;
                doft = d_ramp + voft*t_after;
            else
                t_after = timer - t_ramp - t_middle;
                voft = speed - accelrate*t_after;
                doft = d_ramp + d_middle + speed*t_after - accelrate*(t_after^2) /2;
            end
            
        end
        

        
        x_des = startpose(1) +  doft * ti(1);
        y_des = startpose(2) +  doft * ti(2);
        z_des = startpose(3) +  doft * ti(3);
        
        xd_des = voft*ti(1);
        yd_des = voft*ti(2);
        zd_des = voft*ti(3);
    end
    

    
    curr_state.x_des = x_des;
    curr_state.y_des = y_des;
    curr_state.z_des = z_des;
    
        delTint = curr_state.delT;



        %associate integral errors with body and not world
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

    
%     if(~isempty(th_base))
%         th_base = th_base;
%     else
        th_base = 88;
%    end
    
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

    use_vicon_rpy=0;
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
    
    curr_state.phi_des=phides;
    curr_state.theta_des=thetades;
    
    if(norm([x_des y_des z_des] - target(1:3))<.01)
        pd_cmd=[];
    end
end