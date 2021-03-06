



speed = .5;


%hover
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


accel = .7;

% tester quad

tester=no_quad();

curr_state=init_curr_state_tester(tester,[-1.5 -1 .7 0]);







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


axis([-2 2 -2 2 0 2]);
grid on
hold off

start=[-1.5 -1 .7 0];

t=0:(2*pi/150):2*pi;
radius=.3;
circle=[radius.*sin(t)' radius.*-(cos(t)-1)' zeros(length(t),2)];
dt=.1;
traj=repmat(start,length(t),1)+repmat([1 0 .3 0],length(t),1)+circle;
traj=[traj (dt:dt:dt*length(t))'];

%%


clear states


button_press = @(curr_state,button) Gamepad('GetButton',1,button);
button_press = @ec_timer;
button_press = @(curr_state,string) strcmp(one_key(),'space');


hover={@xyz_hover, gains, [],@n_plus,1, button_press, 1,@n_plus,1};


states = [...
    create_state(@zero_thrust,gains,@n_plus,1, button_press, 1,@n_plus,1);...
    create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1);...
    create_state(hover{:});...
    create_state(@xyz_vel, gains, start+[1 0 .3 0], speed,accel,@n_plus,1);...
    create_state(hover{:});...
    create_state(@xyz_traj, gains, traj,@n_plus,1);...
    create_state(hover{:});...
    create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1);...
    create_state(hover{:});...
    create_state(@xyz_vel, gains, start, speed,accel,@n_plus,1);...
    create_state(hover{:});...
    create_state(@zero_thrust,gains,@n_plus,1, button_press, 1,@n_plus,1);...
    ];



%%

run_states(tester,curr_state, states, @sim_update,.001);
   
%% mike



vicon=start_vicon


mike=start_quad('Mike',vicon)
%%

curr_state=init_curr_state_vicon(mike,vicon)

clear states

button_press = @(curr_state,button) Gamepad('GetButton',1,button);



states(1) = create_state(@zero_thrust,gains,@n_plus,1, button_press, 1,@n_plus,1);

states(end+1) = create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1);
states(end+1) = create_state(@xyz_hover, gains, start+[0 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1);




states(end+1) = create_state(@xyz_vel, gains, start+[1 0 .3 0], speed,accel,@n_plus,1);
states(end+1) = create_state(@xyz_hover, gains, start+[1 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1);




%states(end+1) = create_state(@xyz_traj, gains, traj,@n_plus,1);

%states(end+1) = create_state(@xyz_hover, gains, start+[1 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1, button_press, 2,@n_minus,1);



states(end+1) = create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1);

states(end+1) = create_state(@xyz_hover, gains, start+[0 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1, button_press, 2, @n_minus, 3);
states(end+1) = create_state(@xyz_vel, gains, start, speed,accel,@n_plus,1);
states(end+1) = create_state(@xyz_hover, gains, start,@n_plus,1, button_press, 1,@n_plus,1);
states(end+1) = create_state(@zero_thrust,gains,@n_plus,1, button_press, 1,@n_plus,1);
%%

curr_state=init_curr_state_vicon(mike,vicon)

clear states


button_press = @(curr_state,button) Gamepad('GetButton',1,button);


states(1) = create_state(@zero_thrust,gains,@n_plus,1, button_press, 1,@n_plus,1);

states(end+1) = create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1);
states(end+1) = create_state(@xyz_hover, gains, start+[0 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1);




states(end+1) = create_state(@xyz_vel, gains, start+[1 0 .3 0], speed,accel,@n_plus,1);
states(end+1) = create_state(@xyz_hover, gains, start+[1 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1);




%states(end+1) = create_state(@xyz_traj, gains, traj,@n_plus,1);

%states(end+1) = create_state(@xyz_hover, gains, start+[1 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1, button_press, 2,@n_minus,1);



states(end+1) = create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1);

states(end+1) = create_state(@xyz_hover, gains, start+[0 0 .3 0],@n_plus,1, button_press, 1,@n_plus,1, button_press);
states(end+1) = create_state(@xyz_vel, gains, start, speed,accel,@n_plus,1);
states(end+1) = create_state(@xyz_hover, gains, start,@n_plus,1, button_press, 1,@n_plus,1);
states(end+1) = create_state(@zero_thrust,gains,@n_plus,1, button_press, 1,@n_plus,1);



%%

profile on
run_states(mike,curr_state, states, @vicon_update, vicon);
profile off



kill_thrust_quad(mike)
%%

kill_thrust_quad(mike)

%%
stop_quad(mike)
stop_vicon(vicon)








