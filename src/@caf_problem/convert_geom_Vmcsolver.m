function [condlim,permit,pos_voxel,pos_geom]=convert_geom_Vmcsolver(obj,dl)
%% Routine to convert a cgs geometry to a discrete one needed to solve
% the Poisson equation. 

% The routine takes as input:
%-------------------------------
% dl the distance between the discrete point of the geometry
%-----------------------------
%  Outside of the geometry, the voltage is set to 0 for tossing away
%  stating point of the random walk outside of the geometry.
%  A non existing potential boundary is represented by the value 1e9 V.
%
% The function return:
% condlim   a 3d matrix containing the potential boundary position.
% permit    a 3d matric containing the permittivity
% pos_Voxel the origin of the geometry in number of dl step.
% pos_geom   the position of the geometry origin en meter. 
  
  %initialisation of arrays needed for mc carlo computation
  % of potential
  condlim=[];
  permit=[];
  pos_voxel=[];
  pos_geom=[];
  buff=[];
  
  stack=zeros(2,1000);
  stack_pos=1;
  span_abo=0;
  span_bel=0;
  
  V=0;
  e=0;
  
  %%find the geometry boundaries
  for i=1:size(obj.geometry,2)

    if(strcmp(obj.geometry{2,i} ,'bound'))
    bindex=i;
    buff=obj.geometry{3,i};
    break
    end

  end
  
  %computation of the dimension of discrete geometry
  dim_l=ceil(buff(1)*2/dl)+1;
  dim_h=ceil(buff(3)/dl)+1;
  
  
  pos_voxel=[round(buff(1)/dl)+1 round(buff(1)/dl)+1 1];
  pos_geom=buff(4:6);
  
  
  condlim=ones(dim_l,dim_l,dim_h).*1e9;
  permit=ones(dim_l,dim_l,dim_h);
  % pour la conversion si l'épaisseur d'un objet est inférieur a dl, on positionne
  %uniquement son centre
  
  
  %% GENERATION OF THE DISCRETE GEOMETRY,
  
  %1) Check if the geometry boundaries have electrostatic boundaries
  if(isempty(find(strcmp( obj.geometry_electrostat{bindex},'no')))~=1)
    
    if(strcmp(obj.geometry_electrostat{bindex}{2},'no')==0 && buff(2)==0)
    
    else
    fprintf('Error, no potential defined for geometry boundary');
    return
    end
  
  end
  
  
  %sort geometry by identifier
  
     IDgeom=cell2mat(obj.geometry(1,:));
    
    [sortIDgeom,sortind]=sort(IDgeom);
    
 
  % go accross the geometry to set the voltage boundaries and the permittivity
  for i=sortind
      
      buff=obj.geometry{3,i};
      
      x0=round((buff(4)-pos_geom(1))/dl)+ pos_voxel(1)
      y0=round((buff(5)-pos_geom(2))/dl)+pos_voxel(2)
      z0=round((buff(6)-pos_geom(3))/dl)+pos_voxel(3)
    %---------------- COMPUTATION OF EXTERNAL BOUNDARY AND LIMIT OF PERMITIVITY
    
     
         radius=round(buff(1)/dl)
          h=round(buff(3)/dl)
          
          x = radius-1;
          y = 0;
          dx = 1;
          dy = 1;
          err = dx - (radius *2);
              
            if(strcmp(obj.geometry_electrostat{i}{1},'no')==0)
            V=str2double(obj.geometry_electrostat{i}{1});
            end
            e=str2double(obj.geometry_electrostat{i}{5});
            
          while (x >= y)
            %Voltage boundary def
              if(strcmp(obj.geometry_electrostat{i}{1},'no')==0)
                condlim(x0 + x, y0 + y,z0:z0+h)=V;
                condlim(x0 + y, y0 + x,z0:z0+h)=V;
                condlim(x0 - y, y0 + x,z0:z0+h)=V;
                condlim(x0 - x, y0 + y,z0:z0+h)=V;
                condlim(x0 - x, y0 - y,z0:z0+h)=V;
                condlim(x0 - y, y0 - x,z0:z0+h)=V;
                condlim(x0 + y, y0 - x,z0:z0+h)=V;
                condlim(x0 + x, y0 - y,z0:z0+h)=V;
              end
                permit(x0 + x, y0 + y,z0:z0+h)=e;
                permit(x0 + y, y0 + x,z0:z0+h)=e;
                permit(x0 - y, y0 + x,z0:z0+h)=e;
                permit(x0 - x, y0 + y,z0:z0+h)=e;
                permit(x0 - x, y0 - y,z0:z0+h)=e;
                permit(x0 - y, y0 - x,z0:z0+h)=e;
                permit(x0 + y, y0 - x,z0:z0+h)=e;
                permit(x0 + x, y0 - y,z0:z0+h)=e;
              if(err <= 0)
                    y=y+1;
                      err=err+ dy;
                      dy = dy+2;
              end
              
              if (err > 0)
                 x=x-1;
                 dx = dx+2;
                 err = err+dx - (radius *2);
              end
          end   
     
     %---------------
     if( buff(2)~=0) % TO CHECK
       
     
         radius=round(buff(2)/dl)
          h=round(buff(3)/dl)
          
          x = radius-1;
          y = 0;
          dx = 1;
          dy = 1;
          err = dx - (radius *2);
          if(strcmp(obj.geometry_electrostat{i}{2},'no')==0)
            V=str2double(obj.geometry_electrostat{i}{2})
          end

          while (x >= y)
              if(strcmp(obj.geometry_electrostat{i}{2},'no')==0 && (buff(1)-buff(2))>2*dl)
              condlim(x0 + x, y0 + y,z0:z0+h)=V;
              condlim(x0 + y, y0 + x,z0:z0+h)=V;
              condlim(x0 - y, y0 + x,z0:z0+h)=V;
              condlim(x0 - x, y0 + y,z0:z0+h)=V;
              condlim(x0 - x, y0 - y,z0:z0+h)=V;
              condlim(x0 - y, y0 - x,z0:z0+h)=V;
              condlim(x0 + y, y0 - x,z0:z0+h)=V;
              condlim(x0 + x, y0 - y,z0:z0+h)=V;
              end
            
              permit(x0 + x, y0 + y,z0:z0+h)=e;
              permit(x0 + y, y0 + x,z0:z0+h)=e;
              permit(x0 - y, y0 + x,z0:z0+h)=e;
              permit(x0 - x, y0 + y,z0:z0+h)=e;
              permit(x0 - x, y0 - y,z0:z0+h)=e;
              permit(x0 - y, y0 - x,z0:z0+h)=e;
              permit(x0 + y, y0 - x,z0:z0+h)=e;
              permit(x0 + x, y0 - y,z0:z0+h)=e;
              
              if(err <= 0)
                    y=y+1;
                      err=err+ dy;
                      dy = dy+2;
              end
              
              if (err > 0)
                 x=x-1;
                 dx = dx+2;
                 err = err+dx - (radius *2);
              end
          end   
     end
     
     %FILL THE UPPER AND THE LOWER BOUNDARY CONDITIONS
     if(strcmp(obj.geometry_electrostat{i}{3},'no')==0)% upper
          V=str2double(obj.geometry_electrostat{i}{3})
           x=x0;
           y=round(buff(1)/dl)-2+y0;
      
           stack_pos=1;
           stack(:,stack_pos)=[x;y];
           stack_pos=2;
           
           while(stack_pos!=1)
             % get data from the pile
             stack_pos=stack_pos-1
             x=stack(1,stack_pos);
             y=stack(2,stack_pos);
             
                   
             x1=x;
             condlim(x1,y,z0+h)
             
             while(x1>1 && condlim(x1,y,z0+h)==1e9)
              x1=x1-1;
             end
              x1=x1+1;
              span_abo=0;
              span_bel=0;
              x1
              y
              z0
              size(condlim,1)
              condlim(x1,y,z0+h)~=1e9
              e
              while(x1<=size(condlim,1) && condlim(x1,y,z0+h)==1e9)
              
                condlim(x1,y,z0+h)=V;
                  if(span_abo==0 && y>1 && condlim(x1,y-1,z0+h)==1e9) 
                     stack(:,stack_pos)=[x1;y-1];
                     stack_pos=stack_pos+1;
                     span_abo=1;
                     span_abo
                  elseif(span_abo==1 && y>1 && condlim(x1,y-1,z0+h)~=1e9)
                     span_abo=0
                     
                  end
                  
                  if(span_bel==0 && y<size(condlim,2) && condlim(x1,y+1,z0+h)==1e9) 
                     stack(:,stack_pos)=[x1;y+1];
                     stack_pos=stack_pos+1;
                     span_bel=1
                  elseif(span_bel==1 && y<size(condlim,2) && condlim(x1,y+1,z0+h)~=1e9)
                     span_bel=0
                     
                  end
                 x1=x1+1;
              
              end
            
            end
   
     end 
     if(strcmp(obj.geometry_electrostat{i}{4},'no')==0)% lower
         V=str2double(obj.geometry_electrostat{i}{4})
           x=x0;
           y=round(buff(1)/dl)-2+y0;
      
           stack_pos=1;
           stack(:,stack_pos)=[x;y];
           stack_pos=2;
           
           while(stack_pos!=1)
             % get data from the pile
             stack_pos=stack_pos-1
             x=stack(1,stack_pos);
             y=stack(2,stack_pos);
             
                   
             x1=x;
             condlim(x1,y,z0)
             
             while(x1>1 && condlim(x1,y,z0)==1e9)
              x1=x1-1;
             end
              x1=x1+1;
              span_abo=0;
              span_bel=0;
              x1
              y
              z0
              size(condlim,1)
              condlim(x1,y,z0)~=1e9
              e
              while(x1<=size(condlim,1) && condlim(x1,y,z0)==1e9)
              
                condlim(x1,y,z0)=V;
                  if(span_abo==0 && y>1 && condlim(x1,y-1,z0)==1e9) 
                     stack(:,stack_pos)=[x1;y-1];
                     stack_pos=stack_pos+1;
                     span_abo=1;
                     span_abo
                  elseif(span_abo==1 && y>1 && condlim(x1,y-1,z0)~=1e9)
                     span_abo=0
                     
                  end
                  
                  if(span_bel==0 && y<size(condlim,2) && condlim(x1,y+1,z0)==1e9) 
                     stack(:,stack_pos)=[x1;y+1];
                     stack_pos=stack_pos+1;
                     span_bel=1
                  elseif(span_bel==1 && y<size(condlim,2) && condlim(x1,y+1,z0)~=1e9)
                     span_bel=0
                     
                  end
                 x1=x1+1;
              
              end
            
            end
   
     end 
     
     %---------------
     
     %% FILL THE SHAPE WITH PROPER PERMITIVITY
     
     if((i==1 || str2double(obj.geometry_electrostat{i}{2})~=e) && (buff(1)-buff(2))>2*dl)
           x=x0;
           y=round(buff(1)/dl)-2+y0;
           
           stack_pos=1;
           stack(:,stack_pos)=[x;y];
           stack_pos=2;
           
           while(stack_pos!=1)
             % get data from the pile
             stack_pos=stack_pos-1
             x=stack(1,stack_pos);
             y=stack(2,stack_pos);
             
                   
             x1=x;
             permit(x1,y,z0)
             while(x1>1 && permit(x1,y,z0+round(h/2))~=e) %while(x1>1 && permit(x1,y,z0)~=e) modif greg OK 19 12 18
              x1=x1-1;
             end
               x1=x1+1;
              span_abo=0;
              span_bel=0;
              x1
              y
              z0
              size(permit,1)
              permit(x1,y,z0)~=e
              e
              while(x1<=size(permit,1) && permit(x1,y,z0+round(h/2))~=e)
              
                permit(x1,y,z0:z0+h)=e;
                  if(span_abo==0 && y>1 && permit(x1,y-1,z0)~=e) 
                     stack(:,stack_pos)=[x1;y-1];
                     stack_pos=stack_pos+1;
                     span_abo=1;
                     span_abo
                  elseif(span_abo==1 && y>1 && permit(x1,y-1,z0)==e)
                     span_abo=0
                     
                  end
                  
                  if(span_bel==0 && y<size(permit,2) && permit(x1,y+1,z0)~=e) 
                     stack(:,stack_pos)=[x1;y+1];
                     stack_pos=stack_pos+1;
                     span_bel=1
                  elseif(span_bel==1 && y<size(permit,2) && permit(x1,y+1,z0)==e)
                     span_bel=0
                     
                  end
                 x1=x1+1;
              
              end
            
            end
      end% if(i==1 || str2double(obj.geometry_electrostat{i}{2})~=e)
  
  
  end

  
  %% FILL THE POINT SURROUNDING THE GEOMETRY WITH CONSTANT VOLTAGE TO MAKE THE
  % RESOLUTION POSSIBLE
       
       corner=[2,2,size(condlim,1),2,2,size(condlim,2),size(condlim,1),size(condlim,2)];
       for i=1:4;
       
           x=corner((i-1)*2+1);
           y=corner((i-1)*2+2);
           z0=round(size(condlim,3)/2);
           
           stack_pos=1;
           stack(:,stack_pos)=[x;y];
           stack_pos=2;
           
           while(stack_pos!=1)
             % get data from the pile
             stack_pos=stack_pos-1
             x=stack(1,stack_pos);
             y=stack(2,stack_pos);
             
                   
             x1=x;
             condlim(x1,y,z0)
             
             while(x1>=1 && condlim(x1,y,z0)==1e9)
              x1=x1-1;
             end
             x1=x1+1;
              span_abo=0;
              span_bel=0;
              while(x1<=size(condlim,1) && condlim(x1,y,z0)==1e9)
              
                condlim(x1,y,2:size(condlim,3)-1)=0;
                  if(span_abo==0 && y>1 && condlim(x1,y-1,z0)==1e9) 
                     stack(:,stack_pos)=[x1;y-1];
                     stack_pos=stack_pos+1;
                     span_abo=1
                    
                  elseif(span_abo==1 && y>1 && condlim(x1,y-1,z0)~=1e9)
                     span_abo=0
                     
                  end
                  
                  if(span_bel==0 && y<size(condlim,2) && condlim(x1,y+1,z0)==1e9) 
                     stack(:,stack_pos)=[x1;y+1];
                     stack_pos=stack_pos+1;
                     span_bel=1
                  elseif(span_bel==1 && y<size(condlim,2) && condlim(x1,y+1,z0)~=1e9)
                     span_bel=0
                     
                  end
                 x1=x1+1;
              
              end
            
            end
      end
      
      %% CHECK FOR THE UPPER AND LOWER SIDE ---HACK
      
      corner=[2,2,1 ,2,2,size(condlim,3), size(condlim,1),2,1, size(condlim,1),2,size(condlim,3) ,2,size(condlim,2),1 ,2,size(condlim,2),size(condlim,3) ,size(condlim,1),size(condlim,2),1 ,size(condlim,1),size(condlim,2),size(condlim,3)];
      
      
       for i=1:8;
       
           x=corner((i-1)*3+1);
           y=corner((i-1)*3+2);
           z0=corner((i-1)*3+3);
           
           stack_pos=1;
           stack(:,stack_pos)=[x;y];
           stack_pos=2;
           
           while(stack_pos!=1)
             % get data from the pile
             stack_pos=stack_pos-1
             x=stack(1,stack_pos);
             y=stack(2,stack_pos);
             
                   
             x1=x;
             condlim(x1,y,z0)
             
             while(x1>=1 && condlim(x1,y,z0)==1e9)
              x1=x1-1;
             end
             x1=x1+1;
              span_abo=0;
              span_bel=0;
              while(x1<=size(condlim,1) && condlim(x1,y,z0)==1e9)
              
                condlim(x1,y,z0)=0;
                  if(span_abo==0 && y>1 && condlim(x1,y-1,z0)==1e9) 
                     stack(:,stack_pos)=[x1;y-1];
                     stack_pos=stack_pos+1;
                     span_abo=1
                    
                  elseif(span_abo==1 && y>1 && condlim(x1,y-1,z0)~=1e9)
                     span_abo=0
                     
                  end
                  
                  if(span_bel==0 && y<size(condlim,2) && condlim(x1,y+1,z0)==1e9) 
                     stack(:,stack_pos)=[x1;y+1];
                     stack_pos=stack_pos+1;
                     span_bel=1
                  elseif(span_bel==1 && y<size(condlim,2) && condlim(x1,y+1,z0)~=1e9)
                     span_bel=0
                     
                  end
                 x1=x1+1;
              
              end
            
            end
      end
end
