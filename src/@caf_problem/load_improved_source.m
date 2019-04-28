function ret=load_improved_source(obj,filename)
% COSICAF V2 24/04/2019
% This routine is able to load complex sources
% 

ret=0;
obj.source=cell(0);


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
  
   a=textscan(str,'%f %s %f %f');

    obj.source{1,i}=a{1};
    obj.source{2,i}=a{2}{:};
  	obj.source{3,i}= [a{3},a{4}];

    i=i+1; 
   end
    
  end

  fclose(fich);
  ret=1;


end
