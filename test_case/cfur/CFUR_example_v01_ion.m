% V 0.1 12/2018 buiding a clean example file for CFUR 4mm.
%

clear all;
rand('seed',132451245559);
fprintf('*******************************************************************\n');
fprintf('************** FISSION CHAMBER SIMULATION: CFUR 4 mm **************\n');
fprintf('*******************************************************************\n');
fprintf('* version 0.1 December 2018   *************************************\n');
fprintf('* In this example, a 4 mm cylindrical fission chamber is     ******\n');
fprintf('* simulated. The goal is to crosscheck with chester and pyfc.******\n');
fprintf('* Here only a basic geometry and a analitycal electric field ******\n');
fprintf('* and wieghting field is considered.                         ******\n');
fprintf('*******************************************************************\n');


fprintf('Initialising caf_problem object.\n');
obj=caf_problem(); % A caf_problem object is absolutely needed to use moderation
                   % laws and advanced simulation features.
                   
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

% data needed for simulation is now in memory, we can start to work.

%Example of using moderation laws:
fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Testing moderation laws ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');                   
fprintf('********Testing moderation law **********\n');        
fprintf('HffU5 in Ar 0.0017 g/cm^3, E after 1 cm : pow %e (MeV), poly %e (MeV)\n',obj.moderation_law('Ar',0.0017,'hffU5',1e-2,'POW'), obj.moderation_law('Ar',0.0017,'hffU5',1e-2,'POLY'));

fprintf('********Testing inverse moderation law **********\n');
fprintf('HffU5 in Ar 0.0017 g/cm^3, l at energy 16.2Mev : pow %e (m), poly %e (m)\n',obj.inverse_moderation_law('Ar',0.0017,'hffU5',16.204, 'POW'),obj.inverse_moderation_law('Ar',0.0017,'hffU5',16.16445, 'POLY'));
fprintf('HffU5 in Ar 0.0017 g/cm^3, l at energy 68.5Mev : pow %e (m), poly %e (m)\n',obj.inverse_moderation_law('Ar',0.0017,'hffU5',68.5, 'POW'),obj.inverse_moderation_law('Ar',0.0017,'hffU5',68.5, 'POLY'));





fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Loading CFUR geometry ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  

fprintf('Loading geometry ...cfur_geometry_paper.txt');
obj.load_geometry('cfur_geometry_paper.txt' );

fprintf('Drawing geometry...');
obj.draw_geometry();

fprintf('Pause, type a key to continue.\n');
pause();

fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Selecting simulation parameters ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  

fprintf('Setting the number of fission fragment to simulate: 1000\n');
obj.particle_nb=5000;

fprintf('Setting the number of meta charges to follow: 500\n');
obj.charge_nb=300;

fprintf('Setting the simulation time step and the sim max time\n');
obj.time_step=0.02e-6;
obj.max_time=10e-6;

fprintf('\n*----------------------------------------------------------------\n');
fprintf('**Setting the Electric field ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  

obj.elec_field=@CFUR_E
obj.weighting_field=cell(1)
obj.weighting_field{1}=@CFUR_weighting_E

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
for i=11:20
  obj.draw_particle_trajectory(i);
end

obj.draw_geometry();


fprintf('\n*----------------------------------------------------------------\n');
fprintf('**generating charge tracks ...                                      \n');
fprintf('*----------------------------------------------------------------- \n');  


t=[0:obj.time_step:round(obj.max_time/obj.time_step-1)*obj.time_step];

average_signal=zeros(1,round(obj.max_time/obj.time_step))
average_nb=0;
min_pul=[]
ind_pul=[]
pul=[];

for i=1:obj.particle_nb

ret=obj.generate_charge_track(i,'POLY');

if(isempty(ret)==0)
obj.signal=zeros(1,round(obj.max_time/obj.time_step))
obj.kill_electrons();
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


