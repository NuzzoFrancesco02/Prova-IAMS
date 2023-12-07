%% TRasf diretto
mu = 398600;
stepTh= pi/180;
% Caratterizzo prima orbita (angoli in radianti)
r_i = [-7663.5213 -6485.4986 -2201.1930]'; v_i = [3.515 -2.916 -3.814]';
[ai, ei, i_i, OM_i, om_i, th_i] = car2kep(r_i, v_i, mu);

% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;
[r_f,v_f] = kep2car(af,ef,i_f,OM_f,om_f,th_f,mu);
% individuo il piano
n = cross(r_i,r_f)./norm(cross(r_i,r_f));
r1 = norm(r_i); r2 = norm(r_f);
e_t = (r2-r1)/(r2*cos(th_f)-r1);
p_t = r1*(1-e_t); a_t = p_t/(1-e_t^2);
i_t = acos(n(3));
N = cross([0 0 1],n)./norm(cross([0 0 1],n));
OM_t = 2*pi-acos(dot([1 0 0],N));
% Cambio piano
D_i = i_t-i_i; D_OM = OM_t-OM_i; 
alpha_1 = acos(cos(i_i)*cos(i_t)+sin(i_i)*sin(i_t)*cos(D_OM));
% Calcolo u_i
cos_ui = (cos(alpha_1)*cos(i_i)-cos(i_t))/(sin(alpha_1)*sin(i_i));
sin_ui = sin(i_t)*sin(D_OM)/sin(alpha_1);
u_i_1 = atan2(sin_ui,cos_ui);
% Calcolo u_f
cos_uf = (cos(i_i)-cos(alpha_1)*cos(i_t))/(sin(alpha_1)*sin(i_t));
sin_uf = sin(i_i)*sin(D_OM)/sin(alpha_1);
u_f_1 = atan2(sin_uf,cos_uf);
% Calcolo parametri orbite
th_man_1_1 = u_i_1-om_i+2*pi;
th_man_2_1 = th_man_1_1;
om2_1 = u_f_1 - th_man_2_1 + 2*pi;
D_v = abs(2*sqrt(mu/(ai*(1-ei^2))).*(1+ei.*cos(th_man_1_1)).*sin(alpha_1/2));


%%
th_t_fin = acos(dot(r_f,r_i)/(norm(r_i)*norm(r_f)));
e_t = -(r2-r1)/(r2*cos(th_t_fin+th_man_2_1)-r1*cos(th_man_2_1));
p_t = r1*(1+e_t*cos(th_man_2_1));
a_t = p_t/(1-e_t^2);
rp_t = a_t*(1-e_t);
D_t = timeOfFlight(a_t,e_t,th_man_2_1,th_man_2_1+th_t_fin,mu);
[~,v_cf_i] = kep2car(ai,ei,i_t,OM_t,om2_1,th_man_2_1,mu);
[~,v_cf_f] = kep2car(a_t,e_t,i_t,OM_t,om2_1,th_man_2_1,mu);
D_v_cf_car = v_cf_f-v_cf_i;
D_v = D_v + norm(D_v_cf_car);

%%

