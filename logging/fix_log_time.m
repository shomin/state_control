function fixed_time = fix_log_time(log)

    state_timer=log(:,6);



    t_zero = find(state_timer<.005);



    fixed_time = state_timer;
    for i = 2:length(t_zero)
        fixed_time(t_zero(i):end) = fixed_time(t_zero(i):end) + state_timer(t_zero(i)-1);
    end

end