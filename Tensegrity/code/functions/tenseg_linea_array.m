function [N,C_b,C_s] = tenseg_linea_array(P1,P2,split_num,Spacing_Method,N,C_b,C_s,index)
%% This function aims to linear array one tensegrity structure along one given range and one specific point in this structure
%   Input:
%           P1,P2:the start and end point of given range, 3*1 vector
%           split_num: number of interval for splitting
%           Spacing_Method: e.g. Gausian Spacing, Cosine Spacing etc.
%           N,C_b,C_s: Tensegrity nodes matrix and connectivity matrix
%           index: The given nodes index
%   Outpts:
%           N,C_b,C_s: Tensegrity nodes matrix and connectivity matrix

%% Calculate major spacing points
[P_split] = tenseg_spacing(P1,P2,split_num,Spacing_Method);
%% Interval vector
intv = [];
for i =1:length(P_split(1,:))-1
    intv = [intv P_split(:,i+1) - P_split(:,i)];
end
%% Translate the original Nodes to start point coordinates
if index <= length(N(1,:))
    vec = P1 - N(:,index);
    N = N + vec;
else 
    disp('Error: Index is beyond the number of nodes of the structure, please check.');
    return
end
%% Aggregate nodes in all intervals and corresponding connectivity matrix
N_tmp = N;
len = length(N(1,:));
C_b_ori = C_b;
C_s_ori = C_s;

for i =1:length(P_split(1,:))-1
    N_tmp = N_tmp + intv(:,i);
    N = [N N_tmp];
    C_b = blkdiag(C_b,C_b_ori);
    C_s = blkdiag(C_s,C_s_ori);
end