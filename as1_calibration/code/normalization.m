%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn
% T: 3x3
% U: 4x4

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization

% TODO 1. compute centroids
xy_cen = mean(xy,2);
XYZ_cen = mean(XYZ, 2);

% TODO 2. shift the points to have the centroid at the origin
T0 = [1   0   -xy_cen(1) ; 
      0   1   -xy_cen(2) ; 
      0   0        1     ];
  
U0 = [1   0   0   -XYZ_cen(1) ; 
      0   1   0   -XYZ_cen(2) ; 
      0   0   1   -XYZ_cen(3) ; 
      0   0   0       1];
s = size(xy); % s(2) is number of point
xy = [xy ; ones(1,s(2))];
XYZ = [XYZ ; ones(1,s(2))];

xy_shifted = T0*xy;
XYZ_shifted = U0*XYZ;

% TODO 3. compute scale
xy_dist = 0;
XYZ_dist = 0;
for i=1:s(2)
    xy_dist = xy_dist + norm(xy_shifted(:,i));
    XYZ_dist = XYZ_dist + norm(XYZ_shifted(:,i));
end
s_t = sqrt(2)/(xy_dist/s(2)); 
s_u = sqrt(3)/(XYZ_dist/s(2));
 
% TODO 4. create T and U transformation matrices (similarity transformation)
T = s_t * T0;
T(3,3) = 1;
U = s_u * U0;
U(4,4) = 1;

% TODO 5. normalize the points according to the transformations
xy_normalized = T*xy;
XYZ_normalized = U*XYZ;

end