% D_i < 0, D_OM > 0
D_i = i_f-i_t; D_OM = OM_f-OM_t;
alpha_2 = acos(cos(i_t)*cos(i_f)+sin(i_t)*sin(i_f)*cos(D_OM));
cos_ui = (cos(i_f)-cos(alpha_2)*cos(i_t))/(sin(alpha_2)*sin(i_t));
sin_ui = -sin(i_f)*sin(D_OM)/sin(alpha_2);
u_i_2 = atan2(sin_ui,cos_ui);
cos_uf = (cos(alpha_2)*cos(i_f)-cos(i_t))/(sin(alpha_2)*sin(i_f));
sin_uf = -sin(i_t)*sin(D_OM)/sin(alpha_2);
u_f_2 = atan2(sin_uf,cos_uf);
th_man_1_2 = (u_i_2-om2_1)+2*pi;
th_man_2_2 = th_man_1_2;
om2_2 = u_f_2-th_man_2_2+2*pi;
D_v = D_v + abs(2*sqrt(mu/(a_t*(1-e_t^2))).*(1+e_t.*cos(th_man_1_2)).*sin(alpha_2/2));
%% cambio forma e periasse
[r_t,v_t] = kep2car(a_t,e_t,i_t,OM_t,om2_2,th_man_2_2,mu);
D_v_car = v_f-v_t;
D_v = D_v + norm(D_v_car);
%%
[r1,v1] = kep2car(ai,ei,i_i,OM_i,om_i,0:stepTh:2*pi,mu);
[rf,vf] = kep2car(af,ef,i_f,OM_f,om_f,0:stepTh:2*pi,mu);
[r,v] = kep2car(a_t,e_t,i_t,OM_t,om2_1,th_man_2_1:stepTh:th_man_1_2,mu);
[r_t2,v_t2] = kep2car(a_t,e_t,i_f,OM_f,om2_2,th_man_2_2,mu);
r_check = kep2car(a_t,e_t,i_f,OM_f,om2_2,0:stepTh:2*pi,mu);
fact = 1e3;
Earth3d;    
set(gcf, 'color', 'white');
circular_plane(1.2e4,0);
d_v = (v_t2-v(:,end)).*fact;
quiver3(r(1,end),r(2,end),r(3,end),d_v(1),d_v(2),d_v(3),'Color','none','LineWidth',1.6,'MaxHeadSize',10);
d_v = (v_f-v_t2).*fact;
quiver3(r(1,end),r(2,end),r(3,end),d_v(1),d_v(2),d_v(3),'Color','none','LineWidth',1.6,'MaxHeadSize',10);

plot3(r1(1,:),r1(2,:),r1(3,:),'LineStyle','--','Color',"#0072BD");
plot3(rf(1,:),rf(2,:),rf(3,:),'lineStyle','--','Color',"#A2142F");
%plot3(r_check(1,:),r_check(2,:),r_check(3,:),'LineStyle','-.')
curve = animatedline('LineWidth',2,'Color',"#EDB120");
view(14.927014304173667,28.197372243332261)

d_v = (v(:,1)-v_i).*fact;
quiver3(r(1,1),r(2,1),r(3,1),d_v(1),d_v(2),d_v(3),'Color',"#7E2F8E",'LineWidth',1.6,'MaxHeadSize',10);
d_v = D_v_cf_car.*fact.*5;
quiver3(r(1,1),r(2,1),r(3,1),d_v(1),d_v(2),d_v(3),'Color',"#7E2F8E",'LineWidth',1.6,'MaxHeadSize',10);
legend('','Initial orbit')
%legend(curve, 'Direct transfer', 'AutoUpdate', 'off', 'Location', 'northeast', 'FontSize', 20);
F = [];
rf = kep2car(af,ef,i_f,OM_f,om_f,th_f,mu);
plot3(rf(1,:),rf(2,:),rf(3,:),'o');
for i = 1 : length(r)
    addpoints(curve,r(1,i),r(2,i),r(3,i));
    h = scatter3(r(1,i),r(2,i),r(3,i),150,'filled','Color','[0.25, 0.25, 0.25]','MarkerFaceColor','[0.25, 0.25, 0.25]',...
                'LineWidth',2);
    drawnow
    if i == 1
        legend(curve, 'Direct transfer', 'AutoUpdate', 'off', 'Location', 'northeast', 'FontSize', 20);   
        legend Box off
    end
    F = [F getframe(gcf)];
    pause(0.01)
    delete(h)
end
h = scatter3(r(1,end),r(2,end),r(3,end),150,'filled','Color','[0.25, 0.25, 0.25]','MarkerFaceColor','[0.25, 0.25, 0.25]',...
                'LineWidth',2);
d_v = (v_t2-v(:,end)).*fact;
quiver3(r(1,end),r(2,end),r(3,end),d_v(1),d_v(2),d_v(3),'Color',"#7E2F8E",'LineWidth',1.6,'MaxHeadSize',10);
d_v = (v_f-v_t2).*fact;
quiver3(r(1,end),r(2,end),r(3,end),d_v(1),d_v(2),d_v(3),'Color',"#7E2F8E",'LineWidth',1.6,'MaxHeadSize',10);

F = [F getframe(gcf)];
%{
video = VideoWriter('prova','MPEG-4');
video.Quality = 100;
video.FrameRate = 20;
open(video);
writeVideo(video,F);
close(video);
%}




