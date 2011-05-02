function state = create_state(controller_type, gains, varargin)
%function state = create_state(controller_type, gains, optional argurments: controller_inputs, {@end_conditions}, end_condition_inputs)

if(~isa(controller_type,'function_handle'))
    error('Controller Type must be a function handle')
end

if(~isstruct(gains))
    error('Gains must be a struct');
elseif(~all(isfield(gains,{'kp_x' 'kp_y' 'kp_z' 'kd_x' 'kd_y' 'kd_z' 'ki_x' 'ki_y' 'ki_z'})))
    error('Missing the proper gains (or they dont have the right field names');
end


%------------------------
%------------------------
%TODO - check actual gain inputs for being proper numbers, etc.
%------------------------
%------------------------


state.controller_type=controller_type;

state.gains=gains;

state.cntrl_args = {};

state.end_condition={};

state.end_condition_args={};

state.exit_function={};

state.exit_arg=[];

num_end_conds=0; % initialize to no ending conditions

def_exit_arg_defined=0;

ef_defn=1;

ef_arg=1;

state.default_exit_function=[];

for i=1:length(varargin)
    if(num_end_conds==0 && ~isa(varargin{i},'function_handle') && isempty(state.default_exit_function)) %no ending conditions yet; these must be controller input variables
        state.cntrl_args{i}=varargin{i};
        
    elseif(num_end_conds==0 && ~isa(varargin{i},'function_handle'))
        state.default_exit_arg=varargin{i};
        
    elseif(isa(varargin{i},'function_handle') && ~def_exit_arg_defined)
        if(~any([strcmp(func2str(varargin{i}),'n_plus') strcmp(func2str(varargin{i}),'n_minus') strcmp(func2str(varargin{i}),'n_equals') strcmp(func2str(varargin{i}),'n_no')]))
            error('Not a valid exit function')
        end
        state.default_exit_function=varargin{i};
        def_exit_arg_defined=1;
        
    elseif(isa(varargin{i},'function_handle') && ef_defn) %new ending condition
        num_end_conds=num_end_conds+1;
        state.end_condition{num_end_conds}=varargin{i};
        ec_arg=1;
        ef_defn=0;
        
    elseif(isa(varargin{i},'function_handle') && ~ef_defn)       
        if(~any([strcmp(func2str(varargin{i}),'n_plus') strcmp(func2str(varargin{i}),'n_minus') strcmp(func2str(varargin{i}),'n_equals')]))
            error('Not a valid exit function')
        end
        state.exit_function{num_end_conds}=varargin{i};
        ef_arg=0;
        ef_defn=1;
        
    elseif(~ef_arg)
        state.exit_arg(num_end_conds)=varargin{i};
        ef_arg=1;
    else %must be an input argument for the current ending condition
        state.end_condition_args{num_end_conds}{ec_arg}=varargin{i};
        ec_arg=ec_arg+1;   
    end   
end



% if(nargin(controller_type)~=(3+length(state.cntrl_args)))
%     error('Incorrent number of arguments for the controller type');
% end

end