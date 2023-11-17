% PROVA FINALE
mu = 398600;
stepTh= pi/90;
%% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;

% cambio piano nel primo punto di manovra, il cambio avviene subito poich°
% il semiasse iniziale è minore e quindi impiega meno tempo
%% Cambio all'apogeo: D_i > 0; D_OM > 0;
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
% Calcolo parametri orbite
th_man_1 = u_i-om_i;
th_man_2 = th_man_1;
om2 = u_f - th_man_2 + 2*pi;
th_man_1 = th_man_1 + pi;
th_man_2 = th_man_2 + pi;
% Calcolo costo manovra
p = af*(1-ef^2);
D_v = abs(2*sqrt(mu/p)*(1+ef*cos(pi))*sin(alpha/2));
th1 = th_i:stepTh:th_man_1;
D_t =  timeOfFlight(ai,ei,th_i,th_man_1,mu);
%% Cambio secante
p_i = ai*(1-ei^2); p_f = af*(1-ef^2); d_om = om_f-om2;
fun = @(th) p_i*(1+ef*cos(th-d_om))-p_f*(1+ei*cos(th));
th_1 = fsolve(fun, 0); th_2 = th_1-d_om;
th2 = th_man_2:stepTh:th_1+2*pi;
D_t = D_t + timeOfFlight(ai,ei,th_man_2,th_1,mu);
th3 = th_2:stepTh:th_f+2*pi;
D_t = D_t + timeOfFlight(af,ef,th_2,th_f,mu)


%% PLOT transf veloce
r1 = kep2car(ai,ei,i_i,OM_i,om_i,th1,mu);
%rt1 = kep2car(at,et,i_i,OM_i,om_i,tht,mu);
r2 = kep2car(ai,ei,i_f,OM_f,om2,th2,mu);
r3 = kep2car(af,ef,i_f,OM_f,om_f,th3,mu);
%r4 = kep2car(af,ef,i_f,OM_f,om_f,th4,mu);
r_tot = [r1 r2 r3];
h = plot3(nan,nan,nan,'LineWidth',2,'Marker','o','MarkerSize',10,'Color','black','MarkerFaceColor','black');
hold on;
grid on;
traj = plot3(nan,nan,nan,'LineWidth',2);
plot3(r_tot(1,:),r_tot(2,:),r_tot(3,:),'LineWidth',0.1,'LineStyle','--')

Terra3d;
circular_plane(max(max(abs(r_tot(1:2,:))))*1.5,0);

for i = 1 : size(r1,2)
    plot3(r1(1,1:i),r1(2,1:i),r1(3,1:i),'LineWidth',2,'Color',"#D95319");
    set(h,'XData',r1(1,i),'YData',r1(2,i),'ZData',r1(3,i));
    drawnow
    pause(.0001)
end
% for i = 1 : size(rt1,2)
%     plot3(rt1(1,1:i),rt1(2,1:i),rt1(3,1:i),'LineWidth',2,'Color',"#77AC30");
%     set(h,'XData',rt1(1,i),'YData',rt1(2,i),'ZData',rt1(3,i));
%     drawnow
%     pause(.0001)
% end
for i = 1 : size(r2,2)
    plot3(r2(1,1:i),r2(2,1:i),r2(3,1:i),'LineWidth',2,'Color',"#0072BD");
    set(h,'XData',r2(1,i),'YData',r2(2,i),'ZData',r2(3,i));
    drawnow
    pause(.0001)
end
for i = 1 : size(r3,2)
    plot3(r3(1,1:i),r3(2,1:i),r3(3,1:i),'LineWidth',2,'Color',"#D95319");
    set(h,'XData',r3(1,i),'YData',r3(2,i),'ZData',r3(3,i));
    drawnow
    pause(.0001)
end
% for i = 1 : size(r4,2)
%     plot3(r4(1,1:i),r4(2,1:i),r4(3,1:i),'LineWidth',2,'Color',"#0072BD");
%     set(h,'XData',r4(1,i),'YData',r4(2,i),'ZData',r4(3,i));
%     drawnow
%     pause(.0001)
% end