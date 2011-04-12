function curr_state = sim_update(quad, curr_state, timestep)
%function curr_state = sim_update(quad, curr_state, update_arg)

    curr_state.x_est=curr_state.x_des;
    curr_state.y_est=curr_state.y_des;
    curr_state.z_est=curr_state.z_des;

    hold on
    plot3(curr_state.x_est, curr_state.y_est, curr_state.z_est,'ro');
    pause(timestep);
    hold off
end