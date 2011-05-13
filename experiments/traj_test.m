gains.kp_x = 0.35/(0.7^2);
gains.kd_x = 0.35/(0.7);
gains.kp_y = 0.35/(0.7^2);
gains.kd_y = 0.35/(0.7);
gains.kp_z = 20/(0.3^2);
gains.kd_z = 20/(0.3);
gains.ki_x = .5*0.35/(0.7);
gains.ki_y = .5*0.35/(0.7);
gains.ki_z = .5*20/(0.3);

soft_gains.kp_x = 0.35/(1.5^2);
soft_gains.kd_x = 0.35/(1.5);
soft_gains.kp_y = 0.35/(1.5^2);
soft_gains.kd_y = 0.35/(1.5);
soft_gains.kp_z = 20/(0.4^2);
soft_gains.kd_z = 20/(0.4);
soft_gains.ki_x = .3*0.35/(0.7);
soft_gains.ki_y = .3*0.35/(0.7);
soft_gains.ki_z = .3*20/(0.3);

trise=.8;
tzrise=.4;
tgains.kp_x = 0.35/(trise^2);
tgains.kd_x = 0.35/(trise);
tgains.kp_y = 0.35/(trise^2);
tgains.kd_y = 0.35/(trise);
tgains.kp_z = 20/(tzrise^2);
tgains.kd_z = 20/(tzrise);
tgains.ki_x = .2*0.35/(0.7);
tgains.ki_y = .2*0.35/(0.7);
tgains.ki_z = .2*20/(0.3);




box = [-2.2 .55 .7];

%draw cube for scale reference 
figure(2)
hold off
plot3(box(1)+[.35 .35 -.35 -.35 .35], box(2) + [.35 -.35 -.35 .35 .35], [.7 .7 .7 .7 .7])
axis equal
hold on
plot3(box(1)+[.35 .35 -.35 -.35 .35], box(2) + [.35 -.35 -.35 .35 .35], [0 0 0 0 0])
plot3(box(1)+[.35 .35], box(2) + [.35 .35], [0 .7])
plot3(box(1)-[.35 .35], box(2) + [.35 .35], [0 .7])
plot3(box(1)-[.35 .35], box(2) - [.35 .35], [0 .7])
plot3(box(1)+[.35 .35], box(2) - [.35 .35], [0 .7])


axis([-2 2 -2 2 0 3]);
grid on
hold off



% tester quad
tester=no_quad();



circle_center=[0 0 1.5 0];


radius=.8;
num_pts=1000;
traj_speed = .4;

turns=1;

t=0:(turns*2*pi/num_pts):turns*2*pi;



helix_height = .5;
d_height = 0: (helix_height / num_pts) : helix_height;

helix=[radius.*-cos(t)' radius.*sin(t)' d_height' zeros(length(t),1)];
traj=repmat(circle_center ,length(t),1)+helix;

% circle=[radius.*-cos(t)' radius.*sin(t)' zeros(length(t),2)];
% traj=repmat(circle_center ,length(t),1)+circle;

dt = norm(traj(1,1:3) - traj(2,1:3))/traj_speed
traj=[traj (dt:dt:dt*length(t))'];

%RESHAPING THE TIME!
power=.5;
reshape_pts=200;

input=traj(1:reshape_pts,5);
output= input .* (0:1/(length(input)-1):1).^power;

traj(1:reshape_pts,5)=output;

hold on
plot3(traj(:,1),traj(:,2),traj(:,3));
hold off

%sample circle speed to verify the dt calculation
disp(['Circle Speed ' num2str(sqrt(sum(((traj(floor(end/2),1:3)-traj(floor(end/2)-1,1:3)).^2)))/(traj(floor(end/2),5)-traj(floor(end/2)-1,5)))]);

traj_start=traj(1,1:4)

%%

b_step={@key_press,'b',@n_plus,1};
zero = {@zero_thrust,gains,@n_no,1, @key_press, 's',@n_plus,1};
hover={@xyz_hover, gains, [],@n_no,1, @key_press, 'space',@n_plus,1};

start=[-2.1 .55 1 0];



speed = .8;
accel = .5;

clear states

states = [...
    create_state(zero{:},...
        @orientation,'phi','below',-25*pi/180,@n_plus,1);...
    create_state(hover{:});...
    
    create_state(@xyz_vel, gains, traj_start, 'speed', speed,'accelrate',accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    
    create_state(@xyz_traj, tgains, new_traj,@n_plus,1, b_step{:});...
    create_state(@xyz_hover, soft_gains, [],@n_no,1, @key_press, 'space',@n_plus,1,...
        @ec_timer,.5,@n_plus,1);...
    create_state(hover{:},...    
        @key_press,'r',@n_minus,4);...
    
    
    create_state(@xyz_vel, gains, start, 'speed', speed,'accelrate',accel,@n_plus,1, b_step{:});...
    create_state(hover{:},...
        @orientation,'z_est','over',1.35,@n_plus,1);...
    create_state(zero{:},@ec_timer,.5,@n_plus,1);...
    ];


%%
figure(1)
[x,y,h] = state_graph(states,'matlab');
%figure(2)


%%
curr_state=init_curr_state_tester(tester,start);
%%
run_states(tester,curr_state   , states, @sim_update,.001,'~/Desktop/sim_test');



%% REAL QUAD : Mike

vicon=start_vicon
mike=start_quad('Mike',vicon)

%%
curr_state=init_curr_state_vicon(mike,vicon)

pause()
run_states(mike,curr_state, states, @vicon_update,vicon,'logs/traj_test_int_5');

kill_thrust_quad(mike)

%%

stop_quad(mike)
stop_vicon(vicon)


