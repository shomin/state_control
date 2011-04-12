function curr_state = init_curr_state_tester(quad, pose)
%function curr_state = init_curr_state_tester(quad)

    disp('Initializing test_case curr_state');

    
    curr_state.last_Rot = [];
    curr_state.last_Rot_diff = [];


    curr_state.phi =0;
    curr_state.theta = 0;
    


    curr_state.xd_est = 0;
    curr_state.yd_est = 0;
    curr_state.zd_est = 0;

    
    
    curr_state.state_timer=0;
    curr_state.delT=0;
    
    
    
    curr_state.x_est = pose(1);
    curr_state.y_est = pose(2);
    curr_state.z_est = pose(3);
    curr_state.psi = pose(4);
    
    curr_state.x_des=curr_state.x_est;
    curr_state.y_des=curr_state.y_est;
    curr_state.z_des=curr_state.z_est;
    curr_state.psi_des=curr_state.psi;
    
    curr_state.first_run_in_state=0;
    
    curr_state.th_int=0;
    curr_state.phi_int=0;
    curr_state.theta_int=0;
            
end