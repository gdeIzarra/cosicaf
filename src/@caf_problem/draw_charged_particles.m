function draw_charged_particles(obj, sign)
  
  hold on;
  

  dat=obj.charges( find(obj.charges(:,5)==sign),1:3)
  
  plot3(dat(:,1), dat(:,2), dat(:,3),'r','linewidth',2);
  
  hold off;
  
  
  
  
  
end