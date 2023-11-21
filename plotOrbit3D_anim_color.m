function [X_vett,Y_vett,Z_vett] = plotOrbit3D_anim_color(kepEl,deltaTh,stepTh, LineStyle, manov_Name)

% plotOrbit.m Plot the arc length deltaTh of the orbit described by kepEl
%
% PROTOTYPE:
% plotOrbit kepEl , mu, deltaTh , stepTh
%
% DESCRIPTION:
%  Plot the arc length of the orbit described by a set of orbital elements for a specific arc length
%
% INPUT:
%   kepEl     [6x1]       orbital elements               [km,rad]
%   deltaTh   [1x1]       arc length                     [rad]
%   stepTh    [1x1]       arc length step                [rad]
%   LineStyle [1x1]       Define case to apply for plot  [-]
%
% OUTPUT:
%   X         [nx1]       X position                    [km]
%   Y         [nx1]       Y position                    [km]
%   Z         [nx1]       Z position                    [km]   

% arc length
if deltaTh <0
   deltaTh = deltaTh + 2*pi;
end
th_f= kepEl(6,1) + deltaTh;

% position vectors defining
X_vett=[];
Y_vett=[];
Z_vett=[];

for i=0:stepTh:deltaTh
	[r_vett_ECI,v_vett_ECI] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),kepEl(6,1)+i);
	X_vett = [X_vett;r_vett_ECI(1,1)];
	Y_vett = [Y_vett;r_vett_ECI(2,1)];
	Z_vett = [Z_vett;r_vett_ECI(3,1)];
end
        
% plot globe
%Terra_3D no more called inside the function because dont'allow to do
%multiple obital plots on same figure

set(gcf,'color','w'); % background color (the integrated command line in Terra_3D don't work well on old versions of matlab)

% the use of switch allow to plot orbits just as reference and without
% velocity vector plotting and SAT animation

switch lower(LineStyle)
    case ('dinamico')
 
        % initial orbital velocity plot
        intens= norm(v_vett_ECI)*50; %100 is used as factor to make the velocity vector visible on plot
        [r_vett_ECI,v_vett_ECI] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),kepEl(6,1));
        quiver3(X_vett(1,1), Y_vett(1,1), Z_vett(1,1),...
                v_vett_ECI(1,1), v_vett_ECI(2,1), v_vett_ECI(3,1),...
                intens, '-r', 'LineWidth',2,'MaxHeadSize', 4);
    
    %orbit plot
    step_animation= 20;
    h = plot3( nan, nan, nan, 'or' );
    ombra=plot3( X_vett, Y_vett, Z_vett, '--k','LineWidth',0.25);
    ombra.Color(4) = 0.25;
    colore= rand(1,3); % select random RGB color
    
      % legend
      manovPoint = plot3( X_vett(1), Y_vett(1), Z_vett(1), 'color', colore, 'LineWidth',1.5);
      name=[]; name= manov_Name;
      legend(manovPoint, name, 'AutoUpdate', 'off', 'Location', [.7 .8 .1 .1], 'FontSize', 10);    
    
    for i=1:step_animation:length(X_vett)
        plot3( X_vett(1:i), Y_vett(1:i), Z_vett(1:i), 'color', colore,'LineWidth',1.5 );
        set(h, 'XData', X_vett(i), 'YData', Y_vett(i), 'ZData', Z_vett(i) );
        drawnow
    end
    
        % final orbital velocity plot
        [r_vett_ECI,v_vett_ECI] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),kepEl(6,1)+deltaTh);
        quiver3(X_vett(end,1), Y_vett(end,1), Z_vett(end,1),...
                            v_vett_ECI(1,1), v_vett_ECI(2,1), v_vett_ECI(3,1),...
                            intens, '-b', 'LineWidth',2,'MaxHeadSize', 4);
            
    case('ombra') %plot light grey color dashed orbit
    ombra = plot3( X_vett, Y_vett, Z_vett, '--k','LineWidth',1.5);
    ombra.Color(4) = 0.25;
    
    % plot semiMajor axis
    [r_a,~] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),0);
    [r_p,~] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),pi);
    semiMajor = plot3([r_p(1),r_a(1)],[r_p(2),r_a(2)],[r_p(3),r_a(3)],'-.b','LineWidth',1);
    semiMajor.Color(4) = 0.25;
    

    case('no_anim')
        % initial orbital velocity plot
        [r_vett_ECI,v_vett_ECI] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),kepEl(6,1));
        intens= norm(v_vett_ECI)*100; %100 is used as factor to make the velocity vector visible on plot
        quiver3(X_vett(1,1), Y_vett(1,1), Z_vett(1,1),...
                v_vett_ECI(1,1), v_vett_ECI(2,1), v_vett_ECI(3,1),...
                intens, '-r', 'LineWidth',2,'MaxHeadSize', 7);   
    
    % plot semiMajor axis
    [r_a,~] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),0);
    [r_p,~] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),pi);
    semiMajor = plot3([r_p(1),r_a(1)],[r_p(2),r_a(2)],[r_p(3),r_a(3)],'-.b','LineWidth',1);
    semiMajor.Color(4) = 0.25;        
            
    %orbit plot                  
    manovPoint = plot3( X_vett, Y_vett, Z_vett, 'color', rand(1,3),'LineWidth',1.5);
    name=[]; name= manov_Name;
    legend(manovPoint, name, 'AutoUpdate', 'off', 'Location', [.7 .8 .1 .1], 'FontSize', 10);    
    
        % final orbital velocity plot
        intens= norm(v_vett_ECI)*100;
        [r_vett_ECI,v_vett_ECI] = Kep2Car(kepEl(1,1),kepEl(2,1),kepEl(3,1),kepEl(4,1),kepEl(5,1),kepEl(6,1)+deltaTh);
        quiver3(X_vett(end,1), Y_vett(end,1), Z_vett(end,1),...
                            v_vett_ECI(1,1), v_vett_ECI(2,1), v_vett_ECI(3,1),...
                            intens, '-b', 'LineWidth',2,'MaxHeadSize', 7);    
                        
end        
        
        
        
end