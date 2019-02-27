function draw_geometry(obj)
  
t = linspace(0,2*pi);
rin = 0;
rout = 0;
center = [0, 0];
xin = rin*cos(t);
xout = rout*cos(t);
yin = rin*sin(t);
yout = rout*sin(t);
z1 = 0;
z2 = 0.24;

%% Plot

hold on
geom_buf=0;
col='g';

for i=size(obj.geometry,2):-1:1
  
geom_buf=obj.geometry{3,i};

rin=geom_buf(1);
rout=geom_buf(2);
center=[ geom_buf(4) geom_buf(5)];
z1=geom_buf(6);
z2=geom_buf(3)+geom_buf(6);
xin = rin*cos(t);
xout = rout*cos(t);
yin = rin*sin(t);
yout = rout*sin(t);

col='g';
if(strcmp(obj.geometry{2,i},'bound'))
col='b';
end
geom_buf=obj.geometry{7,i}
if(geom_buf(1)==1)
col='r';
end



bottom = patch(center(1)+[xout,xin], ...
               center(2)+[yout,yin], ...
               z1*ones(1,2*length(xout)),col);
                set(bottom,'facealpha',0.3)
top = patch(center(1)+[xout,xin], ...
            center(2)+[yout,yin], ...
            z2*ones(1,2*length(xout)),col);
            set(top,'facealpha',0.3)
[X,Y,Z] = cylinder( [1 1],length(xin));

outer = surf(rout*X+center(1), ...
             rout*Y+center(2), ...
             Z*(z2-z1)+z1);
             set(outer,'facealpha',0.3)
             set(outer,'facecolor',col)

inner = surf(rin*X+center(1), ...
             rin*Y+center(2), ...
             Z*(z2-z1)+z1);
          set(inner,'facealpha',0.3)   
         set(inner,'facecolor',col)

  
  
  
end  
  

hold off 
 
end
