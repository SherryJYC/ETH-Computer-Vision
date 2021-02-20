% Compute the distance for pairs of points and lines
% Input
%   points    Homogeneous 2D points 3xN
%   lines     2D homogeneous line equation 3xN
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(points, lines)

pts_num=size(points,2);
d=[];
for i=1:pts_num
    norm = sqrt(lines(1,i)*lines(1,i)+lines(2,i)*lines(2,i));
    d(i)=abs(lines(:,i)'*points(:,i))/norm;
end

end

