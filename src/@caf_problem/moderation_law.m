function E=moderation_law(obj,medium,mass_vol,particle,dist,approx)
%% Function to compute the moderation law for different media 
% and different projectiles.
% The routine takes as input:
%-------------------------------
% medium a string containing the name of the medium
% mas_vol the volumic mass of the medium in (g/cm³)
% particle a string containing the name of the projectile 
% dist the distance traveled by the projectile in (m)
% approx a string containing 'POW' for power low or 'POLY' for polynomial
%        approximation of the moderation law
%-----------------------------
% The function return the energy (MeV) if everything 
% is ok. In case of error, it return an empty array.  
  
E=[];

selected_data=find(strcmp(obj.moderation_laws(2,:),particle)& strcmp(obj.moderation_laws(1,:),medium));  
 
if(isempty(selected_data))
  return;
end 
 
 %convert the distance in mg/cm²
 l=mass_vol*1e3*dist*1e2
 data=obj.moderation_laws{3,selected_data};  
  if(strcmp(approx,'POW'))
      if(l/data(2)>1)
        E=-1000;
        return
      end
     E=data(1)*(1-l/data(2)).^data(3)
  elseif(strcmp(approx,'POLY'))
    if(l/data(2)>1)
        E=-1000;
        return
      end
    l=l/data(2);
    E=data(1)*(data(4)*(1-l)+data(5)*(1-l)^2.0+data(6)*(1-l)^3.0+data(7)*(1-l)^4+data(8)*(1-l)^5);
    if(E>data(1))% prevent fit uncertainty to crash the code -> happen for example at dist=0 ->  lffU5 E=100.50003 
    E=data(1);
    end
  end

 end
  