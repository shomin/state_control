function key = one_key()
    
    key=[];
    
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    
    if(keyIsDown)
        keys=KbName(keyCode);            
            if(iscell(keys))
                key=keys{1};
            else
                key=keys;
            end        
    end
    
