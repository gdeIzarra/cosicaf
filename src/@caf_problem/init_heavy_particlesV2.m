function ret=init_heavy_particlesV2(obj)
%% This function initialise all the heavy particles the user
% asked to simulate.
%  
% To make the initialisation possible, a valid geometry
% must be loaded in memory.
%
% The function first compute the propagation direction of
% every particle. Then, it goes accross the geometry and
% find all the sources. For each sources, a number of particle
% defined by the emission of the source is generated with:
% the proper initial energy, the proper emission point, the reference
% to the volume of origin.
%
% If everything is ok, the function return 1.

ret=0;

if(isempty(obj.geometry))
  return;
end

% initialisation of the cell array which will contain info about particles
obj.particle=cell(3,obj.particle_nb);

cnt=0; % particle counter
part_nb=0; % number of particle from each source to create

%computation of particles moving direction
ang1=2*pi*rand(1,obj.particle_nb); % computation of random diection
ang2=acos(1-2*rand(1,obj.particle_nb));
%direction vectors are estimated with simple trigonometry
% zero padding are used to allocate memory for other data (energy, position x y z, volume)
direc=[ cos(ang1) .*sin(ang2) ; sin(ang1).*sin(ang2);  cos(ang2);zeros(5,obj.particle_nb)];


if(isempty(obj.source))
%% --------------------------------------
%% ORIGINAL CODE FOR REGULAR SOURCE
%% --------------------------------------

%particle(2,:)=mat2cell(direc,3,ones(1,particle_nb));

      for i=1:size(obj.geometry,2) % go accross the whole geometry

          buffer=obj.geometry{7,i}; % get info about sources
          
          if(buffer(1)==1) % if the volume is a source
            
            %compute the number of particle to generate for this particuliar source
            part_nb=round(buffer(3)*obj.particle_nb);
            
            % set the proper particles name 
           [ obj.particle{1,1+cnt:cnt+part_nb}]= deal(obj.geometry{6,i});
            
            %set the proper energy and volume for each particle
            direc(4,1+cnt:cnt+part_nb)=buffer(2);
            direc(8,1+cnt:cnt+part_nb)=i;
            
            %compute the emission location of the particle
            buffer=obj.geometry{3,i};
           
              r=sqrt((rand(1,part_nb).*( buffer(1)-buffer(2))+buffer(2))./buffer(1));
              angpos=2*pi*rand(1,part_nb);
       
              direc(5,1+cnt:cnt+part_nb)=(r*buffer(1)).*sin(angpos)+buffer(4);
              direc(6,1+cnt:cnt+part_nb)=(r*buffer(1)).*cos(angpos)+buffer(5);
              direc(7,1+cnt:cnt+part_nb)=buffer(3).*rand(1,part_nb)+buffer(6);
               
               
              
           
            cnt=cnt+part_nb;
          end
          


      end
%% --------------------------------------
%%  END OF ORIGINAL CODE FOR REGULAR SOURCE
%% --------------------------------------	  
else

		source_index=1;
    source_buff=[];% buffer used to store the info of the current extended source used.
    source_prop=0;
		   for i=1:size(obj.geometry,2)
		   
		   buffer=obj.geometry{7,i}; % get info about sources
		   
		   
		   if(buffer(1)==1) % if the volume is a source
		   
             %Compute the number of particle in the extended source:
             source_buff=find(cell2mat(obj.source(1,:))==source_index);
             
             if(isempty(source_buff)) % if there is a mistake in the extended source definition
               return;
             end 
             source_prop=obj.source{3,source_buff(1)}
              part_nb=round( source_prop(2)*obj.particle_nb/length(source_buff));
             
             %generate the particles
             for j=0:part_nb-1
             
             %compute the position of emission. for each source, the emission point is similar
              buffer=obj.geometry{3,i};
              r=sqrt((rand().*( buffer(1)-buffer(2))+buffer(2))./buffer(1));
              angpos=2*pi*rand();
              direc(5,1+cnt+(j)*length(source_buff):cnt+(j+1)*length(source_buff))=(r*buffer(1)).*sin(angpos)+buffer(4);
              direc(6,1+cnt+(j)*length(source_buff):cnt+(j+1)*length(source_buff))=(r*buffer(1)).*cos(angpos)+buffer(5);
              direc(7,1+cnt+(j)*length(source_buff):cnt+(j+1)*length(source_buff))=buffer(3).*rand()+buffer(6);
               
               
            
                for k=0:length(source_buff)-1
                  
                  %get info about this specific particle in the current source
                  source_prop=obj.source{3,source_buff(k+1)}
                  %set the proper particle name
                   obj.particle{1,1+cnt+k+j*length(source_buff)}=obj.source{2,source_buff(1+k)}
                  %set the proper energy
                   direc(4,1+cnt+k+j*length(source_buff))=source_prop(1);
                   %set the volume 
                   direc(8,1+cnt+k+j*length(source_buff))=i;
                   
                   %Set the direction,  
                  direc(1:3,1+cnt+k+j*length(source_buff))=direc(1:3,1+cnt+j*length(source_buff))*(-1).^k;
                end
             
             end
             
             cnt=cnt+part_nb*length(source_buff);
             
             source_index=source_index+1;
		   
		   
		   end
		   
		 
       end

       
       
end


       obj.particle(2,:)=mat2cell(direc,8,ones(1,obj.particle_nb));
	   %if the particle number is not exactely the one asked:
     %correct it
     if(cnt~=obj.particle_nb)
     obj.particle_nb=cnt;
     end
	   
     %V2: now gases sources are available.
       % An extra step is required to check if the source is generated in volume inner volume or not
       for i=1:obj.particle_nb
       
       buff=obj.particle{2,i}
        if(  buff(8)~=obj.find_volume_by_location(buff(5:7)))
          'aie'
          buff(8)=obj.find_volume_by_location(buff(5:7));
          buff(4)=0.000
          obj.particle{2,i}=buff;
        end     
       end
     
ret=1;
end



        