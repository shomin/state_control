function complete = ec_timer(curr_state, time)
%function ec_timer(curr_state, time)

    if( ((curr_state.framelast - curr.state.first_frame_of_state)/150) > time)
        complete=1;
    else
        complete=0;
    end

end