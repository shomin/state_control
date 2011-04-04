addpath('~/git/ipc-bridge/ipc_bridge_matlab/bin/');

addpath ~/git/ros-pkg/mrslsandbox/quadrotor_dynamics/matlab_quadrotor_control/control/
addpath ~/git/ros-pkg/mrslsandbox/quadrotor_dynamics/matlab_quadrotor_control/control/controllers/



gains.kp_x = 0.35/(0.7^2);
gains.kd_x = 0.35/(0.7);
gains.kp_y = 0.35/(0.7^2);
gains.kd_y = 0.35/(0.7);
gains.kp_z = 20/(0.3^2);
gains.kd_z = 20/(0.3);

%%
vicon=start_vicon


mike=start_quad('Mike',vicon)

%%
curr_state=init_curr_state_vicon(mike,vicon)



start_pt = [-1.5 -1 .7 0];

hover_pt = start_pt + [0 0 .3 0];


clear states

b1 = @(curr_state) Gamepad('GetButton',1,1);

states(1) = create_state(@hover_at_xyz, gains, hover_pt , b1)

states(end+1) = create_state(@hover_at_xyz, gains, hover_pt +[.5 0 0 0], @ec_timer , 2)

states(end+1) = create_state(@hover_at_xyz, gains, hover_pt +[.5 .5 0 0], @ec_timer , 2)

states(end+1) = create_state(@hover_at_xyz, gains, hover_pt +[0 .5 0 0], @ec_timer , 2)

states(end+1) = create_state(@hover_at_xyz, gains, hover_pt, @ec_timer , 2)

states(end+1) = create_state(@hover_at_xyz, gains, start_pt , @ec_timer , 2)



run_states(mike,curr_state, states, @vicon_update, vicon);

kill_thrust_quad(mike)



%%
stop_quad(mike)
stop_vicon(vicon)