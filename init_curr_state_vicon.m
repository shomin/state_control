function curr_state = init_curr_state_vicon(quad, vicon)
%function curr_state = init_curr_state_vicon(quad, vicon)

    disp('Initializing curr_state');

    msg = vicon_Values('read',vicon.sid,2);
    while(isempty(msg))
        msg = vicon_Values('read',vicon.sid,2);
        disp('Vicon Message was empty');
        pause(.1);
    end
    

    [BodyGood,World] = match_quad(msg, quad);

    while(isempty(BodyGood))
        msg = vicon_Values('read',vicon.sid,2);
        [BodyGood,World] = match_quad(msg, quad);
        disp('Body did not match');
        pause(.1);
    end

    [W_R_QuadBV,W_T_QuadBV] = PointsToRot(BodyGood,World);
    W_R_QuadB = W_R_QuadBV * quad.QuadB_R_QuadBV';
    
    curr_state.last_Rot = W_R_QuadB;
    curr_state.last_Rot_diff = [];


    [phi,theta,psi] = RotToRPY_ZXY(W_R_QuadB');


    r_quad = W_T_QuadBV - W_R_QuadBV * quad.T_rel_BV; 

    curr_state.phi = phi - (phi>pi)*2*pi;
    curr_state.theta = theta - (theta>pi)*2*pi;
    curr_state.psi = psi - (psi>pi)*2*pi;


    curr_state.framelast = msg.values(1);
    curr_state.first_frame = msg.values(1);
    curr_state.first_frame_of_state = msg.values(1);


    curr_state.xd_est = 0;
    curr_state.yd_est = 0;
    curr_state.zd_est = 0;

    curr_state.x_est = r_quad(1)/1000;
    curr_state.y_est = r_quad(2)/1000;
    curr_state.z_est = r_quad(3)/1000;
    
    curr_state.state_timer=0;
            
end