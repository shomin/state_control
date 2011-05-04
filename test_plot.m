

[fixed_time,t_zero]=fix_log_time(log);
hold off
plot(fixed_time,log(:,10));
hold on

plot(fixed_time,log(:,2),'r');

plot([fixed_time(1) fixed_time(end)], [2.2 2.2],'c');
plot([fixed_time(1) fixed_time(end)], [2.2 2.2],'c');

plot([fixed_time(1) fixed_time(end)], [0 0],'c');
plot([fixed_time(1) fixed_time(end)], [-10*pi/180 -10*pi/180],'c');
plot([fixed_time(1) fixed_time(end)], [-50*pi/180 -50*pi/180],'k');
plot([fixed_time(1) fixed_time(end)], [-30*pi/180 -30*pi/180],'k');


plot(fixed_time,log(:,8),'y');



for i =2: length(t_zero)
    plot([fixed_time(t_zero(i)) fixed_time(t_zero(i))], [-5 5], 'g');
end

hold off







    
    


    

