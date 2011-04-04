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

num_end_conds=0; % initialize to no ending conditions

for i=1:length(varargin)
    if(num_end_conds==0 && ~isa(varargin{i},'function_handle')) %no ending conditions yet; these must be controller input variables
        state.cntrl_args{i}=varargin{i};
        
    elseif(isa(varargin{i},'function_handle')) %new ending condition
        num_end_conds=num_end_conds+1;
        state.end_condition{num_end_conds}=varargin{i};
        ec_arg=1;
        
    else %must be an input argument for the current ending condition
        state.end_condition_args{num_end_conds}{ec_arg}=varargin{i};
        ec_arg=ec_arg+1;
    end   
end



% if(nargin(controller_type)~=(3+length(state.cntrl_args)))
%     error('Incorrent number of arguments for the controller type');
% end

end