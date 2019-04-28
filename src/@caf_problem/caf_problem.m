classdef caf_problem < handle

properties

%--------------------------------
%geometry definition
%--------------------------------

geometry=[];
%How the geometry array is organised:
%
% All the geometry is defined by cylinder or cylinder shells.
% Id,type, external Radius,internal radius, Height, position,material,density,electrode,source, particle, Energy, emission.
% 
% *The id give the inclusion relationship. The lowest id contain object with higher id.
% *The type specify if the volume is regular, contain the problem bounds, or is a no collision volume, or stop everything
% *External radius should be always positive.
% *Internal radius could be null or positive. It has to be < external radius
% *Height is the total height of the cylinder
% *Position is a 3 element vector which define lower base center of the cylinder.
% *Material is a string defining the material in the volume
% *Density is the density of the material in mg/cm^3
% *Electode specify if the the volume is an electrode (1) or not (0).
% *Particle is a string defining the type of emitted particle.
% *Energy is the energy of the emitted particle (in MeV)
% *Emission is the fraction of particle emitted by the source.


geometry_electrostat=[];
% Geompetry_electrostat contain all the data needed to 
% solve the poisson equation for the loaded geometry.
% It contains a cell array wich contain the boundary 
% or the keyword 'no' if no boundary is needed for that
% particular volume.
% The boundary value and the relative permittivity are organised
% as follow:
% InnerV outerV upperV lowerV permittivity
% 
%

%--------------------------------
%source definition. 
%--------------------------------
%added for COSICAF V2. 23/04/2019

source=[];
%source is a cell array which contains all the data about the
% complex source like correlated ones.
% Each line of this matrix contain:
% source nb | particle_name | energy |total emission of the source


%--------------------------------
%particle definition.
%--------------------------------

particle_nb=1000;
particle=[];
% particle is a cell matrix wich contains vector with variable length.
% The vector format is as follow:
% particle_name| Orientation vector, init_Energy, init_position, init_volume| energy, position, out_volume,in_volume,...


%--------------------------------
%charge generation
%--------------------------------
charge_nb=1000;
charges=[];


%--------------------------------
%electric_field
%--------------------------------

elec_field;

%--------------------------------
%pulses generation
%--------------------------------

time_step=0.1e-9; % time step for pulses computation.
max_time=1e-7;% maximum time step.

weighting_field;% cell containing weighting field for all the eletrodes



signal=[];% array containging the signal computed on all the electrodes 

%--------------------------------
% Data for particle slowing down
%--------------------------------

moderation_laws=[];% cells containing the moderation laws data

elecE_correc=[]; %correction to take into account only the electronic stopping power
               %in the moderation laws
               
               
               
%--------------------------------
% Data for charge generation
%--------------------------------

W=[];

%--------------------------------
% Data for ions/electron drifts 
%--------------------------------

e_drift_data=[];
ion_drift_data=[];
molar_mass=[];

%--------------------------------
% Data for townsend ionisation coefficient (to add)
%--------------------------------

townsend_data=[];


end

methods
%------------------------------------------------------
% methods to load the data for the simulation
%------------------------------------------------------
ret=load_moderation_laws(obj);
ret=load_W(obj);
ret=load_molar_mass(obj,filename)
ret=load_e_drift_velocity(obj);
ret=load_ion_drift_velocity(obj);

ret=load_elecEcorr(obj);


ret=load_townsend_i_coef(obj);

%------------------------------------------------------
% Low level methods for physics computation...
%------------------------------------------------------

%compute moderation laws
E=moderation_law(obj,medium,mass_vol,particle,dist,approx);

%compute inverse moderation laws to estimate energy from traveled distance
l=inverse_moderation_law(obj,medium,mass_vol,particle,E, approx);

%compute the range 
R=range(obj,medium,mass_vol,particle);

% compute the energy to spend in electronic collision 
Ecorr=elecE_corr(obj,medium,particle,E);

%Get the electron drift velocity in a specific medium
vel=e_drift_velocity(obj,medium,reducedE);

v=ion_drift_velocity(obj,ion,T,reducedE);

W=get_W_value(obj,material);


%------------------------------------------------------
% methods to load and check the geometry
%------------------------------------------------------
ret=load_geometry(obj,filename);
ret=load_geometry_electrostat_dat(obj,filename);
ret=check_geometry(obj);
draw_geometry(obj);

%improvement Cosicaf V2 (24/04/2019)
ret=load_improved_source(obj,filename);

%------------------------------------------------------
%methods to make computation in space
%------------------------------------------------------
vec=find_intersection_point(obj,volume_ind,direction,pos);
ind=find_inner_volume(obj,volume_ind);%to check
ind=find_volume_by_location(obj,pos);%to check

ind=find_volume_next_to_intersection(obj,pos,direction);%to check



%------------------------------------------------------
%methods to generate and propagate particles in geometry
%------------------------------------------------------
ret=init_heavy_particles(obj);
ret=propagate_one_heavy_particle(obj,part_index,approx); 
ret=propagate_heavy_particles(obj,approx);%to do


t=compute_hion_traveling_time(obj,medium, mass_voll,particle,beg,fin,approx);



draw_particle_trajectory(obj, traj_ind);

%------------------------------------------------------
%methods to generate and propagate charges in geometry
%------------------------------------------------------

ret=generate_charge_track(obj, part_index,approx);

ret=kill_electrons(obj);
ret=kill_ions(obj);

ret=move_charge_track(obj,signal_ind);
Er=compute_reduced_Efield(obj,E,mat,density);

E=compute_E_from_mc_V(obj,x,V,pos_voxel,pos_geom,dl);


%------------------------------------------------------
%methods to generate a discrete geometry and solve the Poisson equation
%------------------------------------------------------
[condlim,permit,pos_voxel,pos_geom]=convert_geom_Vmcsolver(obj,dl);
ret=solve_mc_V(obj,condlim,permit,geom,iter);



end


end
