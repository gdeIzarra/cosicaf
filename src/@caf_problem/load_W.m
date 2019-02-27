function ret=load_W(obj)
  
   ret=0;
  obj.W=cell(0);
    
  fich=fopen('W.dat','rb');
   if(fich==0)
   return;
   end
   
 
    i=1;
  while(1)
   str=fgetl(fich);
    if(str==-1)
      break;
    end;
    
    if(str(1)~='#')
    %[medium W]=sscanf(str,'%s\t%e','C');
    a=textscan(str,'%s %f');
   
    obj.W{1,i}=a{1}{:};
    obj.W{2,i}=a{2};
    %obj.W{1,i}=medium;
    %obj.W{2,i}=W;
    i=i+1;
    end
  
 
  end

  fclose(fich);
  ret=1;

  
  
  
end