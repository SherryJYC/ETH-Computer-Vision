%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function

% TODO 1. For each correspondence xi <-> Xi, computes matrix Ai
s = size(xyn);
A = zeros(2*s(2),12);
for i=1:s(2)
    A(i*2-1,:) = [XYZn(:,i).', zeros(1,4),-xyn(1,i)*XYZn(:,i).'];
    A(i*2,:) = [zeros(1,4), -XYZn(:,i).', xyn(2,i)*XYZn(:,i).' ];
end
% TODO 2. Compute the Singular Value Decomposition of Usvd*S*V' = A
[U_,S,V] = svd(A);

% TODO 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
P_normalized = V(:,end);
P_normalized = reshape(P_normalized,[4,3]).';
end
