function curr_state = run_states(quad, curr_state, states, update_function, update_arg)
%function curr_state = run_states(quad, curr_state, states, update_function, update_arg)


    %----------------
    %TODO - update_arg should be a varargin in case you want a simulator
    %with multiple arguments
    %----------------
    
    %----------------
    %TODO - input error checking
    %----------------
    
    disp('Starting the State Machine Controller');
    
    n=1;
    
    %while(n<=length(states))
    for n=1:length(states)
        
        
        tic;
        controller = states(n).controller_type;
        gains = states(n).gains;
        cntrl_args = states(n).cntrl_args;
        end_condition = states(n).end_condition;
        end_condition_args = states(n).end_condition_args;
        
        default_exit_function = states(n).default_exit_function;
        default_exit_arg = states(n).default_exit_arg;
        
        exit_function=states(n).exit_function;
        exit_arg=states(n).exit_arg;
        
        complete=0;
        
        completion_by=[];
        
        disp(['Beginning State ' num2str(n) ' using controller ' func2str(controller)]);
        
%         curr_state.th_int=0;
%         curr_state.theta_int=0;
%         curr_state.phi_int=0;
        curr_state.first_run_in_state=1;
            
        while(~complete)
            
            curr_state.state_timer = toc;

            
            %update
            
            curr_state = update_function(quad, curr_state, update_arg);
  

            
            %control
            if(~isempty(cntrl_args))
                [pd_cmd, curr_state] = controller(curr_state, quad, gains, cntrl_args{:});
            else
                [pd_cmd, curr_state] = controller(curr_state, quad, gains);
            end
            %check for completion
            
            for j=1:length(end_condition)
                
                if(~isempty(end_condition_args))
                    if(feval(end_condition{j},curr_state, end_condition_args{j}{:}))
                        complete=1;
                        completion_by=func2str(end_condition{j});
                        
                        new_n = feval(exit_function{j},n, exit_arg(j));
                    end
                else
                    if(feval(end_condition{j},curr_state))
                        complete=1;
                        completion_by=func2str(end_condition{j});
                        
                        new_n = feval(exit_function{j},n, exit_arg(j));
                    end
                end            
            end
            
            %send unless complete
            
            if(isempty(pd_cmd))
                complete=1;
                completion_by='controller completion criteria';
                new_n = default_exit_function(n,default_exit_arg);
            elseif(complete)
                complete=1;
            else
                if(quad.real)
                    asctec_PDCmd('send', quad.pd_id, pd_cmd);
                else
                    %disp('something')
                end
            end
            
        end
        
        disp(['State ' num2str(n) ' completed by ' completion_by]);
        n=new_n;
        disp(['Moving to state ' num2str(n)]);
        
    end
        
    
end
        