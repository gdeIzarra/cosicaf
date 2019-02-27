function draw_particle_trajectory(obj, traj_ind)
  
  hold on;
  
  init_dat=obj.particle{2,traj_ind};
  
  traj_dat=obj.particle{3,traj_ind};
  
  
  plot3([init_dat(5) traj_dat(end-4)], [init_dat(6) traj_dat(end-3)], [init_dat(7) traj_dat(end-2)],'r','linewidth',2);
  
  hold off;
  
  
  
  
  
end