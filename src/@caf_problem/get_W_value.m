function W=get_W_value(obj,material)
%% Function to get the mean energy
% needed to create an electron ion pair
% in (eV).
%% The routine takes as input:
%-------------------------------
% material a string containing the name of the medium
%-------------------------------
%
% if successful, the routine return W in eV.
% Else, the routine return an empty vector.  
  W=[];
  
  selected_data=find(strcmp(obj.W(1,:),material));
  
  if(isempty(selected_data))
  return;
  end

  W=obj.W{2,selected_data};
  
end
