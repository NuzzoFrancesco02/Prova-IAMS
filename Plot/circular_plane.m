function circular_plane(R,i)
th = 0:0.1:2*pi;
x = R.*cos(th)*cos(i); y = R.*sin(th); z = R.*sin(th)*sin(i);
fill3(x,y,z,'yellow','FaceAlpha',0.15,'EdgeColor','none')
