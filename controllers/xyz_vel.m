function [pd_cmd curr_state] = xyz_vel (curr_state, quad, gains, target)

    %THIS INCLUDES THE PARALLEL TRACKING ERROR AND INTEGRAL FEEDBACK
    %this is an x-y-z velocity type controller
    %ti is the tangent vector
    %ni is the normal vector in the
    
    if(curr_state.first_run_in_state)
        curr_state.first_run_in_state=0;
        startpose=[curr_state.x_est curr_state.y_est curr_state.z_est];
    end
    
    %---------------
    %deal with psi_des;
    %---------------   
    
    kp_x = curr_state.kp_x;
    kd_x = curr_state.kd_x;
    ki_x = curr_state.ki_x;
    
    kp_y = curr_state.kp_y;
    kd_y = curr_state.kd_y;
    ki_y = curr_state.ki_y;
    
    kp_z = curr_state.kp_z;
    kd_z = curr_state.kd_z;
    ki_z = curr_state.ki_z;
    
    %find tangent line and length
    ti = target(:)-startpose;
    li = sqrt(sum(ti.*ti));
    ti = ti./li;

    
    if(isempty(accelrate))
        expected_time = li/speed;

        timer=curr_state.timer;
        
        x_des = startpose(1) +  timer * speed * ti(1);
        y_des = startpose(2) +  timer * speed * ti(2);
        z_des = startpose(3) +  timer * speed * ti(3);
     
        xd_des = speed*ti(1);
        yd_des = speed*ti(2);
        zd_des = speed*ti(3);
        
                
    else
        t_ramp = speed/accelrate;
        d_ramp = (speed^2) / (accelrate*2);
        
        if(li<(2*d_ramp))
            
            %just ramp up then ramp down immediately cause it is too short
            t_miniramp = sqrt(2*(li/2)/accelrate);
            expectedtime = 2*t_miniramp;
            
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
            expectedtime = 2*t_ramp + t_middle;
            
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
    
    
    if(j>1)
        delTint = timer(j)-timer(j-1);
    else
        delTint = 0;
    end
    
    
    if(useint)
        %associate integral errors with body and not world
        xybodyint = delTint * [cos(psiM(qn)), sin(psiM(qn)); -sin(psiM(qn)), cos(psiM(qn))]*[x_desM(qn)-x_estM(qn);y_desM(qn)-y_estM(qn)];
        zbodyint = delTint * (z_desM(qn)-z_estM(qn));
        
        phi_intM(qn) = phi_intM(qn) + ki_y*-xybodyint(2);
        theta_intM(qn) = theta_intM(qn) + ki_x*xybodyint(1);
        th_intM(qn) = th_intM(qn) + ki_z*zbodyint;
        
        th_intM(qn) = max(min(th_intM(qn),max_thint),-max_thint);
        phi_intM(qn) = max(min(phi_intM(qn),max_xyint),-max_xyint);
        theta_intM(qn) = max(min(theta_intM(qn),max_xyint),-max_xyint);
    end
    
    if(~isempty(seqM(qn).seq(seq_cntM(qn)).th_base))
        th_base = seqM(qn).seq(seq_cntM(qn)).th_base;
    else
        th_base = 88;
    end
    
    th_cmd = th_base+kp_z*(z_desM(qn)-z_estM(qn)) + kd_z*(zd_desM(qn) - zd_estM(qn))+th_intM(qn)+th_trimM(qn);
    ux = kp_x*(x_desM(qn) - x_estM(qn)) + kd_x*(xd_desM(qn) - xd_estM(qn));
    uy = kp_y*(y_desM(qn) - y_estM(qn)) + kd_y*(yd_desM(qn) - yd_estM(qn));
    
    phides = ux*sin(psiM(qn)) - uy*cos(psiM(qn))+phi_trimM(qn) + phi_intM(qn);
    thetades = ux*cos(psiM(qn)) + uy*sin(psiM(qn))+theta_trimM(qn) + theta_intM(qn);
    
    phides = asin(max(min(phides,max_asin),-max_asin));
    thetades = asin(max(min(thetades,max_asin),-max_asin));
    
    %think about changing these
    pd_cmd.kp_pitch = 220;
    pd_cmd.kd_pitch = 18.9;
    pd_cmd.kp_roll = 220;
    pd_cmd.kd_roll = 18.9;
    pd_cmd.kd_yaw = 33;
    
    kp_yaw = 150;
    psi_diff = mod(psidesM - psiM,2*pi);
    psi_diff = psi_diff - (psi_diff>pi)*2*pi;
    pd_cmd.yaw_delta = kp_yaw * (psi_diff)+yaw_trimM;
    th_cmd = max(min(th_cmd,200),0);
    pd_cmd.thrust = round(th_cmd);
    
    
    if(use_vicon_rpy)
        pd_cmd.kp_pitch = 0;
        pd_cmd.kp_roll = 0;
        pd_cmd.roll = 0;
        pd_cmd.pitch = 0;
        pd_cmd.roll_delta = 220 * (phides-phiM);
        pd_cmd.pitch_delta = 220 * (thetades-thetaM);

        pd_cmd.roll_delta=0;
        pd_cmd.pitch_delta=0;
    else
        pd_cmd.roll = phides;
        pd_cmd.pitch = thetades;

    end