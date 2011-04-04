function curr_state = vicon_update(quad, curr_state, vicon)

    msg = vicon_Values('read',vicon.sd_id,2);
    
    
    %hardcoded stuff
    tau_vel = 0.01;
    maxvel = 8.0;
    
    
    
    if(~isempty(msg)) % if the message isn't empty, then update the curr_state

        [BodyGood,World] = match_quad(msg, quad);


        if(~isempty(BodyGood))
            
            [W_R_QuadBV,W_T_QuadBV] = PointsToRot(BodyGood,World);

            W_R_QuadB = W_R_QuadBV * quad.QuadB_R_QuadBV';
            %the second matrix above accounts for our body frame z axis pointing
            %down

            if(~isempty(curr_state.last_Rot))
                Rot_diff = curr_state.last_Rot'*W_R_QuadB; %this is K_R_K+1
                Rot_metric = trace(Rot_diff);
                
                if(Rot_metric<-2.5) %change this to -1.1 to disable
                    %this is bad data point
                    %assume it kept rotating with the same angular velocity
                    %as last time
                    W_R_QuadB = curr_state.last_Rot * curr_state.last_Rot_diff;
                    Rot_diff = curr_state.last_Rot_diff;
                end
                
                curr_state.last_Rot_diff = Rot_diff;
            end
                        
            curr_state.last_Rot = W_R_QuadB;
        else
            W_R_QuadB = curr_state.last_Rot;
        end
            

            
            
        [phi,theta,psi] = RotToRPY_ZXY(W_R_QuadB');

        %quat = RotToQuat(W_R_QuadB); %I don't think we need quaternions yet

        r_quad = W_T_QuadBV - W_R_QuadBV * quad.T_rel_BV; %position vector from world origin to body origin
        
        curr_state.phi = phi - (phi>pi)*2*pi;
        curr_state.theta = theta - (theta>pi)*2*pi;
        curr_state.psi = psi - (psi>pi)*2*pi;

        framelast=vicon.framelast;

        delT = (msg.values(1) - framelast)/150;
        
        vicon.framelast = msg.values(1);




        xd_estnew = (r_quad(1)/1000 - curr_state.x_est)/delT;
        yd_estnew = (r_quad(2)/1000 - curr_state.y_est)/delT;
        zd_estnew = (r_quad(3)/1000 - curr_state.z_est)/delT;

        xd_estnew = max(min(xd_estnew,maxvel),-maxvel);
        yd_estnew = max(min(yd_estnew,maxvel),-maxvel);
        zd_estnew = max(min(zd_estnew,maxvel),-maxvel);


        alfa = (delT/(tau_vel+delT));

        curr_state.xd_est = alfa*xd_estnew + (1-alfa)*curr_state.xd_est;
        curr_state.yd_est = alfa*yd_estnew + (1-alfa)*curr_state.yd_est;
        curr_state.zd_est = alfa*zd_estnew + (1-alfa)*curr_state.zd_est;

        curr_state.x_est = r_quad(1)/1000;
        curr_state.y_est = r_quad(2)/1000;
        curr_state.z_est = r_quad(3)/1000;
            
    end
    
end

        