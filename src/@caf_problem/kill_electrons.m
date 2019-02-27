function ret=kill_electrons(obj)
  
  
    charg=find(obj.charges(:,5)<0);
  
  obj.charges(charg,5)=0;
  
end
