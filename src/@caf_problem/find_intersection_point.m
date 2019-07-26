function vec=find_intersection_point(obj,volume_ind,direction,pos)
%% This routine find the intersection point between a line and 
% a cylindrical volume. 
%
% The function take as parameter:
%-------------------------------
% volume_ind  the index of the volume where the source is
% direction   a 3 element vector containing the propagation direction of the particle
% pos         a 3 element vetor containing the initial position of the particle
%-------------------------------
% the function return the location of the intersection if sucessful.
% else, it return an empty vector.


vec=[];

if(isempty(obj.geometry))
return
end


buffer=obj.geometry{3,volume_ind} ;% we retrieve the data about the volume of interest

if(isempty(buffer))
return
end


intersec=ones(200,3)*1e6;

if(direction(3)~=0)
  % computing the intersection point in the upper plane
  t=(buffer(6)+buffer(3)-pos(3))/direction(3);
  if(t>0) % if the intersection point is toward the particle direction
  intersec(1,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];
  end
  % computing the intersection point in the lower plane
  t=(buffer(6)-pos(3))/direction(3);
  if(t>0) % if the intersection point is toward the particle direction
  intersec(2,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];
  end
end

% computing the intersection point in the outer cylinder
t=1e6;
A=direction(1)^2+direction(2)^2;
B=2.0*((pos(1)-buffer(4))*direction(1)+(pos(2)-buffer(5))*direction(2));
C=(pos(1)-buffer(4)).^2+(pos(2)-buffer(5)).^2-buffer(1).^2;

delta=B^2-4*A*C;
if(A~=0)
    if(delta==0) %unique solution
      if(-B/(2.0*A)>=0)
        t=-B/(2.0*A);
      end
    else%  2 roots

       if(delta<0)
          t=1e6;
        elseif( (-B-sqrt(delta))/(2*A)>=0)
       t=(-B-sqrt(delta))/(2*A);
      elseif((-B+sqrt(delta))/(2*A)>=0)
       t= (-B+sqrt(delta))/(2*A);
      end

     end
  intersec(3,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];

end

% computing the intersection point in the inner cylinder
if(buffer(2)~=0)

  A=direction(1)^2+direction(2)^2;
  B=2.0*((pos(1)-buffer(4))*direction(1)+(pos(2)-buffer(5))*direction(2));
  C=(pos(1)-buffer(4)).^2+(pos(2)-buffer(5)).^2-buffer(2).^2;

  delta=B^2-4*A*C;
  if(A~=0)
      if(delta==0) %unique solution
        if((-B/(2.0*A))>=0)
          t=-B/(2.0*A);
        end
      else %2 roots

         if(delta<0)
          t=1e6;
        elseif( (-B-sqrt(delta))/(2*A)>=0)
         t=(-B-sqrt(delta))/(2*A);
        elseif((-B+sqrt(delta))/(2*A)>=0)
         t= (-B+sqrt(delta))/(2*A);
        end

      end
      intersec(4,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];
  end

end

%% Taking care of the volume included inside volume_ind.
%
% The computation is a bit different, we cannot handle the problem in tha same
% way as in the current volume since we don t really know if a particle taht cross
% surface will enter the volume
% The strategy is then to compute the collision location and then check if 
% the location is located really at the interface of an inner volume.


ind=obj.find_inner_volume(volume_ind);

j=5;

if(isempty(ind)==0)
  for i=ind
    
    buffer=obj.geometry{3,i} ;% we retrieve the data about the volume of interest
  
    
  if(direction(3)~=0)
    % computing the intersection point in the upper plane
    t=(buffer(6)+buffer(3)-pos(3))/direction(3);
    if(t>0) % if the intersection point is toward the particle direction
    
    intersec(j,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];
    if(i~=obj.find_volume_next_to_intersection(intersec(j,:),direction))
    intersec(j,:)=ones(1,3)*1e6;
    end
    j=j+1;
    end
    % computing the intersection point in the lower plane
    t=(buffer(6)-pos(3))/direction(3);
    if(t>0) % if the intersection point is toward the particle direction
    intersec(j,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];
    if(i~=obj.find_volume_next_to_intersection(intersec(j,:),direction))
    intersec(j,:)=ones(1,3)*1e6;
    end
    j=j+1;
    end
  end
  
  % computing the intersection point in the outer cylinder
  t=1e6;
  A=direction(1)^2+direction(2)^2;
  B=2.0*((pos(1)-buffer(4))*direction(1)+(pos(2)-buffer(5))*direction(2));
  C=(pos(1)-buffer(4)).^2+(pos(2)-buffer(5)).^2-buffer(1).^2;
  
  delta=B^2-4*A*C;
  if(A~=0)
      if(delta==0) %unique solution
        if(-B/(2.0*A)>=0)
          t=-B/(2.0*A);
        end
      else%  2 roots
  
        if(delta<0)
          t=1e6;
        elseif  ( (-B-sqrt(delta))/(2*A)>=0)
         t=(-B-sqrt(delta))/(2*A);
        elseif((-B+sqrt(delta))/(2*A)>=0)
         t= (-B+sqrt(delta))/(2*A);
        end
  
      end
  end
  intersec(j,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];
  if(i~=obj.find_volume_next_to_intersection(intersec(j,:),direction))
    intersec(j,:)=ones(1,3)*1e6;
    end
  j=j+1;
  
  % computing the intersection point in the inner cylinder
  if(buffer(2)~=0)
  
    A=direction(1)^2+direction(2)^2;
    B=2.0*((pos(1)-buffer(4))*direction(1)+(pos(2)-buffer(5))*direction(2));
    C=(pos(1)-buffer(4)).^2+(pos(2)-buffer(5)).^2-buffer(2).^2;
  
    delta=B^2-4*A*C;
    if(A~=0)
        if(delta==0) %unique solution
          if((-B/(2.0*A))>=0)
            t=-B/(2.0*A);
          end
        else %2 roots
          
          if(delta<0)
          t=1e6;
          elseif( (-B-sqrt(delta))/(2*A)>=0)
           t=(-B-sqrt(delta))/(2*A);
          elseif((-B+sqrt(delta))/(2*A)>=0)
           t= (-B+sqrt(delta))/(2*A);
          end
  
       end
      
     end
        intersec(j,:)=[pos(1)+direction(1)*t, pos(2)+direction(2)*t, pos(3)+direction(3)*t ];
        if(i~=obj.find_volume_next_to_intersection(intersec(j,:),direction))
         intersec(j,:)=ones(1,3)*1e6;
        end
        j=j+1;
   
  
  end
  
  
  end

end
%%
%pos
%intersec

%selecting the closest intersection point.
[m,ind]=min(sqrt(sum((intersec-pos)'.^2)));
ind
%modification to tackle problem with grazing trajectory 07/19
if(m==0)
intersec(ind,:)=[];
[m,ind]=min(sqrt(sum((intersec-pos)'.^2)));
end

vec=intersec(ind,:);

end
