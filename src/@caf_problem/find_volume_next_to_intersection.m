function ind=find_volume_next_to_intersection(obj,pos,direction)
%% function to find the volume next to te intersection point
% 
%The routine takes as parameter:
%-------------------------------
% pos         a vector defining the position of intersection point between
%             trajectory and volume.
% direction   a vector defining the direction of the particle.     
%-------------------------------
%
% the function return the index of the volume if everything is ok.
% if the boundary of the problem is reached, the -1 is returned.
% The volume with no collision are omitted.



delta=10e-9; % the precision limit to find the next volume.


ind=obj.find_volume_by_location(pos+direction*delta);

if(isempty(ind))
ind=-1;
end




end
