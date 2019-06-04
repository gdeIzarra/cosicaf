function E=mpfd_EW_field(pos)
  
    global obj
  global V_EW
  global pos_voxel_EW
  global pos_geom_EW
  
  
  dl=0.5e-4;
  
  E=obj.compute_E_from_mc_V(pos,V_EW,pos_voxel_EW,pos_geom_EW,dl);
  
  
  
  
end
