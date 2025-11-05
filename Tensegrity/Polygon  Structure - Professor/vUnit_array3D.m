function [N,C_b,C_s] = vUnit_array3D(p,qz,qx,qy,N,C_b,C_s,dis)
% q-array number, N-node matrix; C_b-bar connectivity; C_s: string
% connectivity; dis: distance unit off -vector 3*1;

%
[N2,C_b2,C_s2] = vUnit_array(p,qz,N,C_b,C_s,[0;0;dis(3)]);
numberN_unit = size(N2,2);

[N,C_b,C_s] = tenseg_linea_array(N2(:,numberN_unit),N2(:,numberN_unit)+(qx-1)*[dis(1);0;0],qx-1,'Evenly_Spacing',N2,C_b2,C_s2,numberN_unit);

[N3,C_b3,C_s3] = tenseg_delete_dup(N,C_b,C_s);
numberN_unit = size(N3,2);

[N,C_b,C_s] = tenseg_linea_array(N3(:,numberN_unit),N3(:,numberN_unit)+(qy-1)*[0;dis(2);0],qy-1,'Evenly_Spacing',N3,C_b3,C_s3,numberN_unit);

[N,C_b,C_s] = tenseg_delete_dup(N,C_b,C_s);

end