% BIELLITTICO
mu = 398600;
stepTh= pi/90;
%% Caratterizzo prima orbita (angoli in radianti)
r = [-7663.5213 -6485.4986 -2201.1930]'; v = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r, v, mu);

%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;
%% Peri-Apo
at = (raf+rpi)/2; et = (raf-rpi)/(raf+rpi);
D_v1 = sqrt(2*mu*(1/rpi-1/(2*at)))-sqrt(2*mu*(1/rpi-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/raf-1/(2*af)))-sqrt(2*mu*(1/raf-1/(2*at)));
D_v = abs(D_v1)+abs(D_v2);
D_t = timeOfFlight(ai,ei,th_i,2*pi,mu)+pi*(sqrt(at^3/mu));

th1 = th_i:stepTh:2*pi; tht = 0:stepTh:pi; 
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

th_man_1 = u_i-om_i;
th_man_2 = th_man_1;
om2 = u_f - th_man_2 + 2*pi;

th2 = pi:stepTh:th_man_1;
%% bitangente
R3 = [cos(OM_i) sin(OM_i) 0; -sin(OM_i) cos(OM_i) 0; 0 0 1];
R2 = [1 0 0; 0 cos(i_i) sin(i_i); 0 -sin(i_i) cos(i_i)];
R1 = [cos(om_i) sin(om_i) 0; -sin(om_i) cos(om_i) 0; 0 0 1];
R = R1*R2*R3;
R = R';
%
p = af*(1-ef^2);
a_bit = 8e4; [r_man,v_man] = kep2car(af,ef,i_i,OM_i,om_i,th_man_1,mu);
v_in = R'*v_man;
gamma = atan2(sqrt(mu/p)*ef*sin(th_man_1),sqrt(mu/p)*(1+ef*cos(th_man_1)));
D_v_bit = sqrt(2*mu*(1/norm(r_man)-1/(2*a_bit)))-sqrt(2*mu*(1/norm(r_man)-1/(2*af)));
v_fin_per = v_in + D_v_bit.*[-sin(th_man_1-gamma) cos(th_man_1-gamma) 0]';

%v_fin_per = [v_fin(1)*cos(th_man_1)+v_fin(2)*cos(-gamma+pi+th_man_1);...
             %v_fin(1)*sin(th_man_1)+v_fin(2)*sin(-gamma+pi+th_man_1); 0];
V_bit_car = R*v_fin_per;
[a_bit,e_bit,i_bit,OM_bit,om_bit] = car2kep(r_man,V_bit_car,mu);
%a_bit = (r_bit+norm(r_man))/2; e_bit = abs(r_bit-norm(r_man))/(r_bit+norm(r_man));
%OM_bit_1 = OM_i; om_bit_1 = u_i; OM_bit_2 = OM_f; om_bit_2 = u_f;

th_plot = 0:0.01:2*pi; th_bit_1 = 0:stepTh:2*pi; th_bit_2 = 0:stepTh:2*pi;
Terra3d; circular_plane(4e4,0);
r1 = kep2car(af,ef,i_i,OM_i,om_i,th_plot,mu);
r2 = kep2car(af,ef,i_f,OM_f,om2,th_plot,mu);
r_bit_1 = kep2car(a_bit,e_bit,i_bit,OM_bit,om_bit,th_bit_1,mu);
r_bit_2 = kep2car(a_bit,e_bit,i_bit+D_i,OM_bit,om_bit,th_bit_2,mu);
plot3(r1(1,:),r1(2,:),r1(3,:),'LineWidth',2)
plot3(r2(1,:),r2(2,:),r2(3,:),'LineWidth',2)
plot3(r_bit_1(1,:),r_bit_1(2,:),r_bit_1(3,:),'LineWidth',2)
plot3(r_bit_2(1,:),r_bit_2(2,:),r_bit_2(3,:),'LineWidth',2)
grid on;
