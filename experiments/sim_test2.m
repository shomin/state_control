



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

%hover
tgains.kp_x = 0.2/(0.7^2);
tgains.kd_x = 0.5/(0.7);
tgains.kp_y = 0.2/(0.7^2);
tgains.kd_y = 0.5/(0.7);
tgains.kp_z = 20/(0.3^2);
tgains.kd_z = 20/(0.3);
tgains.ki_x = 0*0.35/(0.7);
tgains.ki_y = 0*0.35/(0.7);
tgains.ki_z = 0*20/(0.3);



%later
use_vicon_rpy=1;


accel = .7;

% tester quad

tester=no_quad();

curr_state=init_curr_state_tester(tester,[-1.7 -.2 .7 0]);




start=[-1.7 -.2 .7 0];


%draw cube
hold off
plot3(start(1)+[.35 .35 -.35 -.35 .35], start(2) + [.35 -.35 -.35 .35 .35], [.7 .7 .7 .7 .7])
axis equal
hold on
plot3(start(1)+[.35 .35 -.35 -.35 .35], start(2) + [.35 -.35 -.35 .35 .35], [0 0 0 0 0])
plot3(start(1)+[.35 .35], start(2) + [.35 .35], [0 .7])
plot3(start(1)-[.35 .35], start(2) + [.35 .35], [0 .7])
plot3(start(1)-[.35 .35], start(2) - [.35 .35], [0 .7])
plot3(start(1)+[.35 .35], start(2) - [.35 .35], [0 .7])


axis([-2 2 -2 2 0 2]);
grid on
hold off



t=0:(2*pi/200):2*pi;
radius=.6;
circle=[radius.*sin(t)' radius.*-(cos(t)-1)' zeros(length(t),2)];
dt=.05;
traj=repmat(start,length(t),1)+repmat([1 -.6 .3 0],length(t),1)+circle;
traj=[traj (dt:dt:dt*length(t))'];
hold on
plot3(traj(:,1),traj(:,2),traj(:,3));
hold off

disp(['Circle Speed ' num2str(sqrt(sum(((traj(floor(end/2),1:3)-traj(floor(end/2)-1,1:3)).^2)))/(traj(floor(end/2),5)-traj(floor(end/2)-1,5)))]);

%%


clear states


%button_press = @(curr_state,button) Gamepad('GetButton',1,button);

%spacebar = @(curr_state) strcmp(one_key(),'space');

%b_key = @(curr_state) strcmp(one_key(),'b');



b_step={@key_press,'b',@n_plus,1};

zero = {@zero_thrust,gains,@n_no,1, @key_press, 's',@n_plus,1};
hover={@xyz_hover, gains, [],@n_no,1, @key_press, 'space',@n_plus,1};


states = [...
    create_state(zero{:});...
    create_state(hover{:});...
    create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    create_state(@xyz_vel, gains, start+[1 -.6 .3 0], speed,accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    create_state(@xyz_traj, tgains, traj,@n_plus,1, b_step{:});...
    create_state(hover{:},@key_press,'r',@n_minus,3);...
    create_state(@xyz_vel, gains, start+[0 0 .3 0], speed,accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    create_state(@xyz_vel, gains, start, speed,accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    create_state(zero{:},@ec_timer,1.5,@n_plus,1);...
    ];



%%
 
run_states(tester,curr_state   , states, @sim_update,.001,'test_log.bin');

%%
kill_thrust_quad(mike)
kill_thrust_quad(mike)

curr_state=init_curr_state_vicon(mike,vicon)
pause()
run_states(mike,curr_state, states, @vicon_update,vicon);

kill_thrust_quad(mike)
kill_thrust_quad(mike)

      
%% mike



vicon=start_vicon


mike=start_quad('Mike',vicon)


%%
curr_state=init_curr_state_vicon(mike,vicon)



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








