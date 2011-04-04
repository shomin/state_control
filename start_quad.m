function quad = start_quad(quad_name, vicon)
%function quad = start_quad(quad_name, vicon)


    switch lower(quad_name)
       case 'kilo'
           disp('Initializing Kilo');
            quad.name='kilo';
            quad.QuadB_R_QuadBV =[...
                0.9693   -0.2458    0.0074 ;...
                0.2457    0.9692    0.0165 ;...
               -0.0113   -0.0142    0.9998 ];
            quad.T_rel_BV=[...
               38.4301 ;...
                0.4528 ;...
               55.6232 ];
            quad.th_trim=0;
            quad.theta_trim=0;
            quad.yaw_trim=0;
            quad.phi_trim=0;
            quad.Body = [...
                -117.346 -8.06174 -6.04038;...
                -1.53775 -43.8166 27.6408;...
                -22.1789 91.4266 -7.2163;...
                53.5173 -18.6318 -7.00836;...
                87.5452 -20.9165 -7.3758]';
            quad.numpoints=5; % maybe take out
            quad.node_name='cmd_pdK';
            quad.lookfor='QuadrotorKilo2:QuadrotorKilo2 <a-X>';
        
       case 'mike'
           disp('Initializing Mike'); 
           quad.name='mike';
           quad.QuadB_R_QuadBV =[...
                0.9729   -0.2313    0.0013 ;...
                0.2313    0.9729    0.0071 ;...
               -0.0029   -0.0066    1.0000 ];           
           quad.T_rel_BV =[...
              -18.0107 ;...
                6.1114 ;...
               21.0446 ];
           quad.th_trim=0;
           quad.theta_trim=0;
           quad.yaw_trim=0;
           quad.phi_trim=0;           
           quad.Body =[... 
               -69.8347, 13.7009, -13.7766;...
               -9.6881, -7.0711, 20.7206;...
               36.6284, -20.2929, 20.7456;...
               -5.8076, -107.1541, -14.7629;...
               48.7021, 120.8172, -12.9266]';
           quad.numpoints=5; % maybe take out
           quad.node_name='cmd_pdM';
           quad.lookfor='QuadrotorMike:QuadrotorMike <a-X>';
          
       otherwise
          error('Not one of the quads')
          
    end


    
    %--------------------
    %TODO - My god, clean this up
    %--------------------
    
    quad.pd_id = asctec_PDCmd('connect','publisher','matlab_pd_cmd',quad.node_name);
    
    
    pd_cmd = asctec_PDCmd('empty');
    asctec_PDCmd('send', quad.pd_id, pd_cmd);


   
    num_names = size(vicon.nmsg.names,2);

    for i=1:num_names
        found = strcmp(vicon.nmsg.names{i},quad.lookfor);
        if (found)
            axstart = i;
        end
    end
    
    quad.vicon_start_address = axstart - 4*quad.numpoints;
 

end

