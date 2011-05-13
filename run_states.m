function curr_state = run_states(quad, curr_state, states, update_function, update_arg, log_file, graph_handle)
%function curr_state = run_states(quad, curr_state, states, update_function, update_arg, log_file, graph_handle)


    %----------------
    %TODO - update_arg should be a varargin in case you want a simulator
    %with multiple arguments
    %----------------
    
    %----------------
    %TODO - input error checking
    %----------------
    
    if(nargin<6)
        log_file='default.bin';
        text_file='default.qlog';
    else
        text_file=[log_file '.txt'];
        log_file=[log_file '.bin'];
    end
    
    if(nargin<7)
        graph_handle=[];
        graph=0;
    else
        graph=1;
        color='r';
        set(graph_handle(1,2),'FaceColor',color);
        drawnow;
    end
    
    disp('Opening the log files');
    fid=fopen(log_file,'w');
    lid=fopen(text_file,'w');
    
    fprintf(1,['Writing to ' log_file ' and ' text_file '\n']);
    fprintf(lid,['Writing to ' log_file ' and ' text_file '\n']);

    
    fprintf(1,'Starting the State Machine Controller\n');
    fprintf(lid,'Starting the State Machine Controller\n');

    
    n=1;
    
    total_time=tic;
    
    while(n<=length(states))
    %for n=1:length(states)
        
        
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
        
        fprintf(1,['Beginning State ' num2str(n) ' using controller ' func2str(controller) '\n']);
        fprintf(lid,['Beginning State ' num2str(n) ' using controller ' func2str(controller) '\n']);
        
        
%         curr_state.th_int=0;
%         curr_state.theta_int=0;
%         curr_state.phi_int=0;
        curr_state.first_run_in_state=1;
        
            
        while(~complete)
            
            %disp(['Frequency: ' num2str(1/(toc-curr_state.state_timer))]);
            
            curr_state.state_timer = toc;
            
            curr_state.total_time = toc(total_time);

            
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
                        
                        ec_args=end_condition_args{j};
                        args='(';
                        for k=1:length(ec_args)
                            if(ischar(ec_args{k}))
                                args = [args '''' ec_args{k} ''''];
                            else
                                args = [args num2str(ec_args{k})];
                            end

                            if( k==length(ec_args))
                                args= [ args ')'];
                            else
                                args= [ args ','];
                            end
                        end
                        
                        completion_by = [completion_by args];
                        
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
            
            quad_log(fid,curr_state);
            
        end
        
        
        
        fprintf(1,['State ' num2str(n) ' completed by ' completion_by '\n[state_time = %6.4f, total_time=%6.4f]  \n'],curr_state.state_timer,curr_state.total_time);
        fprintf(lid,['State ' num2str(n) ' completed by ' completion_by '\n[state_time = %6.4f, total_time=%6.4f]  \n'],curr_state.state_timer,curr_state.total_time);
        
        if(graph)
            set(graph_handle(n,2),'FaceColor','w');
            set(graph_handle(new_n,2),'FaceColor',color);    
            drawnow;
        end
        
        n=new_n;        
        
        fprintf(1,['Moving to state ' num2str(n) '\n\n']);
        fprintf(lid,['Moving to state ' num2str(n) '\n\n']);

        
    end
    
    if(graph)
        set(graph_handle(new_n,2),'FaceColor','w');   
        drawnow;
    end
    
    disp('Closing the logfiles');
    fclose(fid);
    fclose(lid);
    
end
        