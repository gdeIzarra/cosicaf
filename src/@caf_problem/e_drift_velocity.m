function vel=e_drift_velocity(obj,medium,reducedE)
%% Function to compute the drift velocity of electron
%  for different media.
% The routine takes as input:
%-------------------------------
% medium a string containing the name of the medium
% reduced field in  (Td)
%-----------------------------
% The function return the drift velocity in (m/s) if everything 
% is ok. In case of error, it returns an empty array.  
  
vel=[];
buff=[];
selected_data=find( strcmp(obj.e_drift_data(1,:),medium));  
 
if(isempty(selected_data))
  return;
end 


buff=cell2mat(obj.e_drift_data(2,selected_data));


ind=find( buff([1:7:7*length(selected_data)]+2)>=reducedE & buff([1:7:7*length(selected_data)]+1)<reducedE);

if(isempty(ind))
  fprintf('error, no e drift velocity for this reduced field\n'); 
  return
end
%error not able to find proper data.

% Using the fitted function to evaluate the velocity.
% since velocity is in 10^3 m/s, conversion factor  1e3 have to be added.
    switch(buff((ind-1)*7+1))
      case 0
        vel=1e3*buff((ind-1)*7+4)*reducedE.^buff((ind-1)*7+5);
      case 1
        vel=1e3*( buff((ind-1)*7+4)*reducedE+buff((ind-1)*7+5)*reducedE.^2.0+buff((ind-1)*7+6)*reducedE.^3+buff((ind-1)*7+7));
      case 2
        vel=1e3*buff((ind-1)*7+4)*(1-exp(buff((ind-1)*7+5)*(x).^buff((ind-1)*7+6)));
      otherwise  
      return
   end

 end
  
