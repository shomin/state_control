function [pd_cmd curr_state] = zero_thrust(curr_state, quad, gains)
%function pd_cmd = zero_thrust(curr_state, quad, gains)

    pd_cmd = asctec_PDCmd('empty');
    
    pd_cmd.kp_pitch = 220;
    pd_cmd.kd_pitch = 18.9;
    pd_cmd.kp_roll = 220;
    pd_cmd.kd_roll = 18.9;
    pd_cmd.kd_yaw = 33;
    pd_cmd.yaw_delta =0;
    
    pd_cmd.thrust = 0;
    pd_cmd.roll = 0;
    pd_cmd.pitch = 0;

end
