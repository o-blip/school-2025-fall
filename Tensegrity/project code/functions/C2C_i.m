function C_i = C2C_i(C)
nmembers = size(C,1); % number of members
C_i = zeros(nmembers,2);

for member = 1:nmembers
    C_i(member,:) = [find(C(member,:) == -1) find(C(member,:) == 1)];
end
end