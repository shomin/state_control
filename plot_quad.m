function plot_handle = plot_quad(curr_state)


blade_rad = .04;
theta = linspace(-pi/2,3*pi/2,20);
circle = blade_rad*[sin(theta);cos(theta);zeros(size(theta))];

m1(:,1) = zeros(3,1);
m1(:,2:2+length(circle)-1) = circle+repmat([.17;0;0],1,length(circle));
m1(:,end+1) = zeros(3,1);

m24 = zeros(3,0);

for idx = 1:3
    theta = pi/2*(idx);
    R = [cos(theta),-sin(theta),0;sin(theta),cos(theta),0;0,0,1];
    m24(:,(end+1):(end+size(m1,2))) = R*m1;
end



x = [curr_state.x_est curr_state.y_est curr_state.z_est]';

R = RPYtoRot(-curr_state.phi,-curr_state.theta,-curr_state.psi);

m1 = R * m1 + repmat(x,1,length(m1));
m24 = R * m24 + repmat(x,1,length(m24));

if(isempty(curr_state.plot_handle))
    plot_handle = plot3(m24(1,:),m24(2,:),m24(3,:),m1(1,:),m1(2,:),m1(3,:),'r');
else
    set(curr_state.plot_handle,'XData',m1(1,:));
    set(curr_state.plot_handle,'YData',m1(2,:));
    set(curr_state.plot_handle,'ZData',m1(3,:));
        
    set(curr_state.plot_handle(2),'XData',m24(1,:));
    set(curr_state.plot_handle(2),'YData',m24(2,:));
    set(curr_state.plot_handle(2),'ZData',m24(3,:));
    
    plot_handle=curr_state.plot_handle;
end


