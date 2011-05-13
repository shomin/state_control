
circle_center=[0 0 1.5 0];


traj_speed = .5;
traj_accel = .3;


radius=.8;
turns=1;
helix_height = .5;


%fix this
num_pts=1000;


d_height = 0: (helix_height / num_pts) : helix_height;

t=0:(turns*2*pi/num_pts):turns*2*pi;

helix=[radius.*-cos(t)' radius.*sin(t)' d_height' zeros(length(t),1)];
traj=repmat(circle_center ,length(t),1)+helix;



dt = norm(traj(1,1:3) - traj(2,1:3))/traj_speed
traj=[traj (dt:dt:dt*length(t))'];


% (sqrt(sum(diff(traj(:,1:3)).^2,2))./diff(traj(:,5)));


dists=sqrt(sum(diff(traj(:,1:3)).^2,2));

v0=0;
v1=traj_speed;

t_ramp = (v1 - v0) / traj_accel;
d_ramp = (v0*t_ramp) + (.5*traj_accel*(t_ramp^2));

if(d_ramp<sum(dists))
    disp('ramp up feasible');
end


dist=0;
ind=1;
total_dist=[];
while(dist<d_ramp)
    dist=dist+dists(ind);
    total_dist(ind) = dist;
    ind=ind+1;
end

replace_to=ind

ramp_up=[zeros(ceil(t_ramp/dt)-1,4) dt.*(0:ceil(t_ramp/dt)-2)'];



for i = 1:ceil(t_ramp/dt)-1
    t_now=dt*i;
    d_now = (v0*t_now) + (.5*traj_accel*(t_now^2));

    ind = find(total_dist>d_now,1,'first');

    if(0)%ind==1)
        ramp_up(i,1:4) = traj(1,1:4);
    else
%         pct =  (d_now-total_dist(ind-1)) / (total_dist(ind) - total_dist(ind-1));
        pct =  (d_now-total_dist(ind)) / (total_dist(ind+1) - total_dist(ind));
        ramp_up(i,1:4) = traj(ind,1:4) + ((traj(ind+1,1:4) - traj(ind,1:4)).*pct);
    end
end

time_shift = (2.5*dt)+ ramp_up(end,5) - traj(replace_to,5);

new_traj = [ramp_up;...
    traj(replace_to-1:end,1:4), traj(replace_to-1:end,5)+time_shift];


x=(sqrt(sum(diff(new_traj(:,1:3)).^2,2))./diff(new_traj(:,5)));
plot(x)

% traj_start=traj(1,1:4)