function [pd_cmd curr_state] = zero_thrust(curr_state, quad, gains)
%function pd_cmd = zero_thrust(curr_state, quad, gains)

    pd_cmd = asctec_PDCmd('empty');
    
    pd_cmd.thrust = 0;
    pd_cmd.roll = 0;
    pd_cmd.pitch = 0;

end
