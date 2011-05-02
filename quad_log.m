function quad_log(fid,curr_state)
%function quad_log(fid,curr_state)
    

    %data_length=20;

    fwrite(fid,...    
        [curr_state.phi...%1
        curr_state.theta...%2
        curr_state.xd_est...%3
        curr_state.yd_est...%4
        curr_state.zd_est...%5
        curr_state.state_timer...%6
        curr_state.delT...%7
        curr_state.x_est...%8
        curr_state.y_est...%9
        curr_state.z_est...%10
        curr_state.psi...%11
        curr_state.x_des...%12
        curr_state.y_des...%13
        curr_state.z_des...%14
        curr_state.psi_des...%15
        curr_state.th_int...%16
        curr_state.phi_int...%17
        curr_state.theta_int...%18
        curr_state.theta_des...%19
        curr_state.phi_des],...%20
        'double');
    
end