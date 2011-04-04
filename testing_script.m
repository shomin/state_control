gains.kp_x = 0.35/(0.7^2);
gains.kd_x = 0.35/(0.7);
gains.kp_y = 0.35/(0.7^2);
gains.kd_y = 0.35/(0.7);
gains.kp_z = 20/(0.3^2);
gains.kd_z = 20/(0.3);


%start_quad will do all of this (but correctly obviously)
kilo.pd_id=1;
kilo.vicon_start_address=50;
kilo.numpoints=5; % maybe take out
kilo.QuadB_R_QuadBV =[...
    0.9693   -0.2458    0.0074 ;...
    0.2457    0.9692    0.0165 ;...
   -0.0113   -0.0142    0.9998 ];
kilo.T_rel_BV=[...
   38.4301 ;...
    0.4528 ;...
   55.6232 ];
kilo.th_trim=0;
kilo.theta_trim=0;
kilo.yaw_trim=0;
kilo.phi_trim=0;
kilo.Body = [...
    -117.346 -8.06174 -6.04038;...
    -1.53775 -43.8166 27.6408;...
    -22.1789 91.4266 -7.2163;...
    53.5173 -18.6318 -7.00836;...
    87.5452 -20.9165 -7.3758]';