%% Plot biellittico 
mu = 398600;
%% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = af*(1+ef); pf = af*(1-ef^2);

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
th_man_1 = u_i-om_cp;
th_man_2 = th_man_1;
om2 = u_f - th_man_2 + 2*pi;
%% bitangente
r_bit = (1:100).*1e5;
abit = (r_bit+rpi)/2; ebit = (r_bit-rpi)./(r_bit+rpi);
p = abit.*(1-ebit.^2);
D_v = D_v + abs(2*sqrt(mu./p).*(1+ebit.*cos(pi)).*sin(alpha/2));
D_v = D_v + 2*abs(sqrt(2*mu*(1./rpi-1./(2*abit)))-sqrt(2*mu*(1./rpi-1./(2*ai))));
%% cambio periasse finale (prima del cambio forma poiche e è più bassa)
d_om = om_f-om2+2*pi;
th_peri_1 = d_om/2; th_peri_2 = 2*pi-d_om/2;
D_v = D_v + abs(2*sqrt(mu./p)*ei*sin(th_peri_1));
%% Peri-Apo
at = (raf+rpi)/2; et = (raf-rpi)/(raf+rpi);
D_v1 = sqrt(2*mu*(1/rpi-1/(2*at)))-sqrt(2*mu*(1/rpi-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/raf-1/(2*af)))-sqrt(2*mu*(1/raf-1/(2*at)));
D_v = D_v + abs(D_v1)+abs(D_v2);
figure()
x = 1:length(D_v);
plot(r_bit,D_v,'LineWidth',2)

clear
clc
%% Plot biellittico 
mu = 398600;
%% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = af*(1+ef); pf = af*(1-ef^2);

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
D_v = abs(2*sqrt(mu/p)*ei*sin(d_om/2)); %D_v primo cambio periasse 
th_man_1 = u_i-om_cp;
th_man_2 = th_man_1;
om2 = u_f - th_man_2 + 2*pi;
%% bitangente
r_bit = (1:100).*1e5;
abit1 = (r_bit+rpi)/2; ebit1 = (r_bit-rpi)./(r_bit+rpi);
abit2 = (r_bit+rpf)/2; ebit2 = (r_bit-rpf)./(r_bit+rpf);
p1 = abit1.*(1-ebit1.^2); p2 = abit2.*(1-ebit2.^2);
D_v_plane = abs(2*sqrt(mu./p).*(1+ebit1.*cos(pi)).*sin(alpha/2));
D_v = D_v + D_v_plane; %D_v cambio piano
D_v = D_v + abs(sqrt(2*mu*(1./rpi-1./(2*abit1)))-sqrt(2*mu*(1./rpi-1./(2*ai)))); %D_v primo ramo biellittico
D_v = D_v + abs(sqrt(2*mu*(1./r_bit-1./(2*abit2)))-sqrt(2*mu*(1./r_bit-1./(2*abit1)))); %D_v secondo ramo biellittico
D_v = D_v + abs(sqrt(2*mu*(1./rpf-1./(2*af)))-sqrt(2*mu*(1./rpf-1./(2*abit2)))); %D_v forma finale
%% cambio periasse finale (prima del cambio forma poiche e è più bassa)
d_om = om_f-om2+2*pi;
th_peri_1 = d_om/2; th_peri_2 = 2*pi-d_om/2;
D_v = D_v + abs(2*sqrt(mu./pf).*ef*sin(d_om/2)); %D_v cambio periasse
figure()
x = 1:length(D_v);
plot(r_bit,D_v,'LineWidth',2)