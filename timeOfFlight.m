function delta_t = timeOfFlight(a,e,th_i,th_f,mu)
% Initial eccentric anomaly
E_i = 2 * atan(tan(th_i/2) * sqrt((1 - e)/(1 + e)));
if E_i < 0
   E_i = E_i + 2*pi;
end

% Final eccentric anomaly
E_f = 2 * atan(tan(th_f/2) * sqrt((1 - e)/(1 + e)));
if E_f < 0
   E_f = E_f + 2*pi;
end

% Mean anomalies (initial and final)
M_i = E_i - e*sin(E_i);
M_f = E_f - e*sin(E_f);

% Mean angular rate
n = sqrt(mu/a^3);

% M = n*t
delta_t = (M_f - M_i)/n;
    
if delta_t < 0
   T = 2*pi * sqrt(a^3/mu);
   delta_t = delta_t + T;
end
end