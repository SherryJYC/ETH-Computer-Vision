function C = chi2_cost(s1, s2)
%CHI2_COST Summary of this function goes here
%   s1, s2: 2 shape descriptors
%   C: cost matrix

m = size(s1, 1);
n = size(s2, 1);
% initialize cost matrix (mxn)
C = zeros(m,n);

for i=1:m
    for j=1:n
        % use chi2 formula
       cost = 0.5 .* (s1{i}-s2{j}).^2./(s1{i}+s2{j});
       cost(isnan(cost)) = 0;
       C(i,j) = sum(cost,'all');
    end
end


end

