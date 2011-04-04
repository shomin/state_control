function stop_vicon(vicon)
%function stop_vicon(vicon)


    vicon_Values('disconnect',vicon.sid);
    vicon_Names('disconnect',vicon.nid);

end