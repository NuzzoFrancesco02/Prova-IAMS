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
p = ai*(1-ei^2);
D_v = abs(2*sqrt(mu/p)*(1+ei*cos(th_man_1))*sin(alpha/2));
th1 = th_i:stepTh:th_man_1;
D_t =  timeOfFlight(ai,ei,th_i,th_man_1,mu);
%% Cambio secante
p_i = ai*(1-ei^2); p_f = af*(1-ef^2); d_om = om_f-om2;
fun = @(th) p_i*(1+ef*cos(th-d_om))-p_f*(1+ei*cos(th));
th_1 = fsolve(fun, 0); th_2 = th_1-d_om;
v_r1 = sqrt(mu/p_i)*ei*sin(th_1); v_th1 = sqrt(mu/p_i)*(1+ei*cos(th_1));
v_r2 = sqrt(mu/p_f)*ef*sin(th_2); v_th2 = sqrt(mu/p_f)*(1+ef*cos(th_2));
D_v_r = v_r2-v_r1; D_v_th = v_th2-v_th1;
D_v = sqrt(D_v_r^2+D_v_th^2) + D_v
th2 = th_man_2:stepTh:th_1+2*pi;
D_t = D_t + timeOfFlight(ai,ei,th_man_2,th_1,mu);
th3 = th_2:stepTh:th_f+2*pi;
D_t = D_t + timeOfFlight(af,ef,th_2,th_f,mu)


%% PLOT transf veloce
[r1,v1] = kep2car(ai,ei,i_i,OM_i,om_i,th1,mu);
[r2,v2] = kep2car(ai,ei,i_f,OM_f,om2,th2,mu);
[r3,v3] = kep2car(af,ef,i_f,OM_f,om_f,th3,mu);

r_tot = struct('r1',r1,'r2',r2,'r3',r3);
v_tot = struct('v1',v1,'v2',v2,'v3',v3);
col = ["#0072BD","#77AC30","#D95319"];
leg = ["Waiting change of plane","Waiting secant maneuver","Approach final point"];
view_vec = [280,-5];
plot_orbit(r_tot,v_tot,col,leg,view_vec,'exp');