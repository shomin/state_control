function complete = ec_timer(curr_state, time)
%function ec_timer(curr_state, time)

    if( curr_state.state_timer > time)
        complete=1;
    else
        complete=0;
    end

end