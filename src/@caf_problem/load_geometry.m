function l=load_geometry(obj,filname);
%%
%
%

obj.geometry=cell(0);

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
     a=textscan(str,'%f %s %f %f %f %f %f %f %s %f %f %f %s %f %f');

    obj.geometry{1,i}=a{1};
     obj.geometry{2,i}=a{2}{:};
	obj.geometry{3,i}= [a{3},a{4},a{5},a{6},a{7},a{8}];
	 obj.geometry{4,i}=a{9}{:};
	obj.geometry{5,i}= [a{10},a{11}];
  obj.geometry{6,i}=a{13}{:};
  obj.geometry{7,i}=[a{12},a{14},a{15}];
    %obj.e_drift_data{1,i}=medium;
    %    obj.e_drift_data{2,i}=[fit,E0, E1,a,b,c,d];
    i=i+1;
   end
    
  end

  fclose(fich);
  ret=1;

end
