function [BodyGood,World] = match_quad(msg,quad)

Body = quad.Body;
numpoints = quad.numpoints;
startpoint=quad.vicon_startaddress;


BodyGood = [];
World = [];

cnt=0;
for i=1:numpoints
    if(msg.values(startpoint+4*i-1)~=1)
        %this means the point is being seen
        cnt = cnt+1;
        BodyGood(:,cnt) = Body(:,i);
        World(:,cnt) = msg.values((startpoint+4*i-4):(startpoint+4*i-2))';
    end
end