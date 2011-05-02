function true = button_press(curr_state, button)
%function true = button_press(curr_state, button)
    true = Gamepad('GetButton',1,button);

end