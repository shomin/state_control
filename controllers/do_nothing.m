function [pd_cmd curr_state] = do_nothing(curr_state, quad, gains)
%function pd_cmd = do_nothing(curr_state, quad, gains)

    pd_cmd = asctec_PDCmd('empty');

end