function curr_state = sim_update(quad, curr_state, timestep)
%function curr_state = sim_update(quad, curr_state, update_arg)

    curr_state.x_est=curr_state.x_des;
    curr_state.y_est=curr_state.y_des;
    curr_state.z_est=curr_state.z_des;
    
    curr_state.psi=curr_state.psi_des;
    curr_state.theta=curr_state.theta_des;
    curr_state.phi=curr_state.phi_des;

    hold on
    
    curr_state.plot_handle=plot_quad(curr_state);
    
    pause(timestep);
    hold off
end