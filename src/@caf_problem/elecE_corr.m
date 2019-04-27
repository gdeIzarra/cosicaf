function Ecorr=elecE_corr(obj,medium,particle,E)
%% Function to compute the proportion of particle
% energy which can be spend in electronic collisions.
% It take in input:
%-------------------------------
% medium a string containing the name of the medium
% particle a string containing the name of the projectile 
% E the kinetic energy of the projectile in MeV
%-------------------------------  
% For each energy given, the routine compute the remaining
% energy which is spent in electronic collision.
% From that, it is possible to derive a energy spent 
% for ionisation by using W values.
%
% The routine return an Energy in (MeV) if everything is ok.
%If there is a problem, an empty vector is returned 
  Ecorr=[];
  Er=0;
 
 if(E<0)
 Ecorr=0;
 return 
 end
selected_data=find(strcmp(obj.elecE_correc(2,:),particle)& strcmp(obj.elecE_correc(1,:),medium));  
 
if(isempty(selected_data))
  return;
end 

buff=cell2mat(obj.elecE_correc(3,selected_data));

Er=E/buff(1,1);

ind=find( buff([1:7:7*length(selected_data)]+2)>=Er & buff([1:7:7*length(selected_data)]+1)<Er);

if(isempty(ind))
  return
end
%f(x)=a*(1-exp(b*(x-c)**d))

  Ecorr=E*buff((ind-1)*7+4)*(1-exp(buff((ind-1)*7+5)*(Er-buff((ind-1)*7+6))^buff((ind-1)*7+7)));
  if(isreal(Ecorr)==0)
  Ecorr=0;
  end

end
