function log = quad_read_log(filename)
%function log = quad_read_log(filename)
    

    data_length=20;

    log=zeros(1,data_length);
    
    i=1;
    
    fid=fopen(filename);
    while(~feof(fid))
        
        data=fread(fid,data_length,'double');
        
        if(isempty(data))
            disp('reached EOF');
            break;
        elseif(length(data)<data_length)
            error('file terminated unexpectedly');
            break;
        end
        
        log(i,:)=data';
        i=i+1;
    end
    
    
    fclose(fid);
    disp('Closed file');
end