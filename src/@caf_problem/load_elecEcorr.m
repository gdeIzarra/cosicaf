function ret=load_elecEcorr(obj)
  
  ret=0;
  obj.elecE_correc=cell(0);
    
  fich=fopen('elecE_corr.dat','rb');
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
  
      a=textscan(str,'%s %s %f %f %f %f %f %f %f');
      obj.elecE_correc{1,i}=a{1}{:};
     obj.elecE_correc{2,i}=a{2}{:};
    obj.elecE_correc{3,i}=[a{3}, a{4},a{5},a{6},a{7},a{8},a{9}];
      
      
    i=i+1;
   end
    
  end

  fclose(fich);
  ret=1;
  
 end
 