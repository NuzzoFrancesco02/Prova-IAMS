% PROVA FINALE
mu = 398600;
stepTh= pi/100;
%% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;

% Economica
% apo-peri
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = af*(1+ef); 
at = (rai+rpf)/2; et = (rai-rpf)/(rai+rpf);
D_v1 = sqrt(2*mu*(1/rai-1/(2*at)))-sqrt(2*mu*(1/rai-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/rpf-1/(2*af)))-sqrt(2*mu*(1/rpf-1/(2*at)));
D_v_a_p = abs(D_v1)+abs(D_v2);
D_t = timeOfFlight(ai,ei,th_i,pi,mu)+pi*(sqrt(at^3/mu));
th1 = th_i:stepTh:pi; tht = th1(end)-2*pi:stepTh:0; 
D_v = abs(D_v_a_p);
% Cambio all'apogeo: D_i > 0; D_OM > 0;
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
% Calcolo costo manovra
p = af*(1-ef^2);
D_v = D_v + abs(2*sqrt(mu/p)*(1+ef*cos(th_man_1))*sin(alpha/2));
th2 = tht(end):stepTh:th_man_1;
D_t = D_t + timeOfFlight(af,ef,0,th_man_1,mu);
% Cambio periasse
d_om = om_f-om2+2*pi;
th1_m = d_om/2; 
th2_m = 2*pi-d_om/2;
D_v = D_v + abs(2*sqrt(mu/p)*ef*sin(th1_m));
th3 = th_man_2:stepTh:th1_m+2*pi;
D_t = D_t + timeOfFlight(af,ef,th_man_2,th1_m,mu);
th4 = th2_m:stepTh:th_f+2*pi;
D_t = D_t + timeOfFlight(af,ef,th2_m,th_f,mu);
D_t
D_v

[r1,v1] = kep2car(ai,ei,i_i,OM_i,om_i,th1,mu); %arrivo apogeo
[r2,v2] = kep2car(at,et,i_i,OM_i,om_i,tht,mu); %bitangente
[r3,v3] = kep2car(af,ef,i_i,OM_i,om_i,th2,mu); % arrivo cambio piano
[r4,v4] = kep2car(af,ef,i_f,OM_f,om2,th3,mu); % arrivo cambio periasse
[r5,v5] = kep2car(af,ef,i_f,OM_f,om_f,th4,mu); %arrivo punto finale

r_tot = struct('r1',r1,'r2',r2,'r3',r3,'r4',r4,'r5',r5);
v_tot = struct('v1',v1,'v2',v2,'v3',v3,'v4',v4,'v5',v5);
col = ["#0072BD","#77AC30","#D95319","#4DBEEE","#A2142F"];
leg = ["Approach to apocenter","Bitangent transfer","Waiting change of plane","Waiting change of periapsis","Approach final point"];
view_vec = [260,-5];
plot_orbit(r_tot,v_tot,col,leg,view_vec,'exp');
%%
clear
clc
mu = 398600;
stepTh= pi/100;
% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;

% Economica
% apo-peri
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = af*(1+ef); 
at = (rai+rpf)/2; et = (rai-rpf)/(rai+rpf);
D_v1 = sqrt(2*mu*(1/rai-1/(2*at)))-sqrt(2*mu*(1/rai-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/rpf-1/(2*af)))-sqrt(2*mu*(1/rpf-1/(2*at)));
D_v_a_p = abs(D_v1)+abs(D_v2);
D_t = timeOfFlight(ai,ei,th_i,pi,mu)+pi*(sqrt(at^3/mu));
th1 = th_i:stepTh:pi; tht = th1(end)-2*pi:stepTh:0; 
D_v = abs(D_v_a_p);
% Cambio all'apogeo: D_i > 0; D_OM > 0;
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
% Calcolo costo manovra
p = af*(1-ef^2);
D_v = D_v + abs(2*sqrt(mu/p)*(1+ef*cos(th_man_1))*sin(alpha/2));
th2 = tht(end):stepTh:th_man_1;
D_t = D_t + timeOfFlight(af,ef,0,th_man_1,mu);
% Cambio periasse
d_om = om_f-om2+2*pi;
th1_m = pi+d_om/2; 
th2_m = pi-d_om/2;
D_v = D_v + abs(2*sqrt(mu/p)*ef*sin(th1_m));
th3 = th_man_2:stepTh:th1_m;
D_t = D_t + timeOfFlight(af,ef,th_man_2,th1_m,mu);
th4 = th2_m:stepTh:th_f+2*pi;
D_t = D_t + timeOfFlight(af,ef,th2_m,th_f,mu);
D_t
D_v

[r1,v1] = kep2car(ai,ei,i_i,OM_i,om_i,th1,mu); %arrivo apogeo
[r2,v2] = kep2car(at,et,i_i,OM_i,om_i,tht,mu); %bitangente
[r3,v3] = kep2car(af,ef,i_i,OM_i,om_i,th2,mu); % arrivo cambio piano
[r4,v4] = kep2car(af,ef,i_f,OM_f,om2,th3,mu); % arrivo cambio periasse
[r5,v5] = kep2car(af,ef,i_f,OM_f,om_f,th4,mu); %arrivo punto finale

r_tot = struct('r1',r1,'r2',r2,'r3',r3,'r4',r4,'r5',r5);
v_tot = struct('v1',v1,'v2',v2,'v3',v3,'v4',v4,'v5',v5);
col = ["#0072BD","#77AC30","#D95319","#4DBEEE","#A2142F"];
leg = ["Approach apocenter","Bitangent transfer","Waiting change of plane","Waiting change of periapsis","Approach final point"];
view_vec = [-1.656559270276668e+02,7.017518180556356];
plot_orbit(r_tot,v_tot,col,leg,view_vec);