function E=CFUR_weighting_E(pos)
  
  % E(r)= dV/(rlog(Ro/Ri))
  
 vec=[pos(1) pos(2) 0];
  vec=vec/norm(vec);
  
  r=sqrt(pos(1).^2+pos(2).^2);
  
  E=1/(r*log(1.25/1))*vec;
  
  if(r<1e-3)
    E=[0 0 0];
  end
  
end
