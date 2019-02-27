
#include <octave/octave.h> 
#include <octave/oct.h>
#include <octave/parse.h>


// arguments: condlim, permit, nbiteration
DEFUN_DLD (mcVspecial, args, nargout,
           "Speed up computation of monte carlo")
{
	
	
  octave_value_list rand_val;// data to store random value
  octave_value_list ret;
  int itermc=0;// number of monte carlo iteration
  int x,y,z;
  int l1,l2,l3;
  double up,down,left,right,forward,backward; //probability for random walk.
  double Vf=0;// Final Voltage 
  int xr,yr,zr;//position
  
  int nargin = args.length ();
  if(nargin !=9)
  print_usage();
  else
  {
	  
  NDArray condlim = args(0).array_value ();// Store the argument in arrays
  NDArray permit = args(1).array_value ();
  itermc=int(args(2).scalar_value());
  xr=int(args(3).scalar_value())-1;
  l1=int(args(4).scalar_value());
  yr=int(args(5).scalar_value())-1;
  l2=int(args(6).scalar_value()); 
  zr=int(args(7).scalar_value())-1;
  l3=int(args(8).scalar_value()); 
    
  dim_vector dim_geom = condlim.dims();   //get the size of the geometry array
  NDArray V(dim_geom,0.0);
  NDArray nbcount(dim_geom,0.0);
  NDArray pos(dim_vector(3,dim_geom(0)*dim_geom(1)*dim_geom(2)/3),0.0);
  int pos_nb=0;
  
    
  rand_val=feval("rand"); //call rand function and get the value
   //rand_val.scalar_value ->recuperer la valeur scalaire  
  printf("test: %f %f %d\n",condlim(0,0,0),rand_val(0).scalar_value (),dim_geom(0));// TEST FOR PRINTF
      
  for(int i=0;i<itermc;i++)
  {
	 if(i%1024==0) printf("iter %d\n",i);
    //finding a proper starting point    
    while(1)
    {
         rand_val=feval("rand");
		 //x=(int)round(rand_val(0).scalar_value()*(double)(dim_geom(0)-1));
		 x=(int)round((double)xr+rand_val(0).scalar_value()*(double)(l1-1));
		 rand_val=feval("rand");
		 //y=(int)round(rand_val(0).scalar_value()*(double)(dim_geom(1)-1));
		 y=(int)round((double)yr+rand_val(0).scalar_value()*(double)(l2-1));
		 rand_val=feval("rand");
		 //z=(int)round(rand_val(0).scalar_value()*(double)(dim_geom(2)-1));
		 z=(int)round((double)zr+rand_val(0).scalar_value()*(double)(l3-1));
		 
		 if(condlim(x,y,z)==1e9)
		   break;	 
		
    }
    pos_nb=0;
    //random walk
    while(1)
    {
      pos(0,pos_nb)=x;
	  pos(1,pos_nb)=y;
	  pos(2,pos_nb)=z;
	  pos_nb++;
	  
	  nbcount(x,y,z)+=1.0;
		
		down=1.0/3.0*permit(x+1,y,z)/(permit(x-1,y,z)+permit(x+1,y,z));
        up=1.0/3.0*permit(x-1,y,z)/(permit(x-1,y,z)+permit(x+1,y,z));
        right=1.0/3.0*permit(x,y+1,z)/(permit(x,y+1,z)+permit(x,y-1,z));
        left=1.0/3.0*permit(x,y-1,z)/(permit(x,y+1,z)+permit(x,y-1,z));
        forward=1.0/3.0*permit(x,y,z+1)/(permit(x,y,z+1)+permit(x,y,z-1));
        backward=1.0/3.0*permit(x,y,z-1)/(permit(x,y,z+1)+permit(x,y,z-1));
	
		rand_val=feval("rand");
		if(rand_val(0).scalar_value()<down)
          x=x+1;
          else if(rand_val(0).scalar_value()>=down && rand_val(0).scalar_value()<down+up)
          x=x-1;   
          else if(rand_val(0).scalar_value()>=down+up && rand_val(0).scalar_value()<down+up+right)
          y=y+1;
          else if(rand_val(0).scalar_value()>=down+up+right && rand_val(0).scalar_value()<down+up+right+left)
          y=y-1;
          else if(rand_val(0).scalar_value()>=down+up+right+left && rand_val(0).scalar_value()<down+up+right+left+forward)
          z=z+1;
          else if(rand_val(0).scalar_value()>=down+up+right+left+forward)
          z=z-1;
           
		
		 if(condlim(x,y,z)!=1e9)
          break;
      
	
    }
	Vf=condlim(x,y,z);
	//	if(Vf==200)printf("Vf %f, posnb %d\n",Vf,pos_nb);
	for(int  j=0; j<pos_nb;j++)
          V(pos(0,j),pos(1,j),pos(2,j))+=Vf;
	
  
  }
    
    
  octave_stdout << "Hello World has "
                << nargin << " input arguments and "
                << nargout << " output arguments.\n";

	ret(0)=octave_value(V);
    ret(1)=octave_value(nbcount);				
				
  }
  

  
  return ret;
}

