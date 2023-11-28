%% PLOT ORBIT
% plot_orbit(r,v,col,leg)
% This function uses r and v as structures, the number of fields is the
% number of trajectory (n)
%                               INPUT
%   r: struct that contains the trajectory in cartesian coordinates 
%   v: struct that contains the velocity in cartesian coordinates
%   col: vector of strings that contains the colour for every single
%   trajectory
%   leg: vector of strings that contains the legend for every single
%   trajectory
%
%                               ATTENTION!
% This function needs the vectorial version of "kep2car.m",
% "circular_plane.m", "8k_earth_daymap-2.jpg", "Earth3d". You can download
% them from the terminal by using these lines:
%
% >> cd "path of your folder"\
% >> 
function plot_orbit(r,v,col,leg)
    n = length(fieldnames(r)); r_tot = [];
    if ~isstruct(r)
        error('r_tot is not a struct');
    elseif n~=length(leg)
        error('number of legends is wrong');
    elseif n~=length(col)
        error('number of colors is wrong');
    end
    
    for i = 1:n
        r_tot = [r_tot r.("r"+num2str(i))];
        v.("v"+num2str(i)) = v.("v"+num2str(i));
    end
    hold on;
    grid on;
    vel = quiver3(nan,nan,nan,nan,nan,nan,'Color','red','LineWidth',1.6,'MaxHeadSize',10);
    plot3(r_tot(1,:),r_tot(2,:),r_tot(3,:),'LineWidth',0.1,'LineStyle','--','Color','b')
    Earth3d;
    circular_plane(max(max(abs(r_tot(1:2,:))))*1.5,0);
    legend('','','')
    for j = 1:n
        l = size(r.("r"+num2str(j)),2);
        curve = animatedline('LineWidth',2,'Color',col(j));
        for i = 1:l
            addpoints(curve,r.("r"+num2str(j))(1,i),r.("r"+num2str(j))(2,i),r.("r"+num2str(j))(3,i));
            h = scatter3(r.("r"+num2str(j))(1,i),r.("r"+num2str(j))(2,i),r.("r"+num2str(j))(3,i),'filled','Color','[0.25, 0.25, 0.25]','MarkerFaceColor','[0.25, 0.25, 0.25]');
            drawnow
            delete(h)
            curve.DisplayName = leg(j);
            if i == 1
            legend(curve, leg(j), 'AutoUpdate', 'off', 'Location', [.7 .8 .1 .1], 'FontSize', 10);    
            end
            set(vel,'XData',r.("r"+num2str(j))(1,i),'YData',r.("r"+num2str(j))(2,i),'ZData',r.("r"+num2str(j))(3,i),...
                'UData',v.("v"+num2str(j))(1,i),'VData',v.("v"+num2str(j))(2,i),'WData',v.("v"+num2str(j))(3,i));
            if i == l
                v_0(1) = v.("v"+num2str(j))(1,i); v_0(2) = v.("v"+num2str(j))(2,i); v_0(3) = v.("v"+num2str(j))(3,i);
            elseif i == 1 && j ~= 1
                v_1(1) = v.("v"+num2str(j))(1,i); v_1(2) = v.("v"+num2str(j))(2,i); v_1(3) = v.("v"+num2str(j))(3,i);
                D_v_val = (v_1-v_0);
                if norm(D_v_val) > 4
                   D_v = D_v_val.*0.9;
                elseif norm(D_v_val) < 0.1
                    D_v = D_v_val.*50;
                else
                    D_v = D_v_val.*5;
                end
                D_v = D_v.*0.7e3;
                q = quiver3(r.("r"+num2str(j))(1,i),r.("r"+num2str(j))(2,i),r.("r"+num2str(j))(3,i),...
                D_v(1),D_v(2),D_v(3),'Color',"#7E2F8E",'LineWidth',1.6,'MaxHeadSize',10);
                q.DisplayName = '';
            end
            legend
        end
    end
    leg_2 = ['','','','',leg(1)];
    for i = 2:(n-1)*2
        if mod(i,2)==0
            leg_2 = [leg_2 leg(ceil(i/2)+1)];
        else
            leg_2 = [leg_2 ''];
        end
    end
    legend('off'); legend(leg_2);
    i = 2;
    while i <= 2*n-2
        if mod(i,2) == 0
            leg = [leg(1:i),"",leg(i+1:end)];
            i = i + 1;
        end
        i = i + 1;
    end
end