function [N_new,C_b,C_s] = tenseg_delete_dup(N,C_b,C_s)
%% This function is to delete duplicate nodes and also fix the corresponding connectivity matrix
% Inputs:
%       N:3*n matrix
%       C_b:alpha*n
%       C_s:beta*n
% Outputs:
%       N:n'*3 matrix
%       C_b:alpha*n'
%       C_s:beta*n'
N = N';
[C_b_cor,C_s_cor] = transferC_b2C_b_cor(N,C_b,C_s);
N_new = setoff_dup_new(N,6);
C_b_in=transfer_C_b_new(N_new,C_b_cor,6);
C_s_in=transfer_C_b_new(N_new,C_s_cor,6);
C_b_in = setoff_C(C_b_in);
C_s_in = setoff_C(C_s_in);
C_b = tenseg_ind2C(C_b_in,N_new');
C_s = tenseg_ind2C(C_s_in,N_new');
N_new = N_new';