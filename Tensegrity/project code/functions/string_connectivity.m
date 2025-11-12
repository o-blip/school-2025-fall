function [C_s_in, string_group] = string_connectivity(p)
%% function to get the string connectivity of the unit
% may want to group these strings later
C_s_in = [];
% edges of outer polygon are strings
C_outer_bottom = [];
C_outer_top = [];
for i = 1:p
    c_s_bot = [i mod(i,p)+1];
    c_s_top = [3*p+i 3*p+1+mod(i,p)];
    C_outer_bottom = [C_outer_bottom;c_s_bot];
    C_outer_top = [C_outer_top;c_s_top];
end
C_s_in = [C_outer_bottom;C_outer_top];

C_temp = [];
C_inner2outer = [];
C_bottom2top = [];
for i = 1:p
    % strings between bot inner and bot outer
    c_s_b2b_a = [i i+p]; % bottom to bottom string "A"
    c_s_b2b_b = [i p+i-1]; % bottom to bottom string "B"
    if i == 1
        c_s_b2b_b = [1 2*p];
    end
    % strings from bottom to top face
    c_s_b2t_a = [i 3*p+i];
    c_s_b2t_b = [mod(i,p)+1 i+3*p];
    % C_s_in = [C_s_in;c_s_b2t_a;c_s_b2t_b];
    C_bottom2top = [C_bottom2top;c_s_b2t_a;c_s_b2t_b];
    C_inner2outer = [C_inner2outer; c_s_b2b_a;c_s_b2b_b];
end
% add 2*p to index to get top inner to top outer strings
C_inner2outer  = [C_inner2outer;2*p+C_inner2outer]; 


% strings between inner polygons
C_inner2inner = [];
for i = p+1:2*p
    c_s_b2b_a = [i i+p]; 
    c_s_b2b_b = [i p+i+1];
    if i == 2*p
        c_s_b2b_b = [i i+1];
    end
    C_inner2inner = [C_inner2inner; c_s_b2b_a;c_s_b2b_b];
end
string_group = {C_outer_bottom,C_outer_top,C_inner2outer,C_bottom2top,C_inner2inner};
C_s_in = [C_outer_bottom;C_outer_top;C_inner2outer;C_bottom2top;C_inner2inner];
end