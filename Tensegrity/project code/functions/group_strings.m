function string_grp = group_strings(N,C_s,h,h_ratio)
%% Groups the strings for a polygonal unit
% Inputs: N - Node matrix
%         C_s - string connectivity matrix
%         h - height of unit
%         h_ratio - height aspect ratio of unit
%         grid - [x-units, y-units, z-units]
% Outputs: string_grp - cell of grouped strings
%          string_grp{1} -> bottom strings
%          string_grp{2} -> top strings
%          string_grp{3} -> outer vertical strings
%          string_grp{4} -> inner vertical strings

% Define z-coordinates of string nodes
height_i_b = h*(1-h_ratio); % height of inner, bottom polygon
height_i_t = h;              % height of inner, top polygon

height_o_b = 0;             % height of outer, bottom polygon (ground)
height_o_t = h*(2-h_ratio); % height of outer, top polygon

% group strings that create the top face: have same z-coordinates

% z-coordinate definition for vertical groups
top2bot_z = [height_o_t height_o_b]; 
bot2bot_z = [height_o_b height_i_b];
top2top_z = [height_o_t height_i_t];
inner2inner_z = [height_i_t height_i_b];

C_index = C2C_i(C_s); % convert connectivity to connevtivity index
nelem = size(C_s,1);

top_str_in = [];
bot_str_in = [];
t2b_outer_in = [];
bot2bot_in = [];
top2top_in = [];
inner2inner_in = [];

for string = 1:nelem
    string_index = C_index(string,:);
    % z-coordinates of nodes for string i
    N_z_1 = N(3,string_index(1));
    N_z_2 = N(3,string_index(2));
    if N_z_1 == height_o_t & N_z_2 == height_o_t
        top_str_in = [top_str_in;string_index];

    elseif N_z_1 == height_o_b & N_z_2 == height_o_b
        bot_str_in = [bot_str_in;string_index];

    elseif any(top2bot_z == N_z_1) && any(top2bot_z == N_z_2)
        t2b_outer_in =[t2b_outer_in;string_index];

    elseif any(bot2bot_z == N_z_1) && any(bot2bot_z == N_z_2)
        bot2bot_in =[bot2bot_in;string_index];

    elseif any(top2top_z == N_z_1) && any(top2top_z == N_z_2)
        top2top_in =[top2top_in;string_index];

    elseif any(inner2inner_z == N_z_1) && any(inner2inner_z == N_z_2)
        inner2inner_in =[inner2inner_in;string_index];
    end
end



top_str = tenseg_ind2C(top_str_in,N);
bot_str = tenseg_ind2C(bot_str_in,N);
t2b_outer = tenseg_ind2C(t2b_outer_in,N);
bot2bot = tenseg_ind2C(bot2bot_in,N);
top2top= tenseg_ind2C(top2top_in,N);
inner2inner = tenseg_ind2C(inner2inner_in,N);
string_grp = {top_str, bot_str,t2b_outer,bot2bot,top2top,inner2inner};
end