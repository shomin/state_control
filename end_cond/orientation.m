function true = orientation( curr_state, field, cond, value)
%function true = orientation( var, cond, value)
% field is string specifying a field of curr_state
% cond is a string:  either 'equals', 'over', or 'below'
% value is the value to check against


    true=0;
    
    
    
    if( ~isfield(curr_state, field))
        error(['Input: ' field ' is not a field of curr_state']);
    end
    
    switch lower(cond)
        case {'equals', 'equal_to'}
            true = eval([ 'curr_state.' field]) == value ;            
        case 'over'
            true = eval([ 'curr_state.' field]) > value ;                        
        case {'under', 'below'}
            true = eval([ 'curr_state.' field]) < value ;  
        otherwise
            error('not correct conditional input');
    end
           
    
    

    
end
