function [ret]=generate_charge_track(obj, part_index,approx)
%% Function to generate charged particle along the trajectory 
% of an heavy ion.
% the routine takes as input:
% ----------------------------------------------------
% part_index the index of the heavy ion trajectory
% approx a string which can be 'POLY' or 'POW' depending of the approximation 
%        wanted for moderation laws
%-----------------------------------------------------
%
% The routine find the part of the trajectory were charge generation is interesting
% by seeking the material defined in W data. Then the total trajectory is
% computed and a small length dl is estimated in order to produce around
% obj.charge_nb metacharges (positive and negative). Then, the trajectory is
% traveled with dl steps. The energy loss on this small length is estimated and,
% using the proper W, two meta charges are created.
%
% if the selected trajectory is able to generate charges, the routine return the number
% of meta charges created. Else, an empty vector is returned.
  ret=[];
  buffer=[];
  obj.charges=zeros(obj.charge_nb,5);
  macro_charge_nb=1;
  
  
  travel=0;
  travel_offset=0; 
  E=0;
  E1=0;
  W=0;
  
  particle=obj.particle{1,part_index}; 
  vec=obj.particle{2,part_index};
  vec=vec(1:3);
  
  mat='';
  vol_mass=0;
  
  %Going through the heavy particle trajectory
  % to detect the volume where the material is
  % subject to charge creation -> data in W .
  
  buffer=obj.particle{3,part_index};
  volume=buffer(5:6:end) % selection of volume indexes
  
  j=1;
  selected_vol=[]
  for i=volume
     if(sum(strcmp(obj.geometry{4,i},obj.W(1,:)))>0)
       selected_vol(end+1)=j;      
     end
  j=j+1;
  end
selected_vol
if(isempty(selected_vol))
return; 
end

%volume now contain the index of trajectory parts where charges are produced. 
  
%  charged macro particles will be generated to represent the number of charged 
%generated along a constant distance step.

% First lets compute the distance step with the number of charged macro asked by the user
% and the trajectory where charges are created

total_dist=0;
pos1=[];
pos2=[];

for i=selected_vol
  
  pos1=buffer((i-1)*6+2:(i-1)*6+2+2) % end of trajectory
  
  %beginning of trjectory
  if(i==1)%handling the start of the heavy particle
  pos2=obj.particle{2,part_index};
  pos2=pos2(5:7)';  
  else
  pos2=buffer((i-2)*6+2:(i-2)*6+2+2); % end of trajectory
  end
 
  total_dist=total_dist+norm(pos1-pos2,2);

end  
  
% amount of trajectory to consider between each charge creation.  
  dx=total_dist/obj.charge_nb;
  
  
 %********************************************** 
 %creating charges.
for i=selected_vol
  
  pos1=buffer((i-1)*6+2:(i-1)*6+2+2) % end of trajectory
  mat=obj.geometry{4,volume(i)};%finding the material inside the crossed volume
  vol_mass=obj.geometry{5,volume(i)}; %findin volumic mass of the crossed material
  vol_mass=vol_mass(1);
  %beginning of trjectory
  if(i==1)%handling the start of the heavy particle
  pos2=obj.particle{2,part_index};
  E=pos2(4);
 
  pos2=pos2(5:7)';  
  else
  pos2=buffer((i-2)*6+2:(i-2)*6+2+2); 
  E=buffer((i-2)*6+1);
  end
 i
  Ecorr=obj.elecE_corr(mat,particle,E);
  W=obj.get_W_value(mat)% finding the W related to the material
  total_dist=norm(pos1-pos2)%computing the norm of the current trajectory 
  travel_offset=obj.inverse_moderation_law(mat,vol_mass,particle,E, approx); %distance already taken into account
  travel=0;
  %generating charges along the trajectory
  while(1)
      E
      Ecorr
      E1=obj.moderation_law(mat,vol_mass,particle,travel_offset+travel+dx,approx)
      E1corr=obj.elecE_corr(mat,particle,E1)
     
      charge(macro_charge_nb,1:3)=pos2+(vec.*(travel+dx*0.5))';
      charge(macro_charge_nb,4)=(Ecorr-E1corr)/(W*1e-6);
      charge(macro_charge_nb,5)=+1;
      
      charge(macro_charge_nb+1,1:3)=pos2+(vec.*(travel+dx*0.5))';
      charge(macro_charge_nb+1,4)=charge(macro_charge_nb,4);
      charge(macro_charge_nb+1,5)=-1;
      
      macro_charge_nb=macro_charge_nb+2;
      travel=travel+dx;
      E=E1;
      Ecorr=E1corr;
      if(E<=0)
        break;
      end
      if(travel>=total_dist)
       break;
      end
      
      
  
  end
  
  
end  

obj.charges=charge;  
ret=macro_charge_nb;  
  
end