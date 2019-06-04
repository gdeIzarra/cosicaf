
clear all;
rand('seed',1324565459);
fprintf('Initialising caf_problem object.\n');
global obj
obj=caf_problem();


                 
fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Loading simulation data ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');                   
                   
fprintf('Loading moderation law...;');
ret=obj.load_moderation_laws();
if(ret==1)
fprintf('sucess\n');
else
fprintf('error\n');
end

fprintf('Loading elecE correction...;');
ret=obj.load_elecEcorr();
if(ret==1)
fprintf('sucess\n');
else
fprintf('error\n');
end


fprintf('Loading W values...');
ret=obj.load_W();
if(ret==1)
fprintf('sucess\n');
else
fprintf('error\n');
end

fprintf('Loading e drift velocity...');
ret=obj.load_e_drift_velocity();
if(ret==1)
fprintf('sucess\n');
else
fprintf('error\n');
end


fprintf('Loading ion drift velocity...');
ret=obj.load_ion_drift_velocity();
if(ret==1)
fprintf('sucess\n');
else
fprintf('error\n');
end



fprintf('Loading molar mass...');
ret=obj.load_molar_mass();
if(ret==1)
fprintf('sucess\n');
else
fprintf('error\n');
end





fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Loading MPFD geometry ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  

fprintf('Loading geometry ...mpfd_geometry_paper.txt');
obj.load_geometry('mpfd_geometry_paper.txt' );

fprintf('Drawing geometry...');
%obj.draw_geometry();

fprintf('Pause, type a key to continue.\n');
%pause();


fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Selecting simulation parameters ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  


fprintf('Setting the number of fission fragment to simulate: 1000\n');
obj.particle_nb=400;


fprintf('Setting the number of meta charges to follow: 500\n');
obj.charge_nb=300;

fprintf('Setting the simulation time step and the sim max time\n');
obj.time_step=0.4e-9;
obj.max_time=500e-9;



fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Setting the Electric field ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  


load 'Vmpfd_case2_correct_110219.mat'
global V_E;
global pos_voxel_E;
global pos_geom_E;
V_E=smooth3(V_cas2);
pos_voxel_E=[48 48 1];
pos_geom_E=[0 0 0];

obj.elec_field=@mpfd_E_field

load 'Vmpfd_weigthing1_correct_080219.mat'

global V_EW;
global pos_voxel_EW;
global pos_geom_EW;
V_EW=smooth3(Vbwf2);
pos_voxel_EW=[48 48 1];
pos_geom_EW=[0 0 0];


obj.weighting_field=cell(1)
obj.weighting_field{1}=@mpfd_EW_field

fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Starting simulation ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  

fprintf('initialising fission fragments...\n');
obj.init_heavy_particles();

fprintf('Computing fission fragment trajectories...\n');

for i=1:obj.particle_nb;
obj.propagate_one_heavy_particle(i,'POLY');
end

fprintf('drawing few fission fragment trajectories...\n');
%drawing few particles trajectory
clf()
%for i=1:100
%  obj.draw_particle_trajectory(i);
%end

obj.draw_geometry();




fprintf('\n*----------------------------------------------------------------\n');
fprintf('**generating charge tracks ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  


t=[0:obj.time_step:round(obj.max_time/obj.time_step-1)*obj.time_step]
average_signal=zeros(1,round(obj.max_time/obj.time_step))
average_nb=0;
min_pul=[]
ind_pul=[]
pul=[];

for i=27:400

ret=obj.generate_charge_track(i,'POLY');

if(isempty(ret)==0)
obj.signal=zeros(1,round(obj.max_time/obj.time_step))
obj.kill_ions();
  for j=1:round(obj.max_time/obj.time_step) % time step for pulses computation.
    
  obj.move_charge_track([1,j]);  
  end
  %break;
  min_pul(end+1)=max(obj.signal);
  ind_pul(end+1)=i;
  pul(end+1,:)=obj.signal;
  average_signal=average_signal+obj.signal;
  average_nb=average_nb+1;
  end

end



clf()
for i=ind_pul
  obj.draw_particle_trajectory(i);
end

obj.draw_geometry();
