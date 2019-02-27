function draw_voxel(mat,val)
%  mat=condlim;
 % val=[10, -10, 0];
  res=zeros(size(mat));
  clf
  hold on
  for o=val
  %res=res | mat==o;  
  res= (mat==o);
  
  [i,j,k]=ind2sub(size(mat),find(res));
%  c=(mat(find(res))-min(val))./(max(val)-min(val));
  scatter3(i,j,k)
   end
  hold off
end
