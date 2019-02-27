function ind=find_inner_volume(obj,volume_ind)
%% This function find the volume included in the
% volume with the index volume_ind.
%
%The function takes as parameter:
%-------------------------------
% volume_ind  the index of the volume to search in
%-------------------------------
%
% The routine return the indexes of volume included in the volume
% of interest or an empty vector if nothing is found.
%
% how it works:
% It first search all the volumes with ID above 
% the ID of the vol of interest.
% Then only the volume with the lowest ID are considered.
% Their position is roughly check (middle of bottom cylinder
% inside the volume of interest).

    ind=[];
    
 persistent IDgeom   
    %read the depth id of the volume
    ID=obj.geometry{1,volume_ind};
if(isempty(IDgeom))
   IDgeom=cell2mat(obj.geometry(1,:));
end
   inner=find(IDgeom>volume_ind);
  ref_vol=obj.geometry{3,volume_ind};
   r=0;
   
   buffer=[];
   
   
   if(isempty(inner)==0)
   
      inner=find(IDgeom==min(IDgeom(inner)));
   
      for i=inner
        
        buffer=obj.geometry{3,i};
        
        r=(buffer(4)-ref_vol(4))^2+(buffer(5)-ref_vol(5))^2;
        if( buffer(6)>=ref_vol(6) && buffer(6)<=ref_vol(3)+ref_vol(6) && r>=ref_vol(2).^2 && r<ref_vol(1).^2)
             
             ind(end+1)=i;
             
        end
      
      end
   
   
   end
   
end