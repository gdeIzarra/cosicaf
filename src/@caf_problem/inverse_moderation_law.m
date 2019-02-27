function l=inverse_moderation_law(obj,medium,mass_vol,particle,E, approx);
%% Function to compute the inverse moderation law for different media 
% and different projectiles. It is useful to estimate the remaining
% trajectory a particle can travel for example after a change of medium.
% The routine takes as input:
%-------------------------------
% medium a string containing the name of the medium
% mas_vol the volumic mass of the medium in (g/cm³)
% particle a string containing the name of the projectile 
% E the energy of the particle in (MeV).
% approx a string containing 'POW' for power low or 'POLY' for polynomial
%        approximation of the moderation law
%-----------------------------
% Depending on the approximation choosed, the inverse law 
% is computed either by inverse function or by dichotomy method.
% The function return the length (m) if everything 
% is ok. In case of error, it return an empty array.  

l=[];

selected_data=find(strcmp(obj.moderation_laws(2,:),particle)& strcmp(obj.moderation_laws(1,:),medium));
 

if(isempty(selected_data))
  return;
end 
 
data=obj.moderation_laws{3,selected_data};
     

 if(strcmp(approx,'POW'))
    l=data(2)*(1-(E/data(1)).^(1/data(3)));
  elseif(strcmp(approx,'POLY'))
    
  %bisection method  
  l1=0;
  l2=data(2);
  ltemp=0; 
     while(1)
      ltemp=l1+(l2-l1)/2;
      if( data(1)*(data(4)*(1-ltemp/data(2))+data(5)*(1-ltemp/data(2)).^2.0+data(6)*(1-ltemp/data(2)).^3.0+data(7)*(1-ltemp/data(2)).^4+data(8)*(1-ltemp/data(2)).^5)-E>=0)
        l1=ltemp;
      else
        l2=ltemp;
      end
        
      if(l2-l1<1e-5)
        break;
      end
      
        
      end
       l=l1;
      
   
   
  end
 
%l is in mg/cm^2 -> conversion in m
l=l/(mass_vol*1000)*1e-2;


end
