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
        
        
        
        controller=states(i).controller_type;
        gains=states(i).gains;
        
        complete=0;
        
        disp(['Beginning State ' num2str(i) ' using controller ' func2str(controller)]);
        
        while(~complete)
            
            %update
            
            curr_state = vicon_update(quad, curr_state, vicon)
            
            %control
            %check for completion
            %send
            
            
            
            pd_cmd = hover_at_xyz(curr_state, quad, gains, xyz_and_psi)
            
            if(isempty(pd_cmd))
                complete=1;
            else
                asctec_PDCmd('send', quad.pd_id, pd_cmd);
            end
            
        end
        
    end
        
    
end
        