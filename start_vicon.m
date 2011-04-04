function vicon = start_vicon()

    vicon.sid = vicon_Values('connect','subscriber','asdf','values');
    vicon.nid = vicon_Names('connect','subscriber','asdf2','names');
    pause(1.2)
    vicon.nmsg = vicon_Names('read',nid,10);
    
end