function ret=check_geometry(obj)
%% routine to check geometry.
%
% few things are checked:
% -the existence of unique boundaries.
% -the correctness of each volume type.
% -the correctness of volume material
% -the existence and the correctness of sources
% -the validity of the geometry (no intersection)
%
% The function return 1 if the geometry is correct.
% Else it return 0.
%
% TODO: add a check between inner volumes 12/11/18
ret=0;
buf=[];
vol1=[];
vol2=[];

fprintf('****************************************************\n');
fprintf('***GEOMETRY CHECK\n');
fprintf('****************************************************\n');


if(isempty(obj.geometry))
fprintf('ERROR, no geometry loaded\n');
return
end

if(isempty(obj.moderation_laws))
fprintf('ERROR, no moderation law loaded\n');
return
end


fprintf('\n1) checking presence of boundaries...\n');

for i=1:size(obj.geometry,2)

if(strcmp(obj.geometry{2,i} ,'bound'))
buf(end+1)=i;
end

end

if(isempty(buf)==0)
fprintf('Boundaries found on line %d of geometry\n',buf);
else
fprintf('ERROR Boundaries not found\n',buf);
return;
end

if(length(buf)~=1)
fprintf('ERROR multiple boundaries found\n');
return
end


fprintf('\n2) checking the type of each volume ...\n');

for i=1:size(obj.geometry,2)
  if(strcmp('bound',obj.geometry{2,i})==0 && strcmp('regular',obj.geometry{2,i})==0 && strcmp('no_coll',obj.geometry{2,i})==0 && strcmp('stop',obj.geometry{2,i})==0)
  fprintf('ERROR type of volume unknown line %d\n',i);
  return
  end
end

fprintf('all types are ok.\n');


fprintf('\n3) checking the material of each volume ...\n');

for i=1:size(obj.geometry,2)
  
  if(isempty(find(strcmp(obj.moderation_laws(1,:),obj.geometry{4,i})) ))
  fprintf('ERROR type of material unknown line %d\n',i);
  return
  end
end

fprintf('no error found in material definition.\n');


fprintf('\n4) checking the presence of sources ...\n');
buf=0;
for i=1:size(obj.geometry,2)
  
  if(obj.geometry{7,i}(1)==1)
  fprintf('source found line %d\n',i);
  if(isempty(find(strcmp(obj.moderation_laws(2,:),obj.geometry{6,i})) ))
      fprintf('Error, particle %s unknown\n',obj.geometry{6,i});
    return   
  end
  
  buf=buf+obj.geometry{7,i}(3);
  
  end
end

if(buf==1)
  fprintf('Sum of source contribution %d, ok.\n',buf);
else
   fprintf('Warning sum of source contribution equal %d\n',buf);
end


fprintf('\n5) checking validity of geometry\n');

D=0;

 IDgeom=cell2mat(obj.geometry(1,:));
    
    [sortIDgeom,sortind]=sort(IDgeom);
    
    for i=sortind
    
          inner=obj.find_inner_volume(i);

          % Check inner volume relative to outer one
          for j=inner
              vol1=obj.geometry{3,i};
              vol2=obj.geometry{3,j};          
              D=sqrt((vol1(4)-vol2(4))^2+(vol1(5)-vol2(5))^2);
              
              if(vol1(1)+vol2(1)>=D && abs(vol1(1)-vol2(1))<=D)
                fprintf('Error, intersection in geometry between vol l.%d and inner vol.l %d\n',i,j);
                return;
              end
              
              if(vol2(6)<vol1(6) || vol2(6)+vol2(3)>vol1(6)+vol1(3))
              fprintf('Error, bad intersection in geometry between vol l.%d and inner vol.l %d\n',i,j);
                return;
              end
          end
      
        % Check inner volume collision relative to inner volume.
        for j=1:length(inner)
            vol1=obj.geometry{3,inner(j)};
            if(strcmp(obj.geometry{2,inner(j)},'no_coll')==0)
            
                for k=j+1:length(inner)
                  vol2=obj.geometry{3,inner(k)};
                    if(strcmp(obj.geometry{2,inner(k)},'no_coll')==0)
                    
                          D=sqrt((vol1(4)-vol2(4))^2+(vol1(5)-vol2(5))^2);
                          
                          
                           if((vol1(1)+vol2(1)>=D && abs(vol1(1)-vol2(1))<=D) || (vol2(6)<vol1(6) || vol2(6)+vol2(3)>vol1(6)+vol1(3)))
                          
                             % 'Bad inclusion'
                              %inner(j)
                              %inner(k)
                              if((vol1(6)+vol1(3)>=vol2(6)+vol2(3) && vol1(6)<=vol2(6)) || (vol2(6)+vol2(3)>=vol1(6)+vol1(3) && vol2(6)<=vol1(6)))
                               fprintf('Error, two volume with the same inclusion index are colliding vol l.%d and vol.l %d\n',inner(j),inner(k));
                               return;
                              end
                              
                              if((vol1(6)<vol2(6) && vol2(6)<vol1(6)+vol1(3)) || (vol1(6)<vol2(6)+vol2(3) && vol2(6)+vol2(3)<vol1(6)+vol1(3)))
                               fprintf('Error, two volume with the same inclusion index are colliding vol l.%d and vol.l %d\n',inner(j),inner(k));
                               return;
                              end
                              
                          
                          end
                  
                    end            
            
                end
         
            end
        
        
        
        end
    
    


  end

fprintf('geometry is valid.\n');    
    
    ret=1
    
 end