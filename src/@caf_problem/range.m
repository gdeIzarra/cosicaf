function R=range(obj,medium,mass_vol,particle)
%% Function to compute the range for different media 
% and different projectiles.
% The routine takes as input:
%-------------------------------
% medium a string containing the name of the medium
% mas_vol the volumic mass of the medium in (g/cm³)
% particle a string containing the name of the projectile 
%-----------------------------
% The function return the range (m) if everything 
% is ok. In case of error, it return an empty array.  
  

  R=[];

selected_data=find(strcmp(obj.moderation_laws(2,:),particle)& strcmp(obj.moderation_laws(1,:),medium));  
 
if(isempty(selected_data))
  return;
end 

  R=moderation_laws{3,selected_data}(2)/(mass_vol*1000)*1e-2;
  
  
end
  