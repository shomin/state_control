




speed = .1;



gains.kp_x = 0.35/(0.7^2);
gains.kd_x = 0.35/(0.7);
gains.kp_y = 0.35/(0.7^2);
gains.kd_y = 0.35/(0.7);
gains.kp_z = 20/(0.3^2);
gains.kd_z = 20/(0.3);
gains.ki_x = .3*0.35/(0.7);
gains.ki_y = .3*0.35/(0.7);
gains.ki_z = .3*20/(0.3);




%later
use_vicon_rpy=1;
useint = 1;
accelrate = .7;

%% tester quad

tester=no_quad();

curr_state=init_curr_state_tester(tester,[-1.5 -1 .7 0]);

clear states





%draw cube
hold off
plot3(-1.5+[.35 .35 -.35 -.35 .35], -1 + [.35 -.35 -.35 .35 .35], [.7 .7 .7 .7 .7])
axis equal
hold on
plot3(-1.5+[.35 .35 -.35 -.35 .35], -1 + [.35 -.35 -.35 .35 .35], [0 0 0 0 0])
plot3(-1.5+[.35 .35], -1 + [.35 .35], [0 .7])
plot3(-1.5-[.35 .35], -1 + [.35 .35], [0 .7])
plot3(-1.5-[.35 .35], -1 - [.35 .35], [0 .7])
plot3(-1.5+[.35 .35], -1 - [.35 .35], [0 .7])
hold off




%%

button_press = @(curr_state,button) Gamepad('GetButton',1,button);

states(1) = create_state(@zero_thrust,gains, button_press, 1);

states(2) = create_state(@xyz_vel, gains, [-1.5 -1 1], speed);

states(3) = create_state(@hover_at_xyz, gains, [-1.5 -1 1], button_press, 1);

states(4) = create_state(@xyz_vel, gains, [-1.5 -1 .7], speed);

states(5) = create_state(@hover_at_xyz, gains, [-1.5 -1 .7], button_press, 1);

states(6) = create_state(@zero_thrust,gains, button_press, 1);


%%
run_states(tester,curr_state, states, @sim_update,.01);

%% mike



vicon=start_vicon


mike=start_quad('Mike',vicon)
%%

curr_state=init_curr_state_vicon(mike,vicon)
clear states

button_press = @(curr_state,button) Gamepad('GetButton',1,button);

states(1) = create_state(@zero_thrust,gains, button_press, 1);
states(end+1) = create_state(@xyz_vel, gains, [-1.7 -1 1], .2,button_press, 2);
states(end+1) = create_state(@hover_at_xyz, gains, [-1.7 -1 1], button_press, 1);


states(end+1) = create_state(@xyz_vel, gains, [0 0 1], .2,button_press, 2);
states(end+1) = create_state(@hover_at_xyz, gains, [0 0 1], button_press, 1);



states(end+1) = create_state(@xyz_vel, gains, [-1.7 -1 1], .2,button_press, 2);

states(end+1) = create_state(@hover_at_xyz, gains, [-1.7 -1 1], button_press, 1);
states(end+1) = create_state(@xyz_vel, gains, [-1.7 -1 .6], .15,button_press, 2);
states(end+1) = create_state(@zero_thrust,gains, @ec_timer,.1);


%%


run_states(mike,curr_state, states, @vicon_update, vicon);

%%

kill_thrust_quad(mike)
%%

kill_thrust_quad(mike)

%%
stop_quad(mike)
stop_vicon(vicon)








