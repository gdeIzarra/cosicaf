function ret=load_moderation_laws(obj)
  ret=0;
  obj.moderation_laws=cell(0);
    
  fich=fopen('moderation_law.dat','rb');
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
  
     % [medium particle E0 R n a b c d]=sscanf(str,'%s\t%s\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e','C');
      a=textscan(str,'%s %s %f %f %f %f %f %f %f %f');
      obj.moderation_laws{1,i}=a{1}{:};
     obj.moderation_laws{2,i}=a{2}{:};
    obj.moderation_laws{3,i}=[a{3}, a{4},a{5},a{6},a{7},a{8},a{9},a{10}];
      % obj.moderation_laws{1,i}=medium;
     % obj.moderation_laws{2,i}=particle;
     % obj.moderation_laws{3,i}=[E0, R,n,a,b,c,d];
    i=i+1;
   end
    
  end

  fclose(fich);
  ret=1;
  
  end