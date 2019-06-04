function E=mpfd_E_field(pos)
  
  global obj
  global V_E
  global pos_voxel_E
  global pos_geom_E
  dl=0.5e-4;
  
  E=obj.compute_E_from_mc_V(pos,V_E,pos_voxel_E,pos_geom_E,dl);
  
  
  
  
end
