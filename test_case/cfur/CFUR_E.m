function E=CFUR_E(pos)
  
  % E(r)= dV/(rlog(Ro/Ri))
  
  vec=[pos(1) pos(2) 0];
  vec=vec/norm(vec);
  
  r=sqrt(pos(1).^2+pos(2).^2);
  
  E=250/(r*log(1.25/1))*vec;
  
  
  
end
