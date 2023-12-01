%% Standard
mu = 398600;
stepTh= pi/90;
%% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);
%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.3860; i_f = 1.4840; OM_f = 2.7570; om_f = 0.9111; th_f = 0.2903;
%% Cambio di piano: D_i > 0; D_OM > 0;
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
th_man_1 = th_man_1 + pi; th_man_2 = th_man_1;
% Calcolo costo manovra
p = ai*(1-ei^2);
D_v = abs(2*sqrt(mu/p)*(1+ei*cos(th_man_1))*sin(alpha/2));
th1 = th_i:stepTh:th_man_1;
D_t = timeOfFlight(ai,ei,th_i,th_man_1,mu);
%% Cambio periasse
d_om = om_f-om2+2*pi;
th1_m = d_om/2; 
th2_m = 2*pi-d_om/2;
D_v = D_v + abs(2*sqrt(mu/p)*ei*sin(th1_m));
th2 = th_man_2:stepTh:th1_m+2*pi;
D_t = D_t + timeOfFlight(ai,ei,th_man_2,th1_m,mu);
th3 = th2_m:stepTh:2*pi;
D_t = D_t + timeOfFlight(ai,ei,th2_m,2*pi,mu);
%% Cambio forma
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = af*(1+ef); 
at = (raf+rpi)/2; et = (raf-rpi)/(raf+rpi);
D_t = D_t + pi*(sqrt(at^3/mu));
tht = th3(end)-2*pi:stepTh:pi; 
th4 = tht(end):stepTh:th_f+2*pi;
D_v1 = sqrt(2*mu*(1/rpi-1/(2*at)))-sqrt(2*mu*(1/rpi-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/raf-1/(2*af)))-sqrt(2*mu*(1/raf-1/(2*at)));
D_v_p_a = abs(D_v1)+abs(D_v2);
D_v = D_v + abs(D_v_p_a)
D_t = D_t + timeOfFlight(af,ef,pi,th_f,mu)

[r1,v1] = kep2car(ai,ei,i_i,OM_i,om_i,th1,mu); % arrivo al cambio piano
[r2,v2] = kep2car(ai,ei,i_f,OM_f,om2,th2,mu); % arrivo al cambio di periasse
[r3,v3] = kep2car(ai,ei,i_f,OM_f,om_f,th3,mu); % arrivo al pericentro
[r4,v4] = kep2car(at,et,i_f,OM_f,om_f,tht,mu); % trasferimento
[r5,v5] = kep2car(af,ef,i_f,OM_f,om_f,th4,mu); % arrivo punto finale

r_tot = struct('r1',r1,'r2',r2,'r3',r3,'r4',r4,'r5',r5);
v_tot = struct('v1',v1,'v2',v2,'v3',v3,'v4',v4,'v5',v5);
col = ["#0072BD","#77AC30","#D95319","#4DBEEE","#A2142F"];
leg = ["Waiting change of plane","Waiting change of periaspis","Approach to pericenter ","Transfer orbit","Approach final point"];
view_vec = [280,-5];
plot_orbit(r_tot,v_tot,col,leg,view_vec);


