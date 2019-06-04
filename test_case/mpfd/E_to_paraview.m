
global obj
obj=caf_problem();


load 'Vmpfd_case1_correct_080219.mat'
global V_E;
global pos_voxel_E;
global pos_geom_E;
V_E=smooth3(Vcas1);
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


xd=[-47*0.5e-4:0.5e-4:48*0.5e-4];
yd=[-47*0.5e-4:0.5e-4:48*0.5e-4];
zd=[0:0.5e-4:222*0.5e-4];


fich=fopen('Eweight_para.txt','W');

fprintf(fich,'x,y,z,vx,vy,vz\n');
for i=1:221
  
  for j=1:96-1
    
        for k=1:96-1
      
          if(i==1 || j==1 || k==1)
          fprintf(fich,'%e,%e,%e,%e,%e,%e\n',zd(i),yd(j),xd(k),0,0,0);
          else
          res=obj.compute_E_from_mc_V([xd(k) yd(j) zd(i)],V_EW,pos_voxel_E,pos_geom_E,0.5e-4);
          fprintf(fich,'%e,%e,%e,%e,%e,%e\n',zd(i),yd(j),xd(k),res(1),res(2),res(3));
          end
        end
   end
  
end


fclose(fich);