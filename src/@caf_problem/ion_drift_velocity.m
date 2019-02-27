function v=ion_drift_velocity(obj,ion,T,reducedE)
%% this routine compute the ion drift velocity
% by using the approximation given by the article:
% Approximation of the characteristics of ion drift in
%Parent Gas by Golyatina and Mairov.
% It is assumed that only ion moving in their parent 
% gas are considered in the model.
% 
% The routine takes as input:
%---------------------------------------------------------------
%ion        a string containing the name of the ion 'Ar' 'He' 'Xe'...  
%T          the temperature of the gaz, in (K)
%reducedE   The reduced electric field in (Td)
%---------------------------------------------------------------
%
% The routine return the celocity in (m/s) is sucessful. If there is a problem,
% thre tourine return an empty vector
%
  
 vel=[];

selected_data=find( strcmp(obj.ion_drift_data(1,:),ion));  
 
if(isempty(selected_data))
  return;
end 

buff=(obj.ion_drift_data{2,selected_data});
 
ind=find( buff([1:3:length(buff)])>=T);

if(isempty(ind) || length(ind)==1)
  return
end
 
 a= (buff((ind(2)-1)*3+2)-buff((ind(1)-1)*3+2))/(buff((ind(2)-1)*3+1)-buff((ind(1)-1)*3+1))*(T-(buff((ind(1)-1)*3+1)))+(buff((ind(1)-1)*3+2));
 bm= (buff((ind(2)-1)*3+3)-buff((ind(1)-1)*3+3))/(buff((ind(2)-1)*3+1)-buff((ind(1)-1)*3+1))*(T-(buff((ind(1)-1)*3+1)))+(buff((ind(1)-1)*3+3));
  
 v=a*(1+1/bm*reducedE).^(-0.5)*reducedE*1e-2; 
  
end
