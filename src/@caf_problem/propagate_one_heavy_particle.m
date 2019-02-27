function ret=propagate_one_heavy_particle(obj,part_index,approx)
%% routine to propagate a particle along the geometry.
% before being called, be sure the particle you want to propagate
% has been initialized.
%
% The routine takes as input:
%-------------------------------
%part_index the index of the particle to propagate
%approx 'POLY' or 'POW' depending the moderation law to use
%-------------------------------
%
% This routine makes propagate the particle from volume boundary
% to volume boundary until it has no more energy or it reach the outside
% of the geometry. 
%
buff=obj.particle{2,part_index};


travel=zeros(1,200);
travel_count=0;

vec=[];
in_vec=[];
inner_vol=[];

particle=obj.particle{1,part_index};

dir=[buff(1) buff(2) buff(3)] ; %direction of the particle
cur_pos=[buff(5) buff(6) buff(7)]; % position of the particle
cur_energy=buff(4); % energy of the particle
cur_volume=buff(8); % where the particle is.
next_volume=0;% where the particle will be
next_energy=0;% what will be the energy of the particle

L=0;% distance traveled by the particle in the current volume+ offset 


%data about the current volume material.
mat='';
vol_mass=0;


'start'

while(1)

  %first step-> find the intersection of the trajectory with current volume.

  %inner_vol=obj.find_inner_volume(cur_volume);% check if there is inner volume inside the current volume of interest
  
  %compute the intersection with the current volume
  vec=obj.find_intersection_point(cur_volume,dir,cur_pos);

  % if volumes are included into current volume, find intersection points

  
  
  if(isempty(vec))
  fprintf('Error, could not find intersection point in vol %d, pos %e %e %e, dir %e %e %e\n',cur_volume,cur_pos(1),cur_pos(2),cur_pos(3),dir(1),dir(2),dir(3));
  end

    %compute energy lost between two intersections of volume
   mat=obj.geometry{4,cur_volume}; 
   vol_mass=obj.geometry{5,cur_volume}(1);
   L=obj.inverse_moderation_law(mat,vol_mass,particle,cur_energy, approx);
   norm(vec-cur_pos)
  next_energy=obj.moderation_law(mat,vol_mass,particle,L+norm(vec-cur_pos),approx);
  % mat
  % vol_mass
  % particle 
  %    vec
  % sqrt(vec(1)^2+vec(2)^2)

   %second step -> find the next volume
  next_volume=obj.find_volume_next_to_intersection(vec,dir);
  cur_volume
  next_volume
  cur_pos
  vec
  
  %storing data in travel vector
  travel(travel_count*6+1)=next_energy; %Energy
  travel(travel_count*6+2)=vec(1);
  travel(travel_count*6+3)=vec(2);
  travel(travel_count*6+4)=vec(3);
  travel(travel_count*6+5)=cur_volume;
  travel(travel_count*6+6)=next_volume;
  travel_count=travel_count+1;

cur_volume=next_volume;  
cur_energy=next_energy;
cur_pos=vec;
   
  if(next_energy<0)% no more kinetic energy for the particle, stop propagation
  break;
  end  
    

  if(next_volume==-1) % no next volume, the geometry limit is reached
  break;
  end

obj.geometry{2,next_volume}
  if(strcmp(obj.geometry{2,next_volume},'stop'))% the next volume is a stop-> propagation is stopped
 break;
  end

end

% only the useful part of travel vector is copied
obj.particle{3,part_index}=travel(1:travel_count*6);


end