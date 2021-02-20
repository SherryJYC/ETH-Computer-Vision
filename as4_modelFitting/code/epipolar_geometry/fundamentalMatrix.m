% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
pts_num = size(x1s,2);
% normalize points
[nxs1, T1] = normalizePoints2d(x1s);
[nxs2, T2] = normalizePoints2d(x2s);

% compute F
% build A
A = zeros(pts_num, 9);
for i=1:pts_num
    A(i,1) = nxs1(1,i)*nxs2(1,i);
    A(i,2) = nxs1(1,i)*nxs2(2,i);
    A(i,3) = nxs1(1,i);
    
    A(i,4) = nxs1(2,i)*nxs2(1,i);
    A(i,5) = nxs1(2,i)*nxs2(2,i);
    A(i,6) = nxs1(2,i);
    
    A(i,7) = nxs2(1,i);
    A(i,8) = nxs2(2,i);
    A(i,9) = 1;
end

% compute SVD
[U,D,V]=svd(A);
f =V(:,end);

% de-normalize back
f = reshape(f, [3,3]).';
% use formula from https://www.cc.gatech.edu/classes/AY2016/cs4476_fall/results/proj3/html/sdai30/index.html
F = T2'*f*T1;

% enforce det=0
[U,D,V]=svd(F);
D(3,3) = 0;
Fh=U*D*V';

end