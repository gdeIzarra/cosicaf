

fprintf('Initialising caf_problem object.\n');
obj=caf_problem();



obj.load_geometry('mpfd_geometry_paper.txt' );
obj.load_geometry_electrostat_dat('mpfd_geometry_paper_V_weighting1.txt');

[condlim,permit,pos_voxel,pos_geom]=obj.convert_geom_Vmcsolver(0.5e-4);



[awf2,bwf2]=mcVspecial(condlim,permit,30e6,1,96,1,96,55,111);