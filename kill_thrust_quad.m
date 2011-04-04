function kill_thrust_quad(quad)
%function stop_quad(quad)

    pd_cmd = asctec_PDCmd('empty');


    pd_cmd.thrust = 0;
    pd_cmd.roll = 0;
    pd_cmd.pitch = 0;
    disp(['Sending Zero Thrust to ' quad.name  ]);
    
    asctec_PDCmd('send', quad.pd_id, pd_cmd);
    asctec_PDCmd('send', quad.pd_id, pd_cmd);
    asctec_PDCmd('send', quad.pd_id, pd_cmd);
    asctec_PDCmd('send', quad.pd_id, pd_cmd);

    
    