function ind=find_volume_by_location(obj,pos)
%% This function allo to find in which volum
% a position refers. It is useful for particles
% propagation to probe interfaces of volumes and
% adapt the stopping power, material etc...
%
%The function take as parameter:
%-------------------------------
% pos  a three element vector defining the position.
%-------------------------------
% the function return the index of the volume refered
% by the position. It avoids volumes with no_collision key.

    ind=[];
 persistent IDgeom   


    r=0;
    buffer=[];
    
if(isempty(IDgeom))    
   IDgeom=cell2mat(obj.geometry(1,:));
end    
    [sortIDgeom,sortind]=sort(IDgeom);
   % sortind(end:-1:1);
    for i=sortind(end:-1:1);
    
        buffer=obj.geometry{3,i};
        r=(buffer(4)-pos(1))^2+(buffer(5)-pos(2))^2;
       % buffer(1)
        if( pos(3)>=buffer(6) && pos(3)<=buffer(3)+buffer(6) && r>=buffer(2).^2 && r<buffer(1).^2)
             
             if(strcmp(obj.geometry{2,i} ,'no_coll')==0)
             ind=i;
             return
             end
             
        end
    
    
    end


end