% BIELLITTICO
clear
clc
mu = 398600;
stepTh= pi/180;
% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = af*(1+ef); pf = af*(1-ef^2);
% cambio piano 
% Calcolo alpha, u_i, u_f
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
% cambio periasse per avere cambio piano nei punti absidali
om_cp = u_i; d_om = om_cp-om_i;
th_peri_1 = pi+d_om/2; th_peri_2 = pi-d_om/2; p = ai*(1-ei^2);
D_v = abs(2*sqrt(mu/p)*ei*sin(d_om/2)); 
th1 = th_i:stepTh:th_peri_1;
D_t = timeOfFlight(ai,ei,th_i,th_peri_1,mu);
th2 = th_peri_2:stepTh:2*pi;
D_t = D_t + timeOfFlight(ai,ei,th_peri_2,2*pi,mu);
th_man_1 = u_i-om_cp;
th_man_2 = th_man_1;
om2 = u_f - th_man_2 + 2*pi;
% bitangente
r_bit = 1e5;
abit1 = (r_bit+rpi)/2; ebit1 = (r_bit-rpi)./(r_bit+rpi);
abit2 = (r_bit+rpf)/2; ebit2 = (r_bit-rpf)./(r_bit+rpf);
p1 = abit1.*(1-ebit1.^2); p2 = abit2.*(1-ebit2.^2);
D_v_plane = abs(2*sqrt(mu./p1).*(1+ebit1.*cos(pi)).*sin(alpha/2));
D_v = D_v + D_v_plane; %D_v cambio piano
tht1 = th2(end)-2*pi:stepTh:pi; 
tht2 = pi:stepTh:2*pi;
D_t = D_t + timeOfFlight(abit1,ebit1,0,pi,mu);
D_t = D_t + timeOfFlight(abit2,ebit2,pi,2*pi,mu);
D_v = D_v + abs(sqrt(2*mu*(1./rpi-1./(2*abit1)))-sqrt(2*mu*(1./rpi-1./(2*ai)))); %D_v primo ramo biellittico
D_v = D_v + abs(sqrt(2*mu*(1./r_bit-1./(2*abit2)))-sqrt(2*mu*(1./r_bit-1./(2*abit1)))); %D_v secondo ramo biellittico
D_v = D_v + abs(sqrt(2*mu*(1./rpf-1./(2*af)))-sqrt(2*mu*(1./rpf-1./(2*abit2)))); %D_v forma finale

% cambio periasse finale
d_om = om_f-om2+2*pi;
th_peri_1 = d_om/2; th_peri_2 = 2*pi-d_om/2;
D_v = D_v + abs(2*sqrt(mu/pf)*ef*sin(d_om/2));
th3 = 0:stepTh:th_peri_1; %arrivo cambio periasse
D_t = D_t + timeOfFlight(af,ef,0,th_peri_1,mu);
th4 = th_peri_2:stepTh:th_f+2*pi; % arrivo punto finale
D_t = D_t + timeOfFlight(af,ef,th_peri_2,th_f,mu);

%%
th_plot = 0:0.01:2*pi; th_bit_1 = 0:stepTh:2*pi; th_bit_2 = 0:stepTh:2*pi;
[r1,v1] = kep2car(ai,ei,i_i,OM_i,om_i,th1,mu); % arrivo a cambio primo periasse
[r2,v2] = kep2car(ai,ei,i_i,OM_i,om_cp,th2,mu); % arrivo a perigeo
[r3,v3] = kep2car(abit1,ebit1,i_i,OM_i,om_cp,tht1,mu); % biellittico 1
[r4,v4] = kep2car(abit2,ebit2,i_f,OM_f,om2,tht2,mu); % biellittico 2
[r5,v5] = kep2car(af,ef,i_f,OM_f,om2,th3,mu); % arrivo a cambio secondo periasse
[r6,v6] = kep2car(af,ef,i_f,OM_f,om_f,th4,mu); % arrivo a punto finale

r_tot = struct('r1',r1,'r2',r2,'r3',r3,'r4',r4,'r5',r5,'r6',r6);
v_tot = struct('v1',v1,'v2',v2,'v3',v3,'v4',v4,'v5',v5,'v6',v6);
col = ["#0072BD","#77AC30","#D95319","#4DBEEE","#A2142F","#EDB120"];
leg = ["Waiting change of periapsis 1","Approach to pericenter","First bielliptic","Second bielliptic","Waiting change of periapsis 2","Approach final point"];
view_vec = [-53.6563,13.486];
plot_orbit(r_tot,v_tot,col,leg,view_vec,'exp');
