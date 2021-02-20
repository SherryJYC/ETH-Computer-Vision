% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)
%data normalization
xs = xs(1:2,:);
% TODO 1. compute centroids
xy_cen = mean(xs,2);

% TODO 2. shift the points to have the centroid at the origin
T0 = [1   0   -xy_cen(1) ; 
      0   1   -xy_cen(2) ; 
      0   0        1     ];
  
s = size(xs); % s(2) is number of point
xs = [xs; ones(1,s(2))];
xy_shifted = T0*xs;

% TODO 3. compute scale
xy_dist = 0;
for i=1:s(2)
    xy_dist = xy_dist + norm(xy_shifted(:,i));
end
s_t = sqrt(2)/(xy_dist/s(2)); 
 
% TODO 4. create T and U transformation matrices (similarity transformation)
T = s_t * T0;
T(3,3) = 1;

% TODO 5. normalize the points according to the transformations
nxs = T*xs;

end
