

while(1)
    curr_state=vicon_update(mike,curr_state,vicon)
     curr_state.plot_handle=plot_quad(curr_state);
    pause(.01);
    axis equal
end