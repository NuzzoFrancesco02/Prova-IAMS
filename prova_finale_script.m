% PROVA FINALE
mu = 398600;
%% Caratterizzo prima orbita (angoli in radianti)
ai = 9455; ei = 0.08729; ii = deg2rad(42.423); 
OM_i = deg2rad(26.358); om_i = deg2rad(22.135); th_i = deg2rad(176.37);

%% Caratterizzo seconda orbita (angoli in radianti)
af = 13200; ef = 0.386; i_f = 1.484; OM_f = 2.757; om_f = 0.9111; th_f = 0.2903;

% Economica
% apo-peri
rpi = ai*(1-ei); rai = ai*(1+ei); rpf = af*(1-ef); raf = ai*(1+ef); 
at = (rai+rpf)/2;
D_v1 = sqrt(2*mu*(1/rai-1/(2*at)))-sqrt(2*mu*(1/rai-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/rpf-1/(2*af)))-sqrt(2*mu*(1/rpf-1/(2*at)));
D_v = abs(D_v1)+abs(D_v2)
% peri-apo
at = (raf+rpi)/2;
D_v1 = sqrt(2*mu*(1/rpi-1/(2*at)))-sqrt(2*mu*(1/rpi-1/(2*ai)));
D_v2 = sqrt(2*mu*(1/raf-1/(2*af)))-sqrt(2*mu*(1/raf-1/(2*at)));
D_v = abs(D_v1)+abs(D_v2)
% apo-peri è meno costosa D_v = 0.942 contro D_V = 0.9969: calcolo tempi

