function dT = timeOfFlight(a,e,th0,thf,mu)

E0 = 2*atan(sqrt((1-e)/(1+e))*tan(th0/2));
Ef = 2*atan(sqrt((1-e)/(1+e))*tan(thf/2));

dM = (Ef-E0)-e*(sin(Ef)-sin(E0));

n = sqrt(mu/a^3);

if thf>=th0

    dT = dM/(n); %secondi
else
    T = 2*pi*sqrt(a^3/mu);
    dT = dM/(n)+T; %secondi
end

end