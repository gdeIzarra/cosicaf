function [V,nbpass]=solve_mc_V(obj,condlim,permit,iter)
  
  V=zeros(size(condlim));
  nbpass=zeros(size(condlim));
  
  pos=zeros(3,size(condlim,1)*size(condlim,2)*10);
  pos_nb=0;
  
  % probability computation for all the direction
  up=0;
  down=0;
  left=0;
  right=0;
  forward=0;
  backward=0;
  dir=0;
  
  for j=1:iter
  j
        while(1)%finding a proper starting position.
        
          cpos=round(rand(1,3).*(size(condlim)-1)+1);
          
          if(condlim(cpos(1),cpos(2),cpos(3))==1e9)
          break;
          end
        
        end
        
        pos_nb=0;
        
        while(1)
        
          pos(:,pos_nb+1)=cpos;
          pos_nb=pos_nb+1;
          
          nbpass(cpos(1),cpos(2),cpos(3))=nbpass(cpos(1),cpos(2),cpos(3))+1;
          
          down=1/3*permit(cpos(1)+1,cpos(2),cpos(3))/(permit(cpos(1)-1,cpos(2),cpos(3))+permit(cpos(1)+1,cpos(2),cpos(3)));
          up=1/3*permit(cpos(1)-1,cpos(2),cpos(3))/(permit(cpos(1)-1,cpos(2),cpos(3))+permit(cpos(1)+1,cpos(2),cpos(3)));
          right=1/3*permit(cpos(1),cpos(2)+1,cpos(3))/(permit(cpos(1),cpos(2)+1,cpos(3))+permit(cpos(1),cpos(2)-1,cpos(3)));
          left=1/3*permit(cpos(1),cpos(2)-1,cpos(3))/(permit(cpos(1),cpos(2)+1,cpos(3))+permit(cpos(1),cpos(2)-1,cpos(3)));
          forward=1/3*permit(cpos(1),cpos(2),cpos(3)+1)/(permit(cpos(1),cpos(2),cpos(3)+1)+permit(cpos(1),cpos(2),cpos(3)-1));
          backward=1/3*permit(cpos(1),cpos(2),cpos(3)-1)/(permit(cpos(1),cpos(2),cpos(3)+1)+permit(cpos(1),cpos(2),cpos(3)-1));
          
          dir=rand();
          
          if(dir<down)
          cpos(1)=cpos(1)+1;
          elseif(dir>=down && dir<down+up)
          cpos(1)=cpos(1)-1;   
          elseif(dir>=down+up && dir<down+up+left)
          cpos(2)=cpos(2)+1;
          elseif(dir>=down+up+left && dir<down+up+left+forward)
          cpos(2)=cpos(2)-1;
          elseif(dir>=down+up+left+forward && dir<down+up+left+forward+backward)
          cpos(3)=cpos(3)+1;
          elseif(dir>=down+up+left+forward+backward)
          cpos(3)=cpos(3)-1;
          end 
          
          if(condlim(cpos(1),cpos(2),cpos(3))~=1e9)
          break;
          end
        
        end
        Vf=condlim(cpos(1),cpos(2),cpos(3));
        
        for i=1:pos_nb
          
          V(pos(1,i),pos(2,i),pos(3,i))=V(pos(1,i),pos(2,i),pos(3,i))+Vf;
        
        
        end
  
  
  end %end for

end
