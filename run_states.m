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
    
    for i=1:length(states)
        
        
        tic;
        controller = states(i).controller_type;
        gains = states(i).gains;
        cntrl_args = states(i).cntrl_args;
        end_condition = states(i).end_condition;
        end_condition_args = states(i).end_condition_args;
        
        
        complete=0;
        
        completion_by=[];
        
        disp(['Beginning State ' num2str(i) ' using controller ' func2str(controller)]);
        
        while(~complete)
            
            curr_state.state_timer = toc;
            
            %update
            
            curr_state = update_function(quad, curr_state, update_arg);
            
            %control
            
            pd_cmd = controller(curr_state, quad, gains, cntrl_args{:});
            
            %check for completion
            
            for j=1:length(end_condition)
                
                if(feval(end_condition{j},curr_state, end_condition_args{j}{:}))
                    complete=1;
                    completion_by=func2str(end_condition{j});
                end
            
            end
            
            %send unless complete
            
            if(isempty(pd_cmd))
                complete=1;
                completion_by='controller completion criteria';
            elseif(complete)
                complete=1;
            else
                asctec_PDCmd('send', quad.pd_id, pd_cmd);
            end
            
        end
        
        disp(['State ' num2str(i) ' completed by ' completion_by]);
        
    end
        
    
end
        