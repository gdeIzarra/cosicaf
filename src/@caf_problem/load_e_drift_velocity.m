function ret=load_e_drift_velocity(obj)
  ret=0;
  obj.e_drift_data=cell(0);
    
  fich=fopen('e_drift_velocity.dat','rb');
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
     a=textscan(str,'%s %f %f %f %f %f %f %f');
    obj.e_drift_data{1,i}=a{1}{:};
     obj.e_drift_data{2,i}=[a{2},a{3},a{4},a{5},a{6},a{7},a{8}];
    %obj.e_drift_data{1,i}=medium;
    %    obj.e_drift_data{2,i}=[fit,E0, E1,a,b,c,d];
    i=i+1;
   end
    
  end

  fclose(fich);
  ret=1;
  
  end
