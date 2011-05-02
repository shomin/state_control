function state_graph(states, type,filename)
%function state_graph(states, type,filename)



    n=length(states);

    C=zeros(n+1,n+1);

    edges=cell(n+1,n+1);

    for i = 1:n
        names{i}=func2str(states(i).controller_type);



        for j = 1: (length(states(i).end_condition)+1)


            if(j==(length(states(i).end_condition)+1))
                exit_func=func2str(states(i).default_exit_function);
                n_change=states(i).default_exit_arg;
                end_cond='completion';
            else        
                exit_func=func2str(states(i).exit_function{j});
                n_change=states(i).exit_arg(j);
                if(iscell(states(i).end_condition))
                    end_cond=func2str(states(i).end_condition{j});
                else
                    end_cond=func2str(states(i).end_condition);
                end                
            end


            if( strcmp( exit_func, 'n_plus') )
                C( i + n_change ,i) = 1;
                if(isempty(edges{i + n_change ,i}))
                    edges{i + n_change ,i} = end_cond;                        
                else
                    edges{i + n_change ,i} = [edges{i + n_change ,i} '\n or \n' end_cond];
                end
            elseif( strcmp( exit_func, 'n_minus') )
                C( i - n_change,i) = 1;        
                if(isempty(edges{i - n_change ,i}))
                    edges{i - n_change ,i} = end_cond;                        
                else
                    edges{i - n_change ,i} = [edges{i - n_change ,i} '\n or \n' end_cond];
                end
            elseif( strcmp( exit_func, 'n_equals') )
                C( n_change,i) = 1;      
                if(isempty(edges{n_change ,i}))
                    edges{n_change ,i} = end_cond;                        
                else                             
                    edges{n_change ,i} = [edges{n_change ,i} '\n or \n' end_cond];
                end
            end


        end




    end

    names{n+1}='END';


    if(strcmp(type, 'gml'))
        graphtogml([filename '.gml'],C,names);
        system(['open ' filename '.gml']);
    elseif(strcmp(type,'matlab'))
        graph_draw(C','node_labels',names);
    elseif(strcmp(type,'dot'))
        graph_to_dot(C','node_label',names,'arc_label',edges','filename',[filename '.dot']);
        system(['open ' filename '.dot']);
    end
end

