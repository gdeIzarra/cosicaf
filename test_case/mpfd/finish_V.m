



for i=1:size(condlim,1)
  
  
    for j=1:size(condlim,2);

      for k=1:size(condlim,3);
        if(condlim(i,j,k)~=1e9)
          V_cas2(i,j,k)=condlim(i,j,k);
        end
      end
    
    end 
  
  
end
