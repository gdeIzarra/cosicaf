function Er=compute_reduced_Efield(obj,E,mater,density)
%% This function compute a reduced electric field in Td.
% The routine takes the following input parameter:
% ------------------------------------------------
% E       the electric field in (V/m)
% mater   a string containing the material name.
% density the density of the material in (g/cm^3)
% ------------------------------------------------
  Er=[];
  
  mmass=find(strcmp(obj.molar_mass(1,:),mater));
  
  if(isempty(mmass))
  return;
  end
  
  mmass=obj.molar_mass{2,mmass};
  
  N=(density*1e6)/mmass*6.02e23;
  
  
  Er=(E/N)/1.e-21;
  
  
  
end
