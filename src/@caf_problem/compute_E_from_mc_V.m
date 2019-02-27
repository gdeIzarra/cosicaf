function E=compute_E_from_mc_V(obj,x,V,pos_voxel,pos_geom,dl)
%
% Function to compute the electric field from the 
% potential obtained with MC.
% % The routine takes as input:
% -------------------------------
% x         a vector containing the position where the 
%           electric field must be estimated 
% V         a 3D matrix containing the electric field
% pos_voxel position of the center of the voxel in indices.
% pos_geom  position of the center of the voxel in (m).
% dl        discretisation step of the voxel     
% -------------------------------
%
% No test is done on the validity of the position to estimate
% E field. It is assumed that due to geometry discretisation,
% it is not possible to compute an electric field close to 
% a computation domain boundary!.
% 
% The function return a vector corresponding to the electric field. 

  
  d=x-pos_geom;
  d_vox=(d/dl);
  

  
  pos=round(pos_voxel+d_vox);
  
  %E=- grad V
  % The gradient is computed by using a 2 nd order difference scheme
  
  E(1)=-(V(pos(1)+1,pos(2),pos(3))-V(pos(1)-1,pos(2),pos(3)))./(2*dl);
  E(2)=-(V(pos(1),pos(2)+1,pos(3))-V(pos(1),pos(2)-1,pos(3)))./(2*dl);
  E(3)=-(V(pos(1),pos(2),pos(3)+1)-V(pos(1),pos(2),pos(3)-1))./(2*dl);

  
end
