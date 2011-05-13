function [x, y, h] = state_graph(states, type,filename)
%function state_graph(states, type,filename)



    n=length(states);

    C=zeros(n+1,n+1);

    edges=cell(n+1,n+1);
    
%     if(strcmp(type,'matlab'))
%         nodes=zeros(n+1,1);
%         if(nargin==3)
%             curr_node=filename;        
%             nodes(curr_node)=1;
%         end
%     end

    for i = 1:n
        names{i}=func2str(states(i).controller_type);
        
        if(~strcmp(type,'matlab'))
            if(strcmp(names{i}, 'xyz_hover'))
                if(isempty(states(i).cntrl_args{1}))
                    if(strcmp(type, 'gml'))
                        names{i}=strcat(names{i},'[in place]');
                    else
                        names{i}=strcat(names{i},'\n','[in place]');
                    end
                else
                    if(strcmp(type, 'gml'))
                        names{i}=strcat(names{i}, mat2str(states(i).cntrl_args{1},3));
                    else
                        names{i}=strcat(names{i}, '\n',mat2str(states(i).cntrl_args{1},3));
                    end
                end
            elseif(~strcmp(names{i}, 'xyz_traj'))
                if(strcmp(type, 'gml'))
                    if(~isempty(states(i).cntrl_args))
                        names{i}=strcat(names{i}, mat2str(states(i).cntrl_args{1},3));
                    end
                else
                    cnt=1;
                    while(cnt<=length(states(i).cntrl_args))
                        if(~ischar(states(i).cntrl_args{cnt}))
                            temp = mat2str(states(i).cntrl_args{cnt},3);
                        else
                            temp = strcat(states(i).cntrl_args{cnt},':', mat2str(states(i).cntrl_args{cnt+1},3));
                            cnt=cnt+1;
                        end

                        names{i}=strcat(names{i},'\n',temp);

                        cnt = cnt+1;
                    end
                end
            end
        end
            
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
                
                ec_args=states(i).end_condition_args{j};
                
                if(~isempty(ec_args))
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
                else
                    args='()';
                end
                        
                end_cond = [end_cond args];
            end


            if( strcmp( exit_func, 'n_plus') )
                C( i + n_change ,i) = 1;
                if(isempty(edges{i + n_change ,i}))
                    edges{i + n_change ,i} = end_cond;                        
                else
                    if(strcmp(type, 'gml'))
                        edges{i + n_change ,i} = [edges{i + n_change ,i} ' or ' end_cond];
                    else
                        edges{i + n_change ,i} = [edges{i + n_change ,i} '\n or \n' end_cond];
                    end
                end
            elseif( strcmp( exit_func, 'n_minus') )
                C( i - n_change,i) = 1;        
                if(isempty(edges{i - n_change ,i}))
                    edges{i - n_change ,i} = end_cond;                        
                else
                    if(strcmp(type, 'gml'))
                        edges{i - n_change ,i} = [edges{i - n_change ,i} ' or ' end_cond];
                    else
                        edges{i - n_change ,i} = [edges{i - n_change ,i} '\n or \n' end_cond];                        
                    end
                end
            elseif( strcmp( exit_func, 'n_equals') )
                C( n_change,i) = 1;      
                if(isempty(edges{n_change ,i}))
                    edges{n_change ,i} = end_cond;                        
                else   
                    if(strcmp(type, 'gml'))
                        edges{n_change ,i} = [edges{n_change ,i} ' or ' end_cond];
                    else
                        edges{n_change ,i} = [edges{n_change ,i} '\n or \n' end_cond];                        
                    end
                end
            end


        end




    end

    names{n+1}='END';


    x=[];y=[];h=0;
    
    if(strcmp(type, 'gml'))
        graphtogml([filename '.gml'],C,names,edges);
        system(['open ' filename '.gml']);
    elseif(strcmp(type,'matlab'))
%         [x, y, h] =
%         graph_draw(C','node_labels',names,'node_shapes',nodes);
        [x, y, h] = graph_draw(C','node_labels',names);
    elseif(strcmp(type,'dot'))
        graph_to_dot(C','node_label',names,'arc_label',edges','filename',[filename '.dot'],'leftright',0);
        system(['open ' filename '.dot']);
    end
end

