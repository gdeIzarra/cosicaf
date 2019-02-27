function ret=propagate_heavy_particles(obj,approx)
  
  
  for i=1:obj.particle_nb
  obj.propagate_one_heavy_particle(i,approx);  
    
  end
  
  
end
