function ret=move_charge_track(obj,signal_ind)
%% This routine moves the charges generated along the heavy ion track and
% compute the induced signal on electrodes.
% It takes as input:
%---------------------------------------------------------------
%signal_ind   a vector containing the index of the signal 
%             array (y x). If k multiples electrodes are considered
%             all the computed signal is stored in y,x ... y+k,x.    
%---------------------------------------------------------------
% The routine works by using the obj.charges array, obj.dt and the eletic field function.
% Be sure to have defined all those quantities before simulating particles movement.
% The function move each particle using the drift velocity data.
% If the meta-charge reach a volume containing a solid medium, it is destroyed.
% The routine return a negative value if there is a problem (no charges in obj.charges)
% Else it return the remaining number of meta charges. 
  vol=[];
  mat=[];
  ret=-1;
  E=0;
  v=0;
  dens=0;
  %find the charges
  charg=find(obj.charges(:,5)~=0);
 
  if(isempty(charg))% if no charges, return 
  return
  end
  
 size(charg)%debug
  for  i=charg'
  
    pos=obj.charges(i,1:3);% Get the position of the meta charge
    
    vol=obj.find_volume_by_location(pos');%find the volum where the charge is
    
    if(isempty(vol)) % Check if the charge is outside the geometry
     obj.charges(i,5)=0;
    else
      
      % find the material were the metacharge is.
      material=obj.geometry{4,vol};
      
      if(isempty(obj.get_W_value(material))) %if charge cannot drift in the material
        obj.charges(i,5)=0; % we kill it
        
      else %move the meta charge  
        E=obj.elec_field(obj.charges(i,1:3));
        dens=obj.geometry{5,vol};
      
        
        if(obj.charges(i,5)<0)% if charges are electrons use e drift velocity
        
        v=obj.e_drift_velocity(material,obj.compute_reduced_Efield(norm(E),material,dens(1)));
        
       % New position= last position + v.dt -> with v oriented along E
          obj.charges(i,1:3)=obj.charges(i,1:3)-E/norm(E)*v*obj.time_step;
     
         pos=obj.charges(i,1:3);% Get the position of the meta charge
    
        vol=obj.find_volume_by_location(pos');%find the volum where the charge is
         if(isempty(obj.get_W_value(material))) %if charge cannot drift in the material
            obj.charges(i,5)=0; % we kill it
          end 
       
          for el=0:max(size(obj.weighting_field))-1
            obj.signal(signal_ind(1)+el,signal_ind(2))=obj.signal(signal_ind(1)+el,signal_ind(2))+obj.charges(i,5)*obj.charges(i,4)*1.6e-19*dot(obj.charges(i,5)*E/norm(E)*v,obj.weighting_field{el+1}(obj.charges(i,1:3)));
          end
        % New position= last position + v.dt -> with v oriented along E
      
        
        else% if charges are ions, use ion drift velocity
        %compute the drift velocity (module). 
        v=obj.ion_drift_velocity(material,300,obj.compute_reduced_Efield(norm(E),material,dens(1)));
        obj.charges(i,1:3)=obj.charges(i,1:3)+E/norm(E)*v*obj.time_step;
          for el=0:max(size(obj.weighting_field))-1% go through the electrode to evaluate induced signal    
            obj.signal(signal_ind(1)+el,signal_ind(2))=obj.signal(signal_ind(1)+el,signal_ind(2))+obj.charges(i,5)*obj.charges(i,4)*1.6e-19*dot(obj.charges(i,5)*E/norm(E)*v,obj.weighting_field{el+1}(obj.charges(i,1:3)));
          end
        
        
        end
        
      end
      
      
    
    end
    

  
  end
  
  
  
end
