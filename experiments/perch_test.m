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



%draw cube for scale reference 
hold off
plot3(start(1)+[.35 .35 -.35 -.35 .35], start(2) + [.35 -.35 -.35 .35 .35], [.7 .7 .7 .7 .7])
axis equal
hold on
plot3(start(1)+[.35 .35 -.35 -.35 .35], start(2) + [.35 -.35 -.35 .35 .35], [0 0 0 0 0])
plot3(start(1)+[.35 .35], start(2) + [.35 .35], [0 .7])
plot3(start(1)-[.35 .35], start(2) + [.35 .35], [0 .7])
plot3(start(1)-[.35 .35], start(2) - [.35 .35], [0 .7])
plot3(start(1)+[.35 .35], start(2) - [.35 .35], [0 .7])


axis([-2 2 -2 2 0 3]);
grid on
hold off


%TODO - draw net for reference


% tester quad

tester=no_quad();


start=[-1.7 -.2 1 0];

curr_state=init_curr_state_tester(tester,start);



speed = .8;
accel = .4;



%%

b_step={@key_press,'b',@n_plus,1};
zero = {@zero_thrust,gains,@n_no,1, @key_press, 's',@n_plus,1};
hover={@xyz_hover, gains, [],@n_no,1, @key_press, 'space',@n_plus,1};




bottom=[0,0,1.5,0];

top = [0 0 3 0];

z_mid=2.25;

man_accel = 1;
man_speed = 2;




clear states
states = [...
    create_state(zero{:});...
    
    %start hovering
    create_state(hover{:});...
    
    %goto bottom and hover
    create_state(@xyz_vel, gains, bottom, speed,'accelrate', accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    
    
    %go to top with man_speed and man_accel
    create_state(@xyz_vel, gains, top, man_speed,'accelrate', man_accel,@n_plus,2,...
        @orientation,'z_est','over',z_mid,@n_plus,1);...

    create_state(@xyz_vel, gains, top, man_speed,@n_plus,1,...
        @orientation,'z_est','over', 2.5            ,@n_plus,1,...
        @orientation,'z_est','under', 2             ,@n_plus,1,...
        @orientation,'theta','over',  10*pi/180     ,@n_plus,1 );...
        
    
    
    %restabilize with soft gains
    create_state(@xyz_hover, soft_gains, [],@n_no,1, @ec_timer, 2,@n_plus,1);...

    
    create_state(@xyz_vel, gains, bottom, speed,'accelrate', accel,@n_plus,1, b_step{:});...

    
    create_state(@xyz_hover, gains, [],@n_no,1, @key_press, 'space',@n_plus,1,@key_press,'r',@n_minus,4);...

    
    %go back to start and hover
    create_state(@xyz_vel, gains, start, speed,'accelrate', accel,@n_plus,1, b_step{:});...
    create_state(hover{:});...
    
    %zero thrust and end after .5 seconds
    create_state(zero{:},@ec_timer,1,@n_plus,1);...
    ];



%%
 
run_states(tester,curr_state   , states, @sim_update,.001,'test_log.bin');



      
%% mike

vicon=start_vicon
mike=start_quad('Mike',vicon)

curr_state=init_curr_state_vicon(mike,vicon)

%%
kill_thrust_quad(mike)

curr_state=init_curr_state_vicon(mike,vicon)
pause()
run_states(mike,curr_state, states, @vicon_update,vicon);

kill_thrust_quad(mike)

%%



kill_thrust_quad(mike)

stop_quad(mike)
stop_vicon(vicon)








