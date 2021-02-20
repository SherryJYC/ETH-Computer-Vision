% Compute the distance for pairs of points and lines
% Input
%   points    2D points 2xN
%   k, b: parameter for y=kx+b, kx+b-y=0
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(points, k, b)

pts_num=size(points,2);
d=[];
for i=1:pts_num
    norm = sqrt(k^2+1);
    d(i)=abs(k*points(1,i)+b-points(2,i))/norm;
end

end

