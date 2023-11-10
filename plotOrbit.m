function [X Y Z] = plotOrbit(kepEl, mu, deltaTh, stepTh)
% plotOrbit.m - Plot the arc length deltaTh of the orbit described by
% kepEl.
%
% PROTOTYPE:
% plotOrbit(kepEl, mu, deltaTh, stepTh)
%
% DESCRIPTION:
% Plot the arc length of the orbit described by a set of orbital
% elements for a specific arc length.
%
% INPUT:
% kepEl [1x6] orbital elements [km,rad]
% mu [1x1] gravitational parameter [km^3/s^2]
% deltaTh [1x1] arc length [rad]
% stepTh [1x1] arc length step [rad]
%
% OUTPUT:
% X [1xn] X position [km]
% Y [1xn] Y position [km]
% Z [1xn] Z position [km]
if nargin == 2
    deltaTh = 2*pi;
    stepTh = pi/180;
elseif nargin == 3
    stepTh = pi/180;
end
th = 0:stepTh:deltaTh;
[r,v,th] = kep2car(kepEl(1),kepEl(2),kepEl(3),kepEl(4),kepEl(5),th,mu);

X = r(1,:); Y = r(2,:); Z = r(3,:);
% Call the Terra_3D Function
Terra3d;
% Plot the 3D satellite orbit
plot3(X,Y,Z,'Color',"none");
grid on;

% Define an indefinite plot
v_view = [45 30 30];
h = plot3(nan,nan,nan,'or','MarkerFaceColor',"#77AC30",'MarkerEdgeColor',"#77AC30",'MarkerSize',10);
hold on;
traj = plot3(nan,nan,nan,'Color',"#A2142F");
view(v_view);
% Define the step animation
step_animation = 10;
% Define the moving point
if deltaTh == 2*pi
    n_orbit = input("Numero di orbite: ");
else
    n_orbit = 1;
end
mom = norm(cross(r(:,1),v(:,1)));
if kepEl(2) == 0
    delta_t = mom^3/mu^2*stepTh*1e-7;
elseif kepEl(2) == 1
    t = [0 mom^3/mu^2*(0.5.*tan(th*0.5)+1/6.*tan(th*0.5).^3)];
    delta_t = (t(2:end)-t(1:end-1)).*1e-2;
elseif kepEl(2) < 1
    e = kepEl(2);
    t = (1/(1-e^2).^(3/2)).*(2.*atan(sqrt((1-e)./(1+e)).*tan(th.*0.5))-e.*sqrt(1-e^2).*sin(th)./(1+e.*cos(th)));
    t = [t(1) t];
    delta_t = (t(2:end)-t(1:end-1))*1e2;
    guess = find(delta_t<0);
    delta_t(guess) = delta_t(guess-1);
    [~,guess] = min(delta_t);
    delta_t(guess) = delta_t(guess+1);
    delta_t = delta_t.*1e-3;
end


for j = 1 :step_animation: n_orbit
    for i = 1:length(th)
        set(traj,'XData',X(1:i),'YData',Y(1:i),'ZData',Z(1:i));
        hold on;
        set(h,'XData',X(i),'YData',Y(i),'ZData',Z(i));
        drawnow
        
        pause(delta_t);
        
    end
    hold off
    
end