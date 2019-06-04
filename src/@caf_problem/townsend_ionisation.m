function alpha=townsend_ionisation(obj,medium,E,reducedE)
%% This routine compute the first Townsend ionisation coefficients
% in a specific medium. It uses the data located in obj.townsend_data.
% The function load_townsend_i_coef, must be first called before using 
% the routine
% It takes as input:
%---------------------------------------------------------------
% medium   A string containing the name of the array. 
% E        The electric field in (V/M)
%
%---------------------------------------------------------------
% The routine use fitted parameter to estimate Townsend ionisation 
% in (1/m).  
  
  alpha=0.0
  
  selected_data=find( strcmp(obj.townsend_data(1,:),medium)); 
 
 
 buff=cell2mat(obj.townsend_data(2,selected_data)); 
 
 
 ind=find( buff([1:7:7*length(selected_data)]+2)>=reducedE & buff([1:7:7*length(selected_data)]+1)<reducedE);

 
  if(isempty(ind))
    fprintf('error, no ionisation coefficient for this reduced field\n'); 
    return    
  end
 
 
  if(buff((ind-1)*7+1)>reducedE)
  return 
  end
 
  alpha=0.01*buff((ind-1)*7+4)*exp(-buff((ind-1)*7+5)*reducedE.^buff((ind-1)*7+6))+buff((ind-1)*7+7)*E;
  
end
