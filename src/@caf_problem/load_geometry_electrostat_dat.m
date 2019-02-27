function ret=load_geometry_electrostat_dat(obj,filname)
  

obj.geometry_electrostat=cell(0);

fich=fopen(filname,'rb');
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
     a=textscan(str,'%s %s %s %s %s ');
 
     obj.geometry_electrostat{i}=[a{1},a{2},a{3},a{4},a{5}];
   

    i=i+1;
   end
    
  end

  fclose(fich);
  ret=1;

end
