

fprintf('Initialising caf_problem object.\n');
obj=caf_problem();



obj.load_geometry('mpfd_geometry_paper.txt' );
obj.load_geometry_electrostat_dat('mpfd_geometry_paper_V_weighting1.txt');

[condlim,permit,pos_voxel,pos_geom]=obj.convert_geom_Vmcsolver(0.5e-4);



[acas1,bcas1]=mcVspecial(condlim,permit,10e6,1,96,1,96,60,100);