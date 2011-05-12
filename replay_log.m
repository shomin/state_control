%%
hist.phi=log(:,1);
hist.theta=log(:,2);%2
hist.xd_est=log(:,3);%3
hist.yd_est=log(:,4);%4
hist.zd_est=log(:,5);%5
hist.state_timer=log(:,6);%6
hist.delT=log(:,7);%7
hist.x_est=log(:,8);%8
hist.y_est=log(:,9);%9
hist.z_est=log(:,10);%10
hist.psi=log(:,11);%11
hist.x_des=log(:,12);%12
hist.y_des=log(:,13);%13
hist.z_des=log(:,14);%14
hist.psi_des=log(:,15);%15
hist.th_int=log(:,16);%16
hist.phi_int=log(:,17);%17
hist.theta_int=log(:,18);%18
hist.theta_des=log(:,19);%19
hist.phi_des=log(:,20);
%%
[fixed_time,t_zero]=fix_log_time(log);

figure(2);
t=fixed_time;
figure(2)
hold off
plot(t,hist.phi,t,hist.theta,t,hist.psi);
hold on
bar=plot([0 0], [-5 5], 'k');




figure(1);

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

curr_state.plot_handle=[];

pause(.1)

step=0;
key=[];

i=1
iter=3;

while(i<length(log))



    curr_state.phi=log(i,1);
    curr_state.theta=log(i,2);%2
    curr_state.xd_est=log(i,3);%3
    curr_state.yd_est=log(i,4);%4
    curr_state.zd_est=log(i,5);%5
    curr_state.state_timer=log(i,6);%6
    curr_state.delT=log(i,7);%7
    curr_state.x_est=log(i,8);%8
    curr_state.y_est=log(i,9);%9
    curr_state.z_est=log(i,10);%10
    curr_state.psi=log(i,11);%11
    curr_state.x_des=log(i,12);%12
    curr_state.y_des=log(i,13);%13
    curr_state.z_des=log(i,14);%14
    curr_state.psi_des=log(i,15);%15
    curr_state.th_int=log(i,16);%16
    curr_state.phi_int=log(i,17);%17
    curr_state.theta_int=log(i,18);%18
    curr_state.theta_des=log(i,19);%19
    curr_state.phi_des=log(i,20);
    
    
    curr_state.plot_handle=plot_quad(curr_state);
    

    set(bar, 'XData', [t(i) t(i)]);
    
    curr_state
    
    pause(.01)
    
    key=one_key;
    if(strcmp(key,'space') || step)
        pause;
        key=one_key;
    elseif (strcmp(key,'UpArrow'))
        iter=iter+1;
    elseif (strcmp(key,'DownArrow'))
        iter = max( iter-1, 1);
    end
    
    if(strcmp(key,'RightArrow'))
        step=1;
    elseif(strcmp(key,'LeftArrow'))
        step=1;
        i=i-(2*iter);
    elseif(strcmp(key,'space'))
        step=0;
        pause(.1);
    end
    

    if(key_press(1,'q'))
        break;
    end
    
    i=i+iter;
end