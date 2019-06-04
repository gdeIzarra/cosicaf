

fprintf('Initialising caf_problem object.\n');
obj=caf_problem();



obj.load_geometry('mpfd_geometry_paper.txt' );
obj.load_geometry_electrostat_dat('mpfd_geometry_paper_V_SOLVER_case2.txt');

[condlim,permit,pos_voxel,pos_geom]=obj.convert_geom_Vmcsolver(0.5e-4);



[acas2,bcas2]=mcVspecial(condlim,permit,50e6,1,96,1,96,55,111);