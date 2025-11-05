function [N,C_b,C_s] = vUnit_array(p,q,N,C_b,C_s,dis)
% q-array number, N-node matrix; C_b-bar connectivity; C_s: string
% connectivity; dis: distance unit off -vector 3*1;

%
numberN_unit = size(N,2);
[N,C_b,C_s] = tenseg_linea_array(N(:,numberN_unit),N(:,numberN_unit)+(q-1)*dis,q-1,'Evenly_Spacing',N,C_b,C_s,numberN_unit);

RotM = Rodrigues([0 0 1]',pi/p);

index_N = reshape(1:size(N,2),numberN_unit,[]);
% r_index_r = 2:2:size(index_N);
r_index = index_N(:,2:2:size(index_N,2));

N(:,r_index(:)) = RotM * N(:,r_index(:));

[N,C_b,C_s] = tenseg_delete_dup(N,C_b,C_s);


end