mu = 398600;
stepTh= pi/90;

r_i = [-7663.5213 -6485.4986 -2201.1930]'; v_i = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r_i, v_i, mu);

af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;
[r_f,v_f] = kep2car(af,ef,i_f,OM_f,om_f,th_f,mu);

n = cross(r_i,r_f)./norm(cross(r_i,r_f));
i_t = acos(n(3));
N = cross([0 0 1],n);
OM_t = 2*pi+acos(dot([1 0 0],N)./n);

D_i = i_t-i_i; D_OM = OM_t-OM_i;

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
om2 = u_f - th_man_2;

r1 = kep2car(ai,ei,i_i,OM_i,om_i,0:stepTh:2*pi,mu);
r2 = kep2car(ai,ei,i_i,OM_i,om_i,th_man_1,mu);
r3 = kep2car(ai,ei,i_t,OM_t,om2,th_man_2,mu);
r4 = kep2car(ai,ei,i_t,OM_t,om2,0:stepTh:2*pi,mu);
Earth3d
plot3(r1(1,:),r1(2,:),r1(3,:));
plot3(r2(1,:),r2(2,:),r2(3,:),'o');
plot3(r3(1,:),r3(2,:),r3(3,:),'o');
plot3(r4(1,:),r4(2,:),r4(3,:));