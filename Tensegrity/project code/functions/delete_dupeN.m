function [N_new,C_b,C_s] = delete_dupeN(N,C_b,C_s,precision)

if nargin <4
    precision = 6;
end
tol = 10^-precision;

num_N = size(N,2); % # of columns = # of nodes


dupe_index = [];
map = {};
for n = 1:num_N
    dupe = find(vecnorm(N-N(:,n))<tol);
    filter_dupe = dupe(dupe>n); % separates dupes and original

    if ~isempty(filter_dupe)
        dupe_index = [dupe_index filter_dupe]; % stores index of dupe nodes
        map = [map; {filter_dupe, n}]; % map{:,1} to map{:,2}
    end
end
N_new = N;
N_new(:,dupe_index)=[];
C_b = fix_C(map,C_b);
C_s = fix_C(map,C_s);



end


function C_new = fix_C(map,C_old)
old_n = size(C_old,2); % old max number of nodes
C_temp = C_old;
for i = 1: size(map,1)
    kept_node = map{i,2};
    repeat_node = map{i,1};
    rows = find(any(C_old(:,repeat_node)<-.1,2));
    C_temp(rows,kept_node) = -1;
    
    rows2 = find(any(C_old(:,repeat_node)>.1,2));
    C_temp(rows2,kept_node) = 1;

    C_temp(:,repeat_node) = 0;
end
C_new = C_temp(:,~all(C_temp==0,1));
size(C_temp)
size(C_new)
end