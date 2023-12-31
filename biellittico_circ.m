% BIELLITTICO
mu = 398600;
stepTh= pi/10;
%% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = af*(1+ef);
%% cambio piano 
%% Calcolo alpha, u_i, u_f
D_i = i_f-i_i; D_OM = OM_f-OM_i; 
alpha = acos(cos(i_i)*cos(i_f)+sin(i_i)*sin(i_f)*cos(D_OM));
% Calcolo u_i
cos_ui = (cos(alpha)*cos(i_i)-cos(i_f))/(sin(alpha)*sin(i_i));
sin_ui = sin(i_f)*sin(D_OM)/sin(alpha);
u_i = atan2(sin_ui,cos_ui);
% Calcolo u_f
cos_uf = (cos(i_i)-cos(alpha)*cos(i_f))/(sin(alpha)*sin(i_f));
sin_uf = sin(i_i)*sin(D_OM)/sin(alpha);
u_f = atan2(sin_uf,cos_uf);
%% cambio periasse per avere cambio piano nei punti absidali
om_cp = u_i; d_om = om_cp-om_i;
th_peri_1 = pi+d_om/2; th_peri_2 = pi-d_om/2; p = ai*(1-ei^2);
D_v = abs(2*sqrt(mu/p)*ei*sin(th_peri_1)); 
th1 = th_i:stepTh:th_peri_1;
D_t = timeOfFlight(ai,ei,th_i,th_peri_1,mu);
th2 = th_peri_2:stepTh:2*pi;
D_t = D_t + timeOfFlight(ai,ei,th_peri_2,2*pi,mu);
th_man_1 = u_i-om_cp;
th_man_2 = th_man_1;
om2 = u_f - th_man_2 + 2*pi;
%% bitangente
r_bit = 1e5;
abit = (r_bit+rpi)/2; ebit = (r_bit-rpi)/(r_bit+rpi);
tht1 = 0:stepTh:pi; 
tht2 = pi:stepTh:2*pi;
D_t = D_t + timeOfFlight(abit,ebit,0,2*pi,mu);
p = abit*(1-ebit^2);
D_v = D_v + abs(2*sqrt(mu/p)*(1+ebit*cos(pi))*sin(alpha/2));
D_v = D_v + 2*abs(sqrt(2*mu*(1/rpi-1/(2*abit)))-sqrt(2*mu*(1/rpi-1/(2*ai))));

%% cambio periasse finale (prima del cambio forma poiche e è più bassa)
d_om = om_f-om2+2*pi;
th_peri_1 = d_om/2; th_peri_2 = 2*pi-d_om/2;
D_v = D_v + abs(2*sqrt(mu/p)*ei*sin(th_peri_1));
th3 = 0:stepTh:th_peri_1; 
D_t = D_t + timeOfFlight(ai,ei,0,th_peri_1,mu);
th4 = th_peri_2:stepTh:2*pi;
D_t = D_t + timeOfFlight(ai,ei,th_peri_2,2*pi,mu);
%% Peri-Apo
at = (raf+rpi)/2; et = (raf-rpi)/(raf+rpi);
D_v1 = sqrt(2*mu*(1/rpi-1/(2*at)))-sqrt(2*mu*(1/rpi-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/raf-1/(2*af)))-sqrt(2*mu*(1/raf-1/(2*at)));
D_v = D_v + abs(D_v1)+abs(D_v2);
tht3 = 0:stepTh:pi; th5 = pi:stepTh:2*pi+th_f;
D_t = D_t + timeOfFlight(af,ef,pi,th_f,mu)+pi*(sqrt(at^3/mu));

th_plot = 0:0.01:2*pi; th_bit_1 = 0:stepTh:2*pi; th_bit_2 = 0:stepTh:2*pi;
Terra3d; circular_plane(4e4,0);
r1 = kep2car(ai,ei,i_i,OM_i,om_i,th1,mu); % arrivo a cambio primo periasse
r2 = kep2car(ai,ei,i_i,OM_i,om_cp,th2,mu); % arrivo a perigeo
rt1 = kep2car(abit,ebit,i_i,OM_i,om_cp,tht1,mu); % biellittico 1
rt2 = kep2car(abit,ebit,i_f,OM_f,om2,tht2,mu); % biellittico 2
r3 = kep2car(ai,ei,i_f,OM_f,om2,th3,mu); % arrivo a cambio secondo periasse
r4 = kep2car(ai,ei,i_f,OM_f,om_f,th4,mu); % arrivo a perigeo
rt3 = kep2car(at,et,i_f,OM_f,om_f,tht3,mu); % bitangente 3
r5 = kep2car(af,ef,i_f,OM_f,om_f,th5,mu); % arrivo th finale
r_tot = [r1 r2 rt1 rt2 r3 r4 rt3 r5];

h = plot3(nan,nan,nan,'LineWidth',2,'Marker','o','MarkerSize',5,'Color','black','MarkerFaceColor','black');
hold on;
grid on;
traj = plot3(nan,nan,nan,'LineWidth',2);
plot3(r_tot(1,:),r_tot(2,:),r_tot(3,:),'LineWidth',0.1,'LineStyle','--')
for i = 1 : size(r1,2)
    plot3(r1(1,1:i),r1(2,1:i),r1(3,1:i),'LineWidth',2,'Color',"#D95319");
    set(h,'XData',r1(1,i),'YData',r1(2,i),'ZData',r1(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(r2,2)
    plot3(r2(1,1:i),r2(2,1:i),r2(3,1:i),'LineWidth',2,'Color',"#0072BD");
    set(h,'XData',r2(1,i),'YData',r2(2,i),'ZData',r2(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(rt1,2)
    plot3(rt1(1,1:i),rt1(2,1:i),rt1(3,1:i),'LineWidth',2,'Color',"#77AC30");
    set(h,'XData',rt1(1,i),'YData',rt1(2,i),'ZData',rt1(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(rt2,2)
    plot3(rt2(1,1:i),rt2(2,1:i),rt2(3,1:i),'LineWidth',2,'Color',"#77AC30");
    set(h,'XData',rt2(1,i),'YData',rt2(2,i),'ZData',rt2(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(r3,2)
    plot3(r3(1,1:i),r3(2,1:i),r3(3,1:i),'LineWidth',2,'Color',"#D95319");
    set(h,'XData',r3(1,i),'YData',r3(2,i),'ZData',r3(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(r4,2)
    plot3(r4(1,1:i),r4(2,1:i),r4(3,1:i),'LineWidth',2,'Color',"#0072BD");
    set(h,'XData',r4(1,i),'YData',r4(2,i),'ZData',r4(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(rt3,2)
    plot3(rt3(1,1:i),rt3(2,1:i),rt3(3,1:i),'LineWidth',2,'Color',"#77AC30");
    set(h,'XData',rt3(1,i),'YData',rt3(2,i),'ZData',rt3(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(r5,2)
    plot3(r5(1,1:i),r5(2,1:i),r5(3,1:i),'LineWidth',2,'Color',"#D95319");
    set(h,'XData',r5(1,i),'YData',r5(2,i),'ZData',r5(3,i));
    drawnow
    pause(.0001)
end
grid on;