%Trying to get orientation control working


%hover
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

box = [-1.75 -.87 .7];

%draw cube for scale reference 
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


%TODO - draw net for reference


% tester quad

tester=no_quad();


start=[-1.75 -.87 1.3 0];

curr_state=init_curr_state_tester(tester,start);



speed = .8;
accel = .4;



%%

b_step={@key_press,'b',@n_plus,1};
zero = {@zero_thrust,gains,@n_no,1, @key_press, 's',@n_plus,1};
hover={@xyz_hover, gains, [],@n_no,1, @key_press, 'space',@n_plus,1};


start=[-1.75 -.87 1.3 0];

land = [-1.8 -.87 .9];

bottom=[0,0,1.5,0];

top = [1 0 3 0];

fudge=.3;

target_top = top + ((top-bottom).*fudge);

z_mid=2.3;

man_accel = 1.2;
man_speed = 2.2;

theta_cmd=-55*pi/180;
thrust_cmd=40;



clear states
states = [...
    create_state(zero{:},...
        @orientation,'phi','below',-25*pi/180,@n_plus,1);...
    
    %start hovering
    create_state(hover{:});...
    
    %goto bottom and hover
    create_state(@xyz_vel, gains, bottom, speed,'accelrate', accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    
    
    %go to top with man_speed and man_accel
    create_state(@xyz_vel, gains, top, man_speed,'accelrate', man_accel,@n_plus,1,...
        @orientation,'z_est','over',z_mid,@n_plus,1,...
        b_step{:});...

    create_state(@xyz_vel, gains, target_top, man_speed,'theta_cmd',theta_cmd,'thrust_cmd',thrust_cmd,@n_plus,2,...
        @orientation,'z_est','over', 3            ,@n_plus,1,...
        @orientation,'z_est','under', 2.2             ,@n_plus,1,...
        @orientation,'theta','under',  theta_cmd+10*pi/180     ,@n_plus,1 );...
        
    create_state(@xyz_vel, gains, target_top, man_speed,'theta_cmd',0,'thrust_cmd',60,@n_plus,1,...
        @ec_timer,.3,@n_plus,1,...
        @orientation,'z_est','under', 2             ,@n_plus,1,...
        @orientation,'theta','over',  0*pi/180     ,@n_plus,1 );...

    
    %restabilize with soft gains
    create_state(@xyz_hover, soft_gains, [],@n_no,1, @key_press, 'space',@n_plus,1);...

    
    create_state(@xyz_vel, gains, bottom, speed,'accelrate', accel,@n_plus,1, b_step{:});...

    
    create_state(@xyz_hover, gains, [],@n_no,1, @key_press, 'space',@n_plus,1,@key_press,'r',@n_minus,5);...

    
    %go back to start and hover
    create_state(@xyz_vel, gains, land, speed,'accelrate', accel,@n_plus,1, b_step{:});...
    create_state(hover{:},...
        @orientation,'z_est','over',1.1,@n_plus,1);...
    
    %zero thrust and end after .5 seconds
    create_state(zero{:},@ec_timer,.2,@n_plus,1);...
        
        
    ];



%%
 
run_states(tester,curr_state   , states, @sim_update,.001,'test_log.bin');



      
%% mike

vicon=start_vicon
mike=start_quad('Mike',vicon)

curr_state=init_curr_state_vicon(mike,vicon)
%%
curr_state=init_curr_state_vicon(mike,vicon)

%%
hold on
    curr_state=vicon_update(mike,curr_state,vicon)
     curr_state.plot_handle=plot_quad(curr_state);

%%
kill_thrust_quad(mike)

curr_state=init_curr_state_vicon(mike,vicon)
pause()
run_states(mike,curr_state, states, @vicon_update,vicon,'first_perch_tests_15.bin');

kill_thrust_quad(mike)

%%



kill_thrust_quad(mike)

stop_quad(mike)
stop_vicon(vicon)








