function t=compute_hion_traveling_time(obj,medium, mass_vol,particle,beg,fin,approx)
  
  
  
  %Get the mass of the projectile, up to now, it is hard woded
  m=1.66054e-27;
  if(strcmp(particle,'hffU5')==1)
  m=138.5*m;
  elseif(strcmp(particle,'lffU5')==1)
  m=95*m;
  elseif(strcmp(particle,'alpha')==1)
  m=4*m;
  end
  
  t=0;
  dl=(fin-beg)/1000;
  for i=beg:dl:fin-dl
 
  t=t+dl*0.5*(1/sqrt(2*1.6e-13*obj.moderation_law(medium,mass_vol,particle,i,approx)/m)+1/sqrt(2*1.6e-13*obj.moderation_law(medium,mass_vol,particle,i+dl,approx)/m));
  
  end
  
  
end
