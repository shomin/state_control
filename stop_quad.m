function stop_quad(quad)
%function stop_quad(quad)




    pd_cmd.thrust = 0;
    pd_cmd.roll = 0;
    pd_cmd.pitch = 0;
    asctec_PDCmd('send', quad.pd_id, pd_cmd);
    pause(.1)
    asctec_PDCmd('send', quad.pd_id, pd_cmd);
    pause(.1)
    asctec_PDCmd('send', quad.pd_id, pd_cmd);
    pause(.1)
    asctec_PDCmd('send', quad.pd_id, pd_cmd);




    asctec_PDCmd('disconnect',quad.pd_id);
    
    