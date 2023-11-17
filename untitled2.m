ai = 4e4; ei = 0.5; i_i = 0; OM_i = 0; om_i = 0; th_tot = 0:0.001:2*pi;
af = 8e4; ef = 0.8; i_f = 0; OM_f = 0; om_f = pi/2; mu = 398600;
r1 = kep2car(ai,ei,i_i,OM_i,om_i,th_tot,mu);
r2 = kep2car(af,ef,i_f,OM_f,om_f,th_tot,mu);
p_i = ai*(1-ei^2); p_f = af*(1-ef^2);
d_om = om_f-om_i;
fun= @(th) p_i*(1+ef*cos(th-d_om))-p_f*(1+ei*cos(th));
th_man = fsolve(fun,0);
plot3(r1(1,:),r1(2,:),r1(3,:)); hold on; grid on;
Terra3d; 
plot3(r2(1,:),r2(2,:),r2(3,:));
% r2 = kep2car(ai,ei,i_i,OM_i,om_i,th_man,mu);
% plot3(r2(1,:),r2(2,:),r2(3,:),'o');
r2 = kep2car(af,ef,i_f,OM_f,om_f,th_man-d_om,mu);
plot3(r2(1,:),r2(2,:),r2(3,:),'o');