function [C_b_in, groups] = bar_connectivity(p)
%% function to get the bar connectivity of the unit
% Also returns the bar groups: inner polygons and outer bars

% inner polygon edges are bars
bot_inner = [];
top_inner = [];

for i = 1:p
    c_bi_in = [i+p (mod(i,p)+p)+1];
    c_ti_in = [i+2*p (mod(i,p)+2*p)+1];

    bot_inner = [bot_inner;c_bi_in];
    top_inner = [top_inner;c_ti_in];
end


% bars from bottom outer to top inner
% and bottom inner to top outer
bot_o_2_top_i = [];
bot_i_2_top_o = [];
for i = 1:p
    c_bo2ti_in = [i 2*p+i];
    bot_o_2_top_i = [bot_o_2_top_i; c_bo2ti_in];
    c_bi2to_in = [p+i 3*p+i];
    bot_i_2_top_o = [bot_i_2_top_o; c_bi2to_in];
end
C_b_in = [bot_inner; top_inner; bot_o_2_top_i;bot_i_2_top_o];
groups = {bot_inner, top_inner, bot_o_2_top_i, bot_i_2_top_o};
end