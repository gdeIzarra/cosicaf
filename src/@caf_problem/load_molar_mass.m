function ret=load_molar_mass(obj)
  
 obj.molar_mass=cell(0);

fich=fopen('molar_mass.dat','rb');
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
   % [medium fit E0 E1  a b c d]=sscanf(str,'%s\t%e\t%e\t%e\t%e\t%e\t%e\t%e','C');
     a=textscan(str,'%s %f');
 
     
    obj.molar_mass{1,i}=a{1}{:};
    obj.molar_mass{2,i}=a{2};

    i=i+1;
   end
    
  end

  fclose(fich);
  ret=1;
 
  
  
end
