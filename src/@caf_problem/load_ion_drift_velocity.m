function ret=load_ion_drift_velocity(obj)
%% Routine to load the data needed to
% compute ions drift velocities.
%  
 ret=0;
  obj.ion_drift_data=cell(0);
    
  fich=fopen('ion_drift_velocity.dat','rb');
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
   %He	4.2	5632	17	77	4162	33	300	2774	85	1000	1787	210	2000	1374	410

    a=textscan(str,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
    obj.ion_drift_data{1,i}=a{1}{:};
     obj.ion_drift_data{2,i}=[a{2},a{3},a{4},a{5},a{6},a{7},a{8},a{9},a{10},a{11},a{12},a{13},a{14},a{15},a{16}];
    %obj.ion_drift_data{1,i}=medium;
    %    obj.ion_drift_data{2,i}=[fit,E0, E1,a,b,c,d];
    i=i+1;
   end
    
  end

  fclose(fich);
  ret=1;
  
  end