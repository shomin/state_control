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
                1.0000    0.0006    0.0013;...
                -0.0006    1.0000    0.0027;...
                -0.0013   -0.0027    1.0000 ];           
           quad.T_rel_BV =[...
                -18.3791;...
                -12.6620;...
                20.8045];
           quad.th_trim=0;
           quad.theta_trim=0;
           quad.yaw_trim=0;
           quad.phi_trim=0;           
           quad.Body =[... 
                19.4018 -107.676 -13.5644;...
                -8.04546 5.1243 19.8073;...
                -70.054 13.0467 -13.029;...
                40.093 3.33765 20.8284;...
                18.6046 86.167 -14.0423]';
           quad.numpoints=5; % maybe take out
           quad.node_name='cmd_pdM';
           quad.lookfor='QuadrotorMike2:QuadrotorMike2 <a-X>';
          
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
 

    quad.real=1;
    
end

