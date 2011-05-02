
while(1)    
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    
    if(keyIsDown)
        keys=KbName(keyCode);
            disp(keys);
            
            if(iscell(keys))
                if(keys{1}=='q')
                    break
                end
            elseif(keys == 'q')
                break
            end
        
    end
    
end