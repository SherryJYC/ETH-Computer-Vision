%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

% TODO denormalize projection matrix
P = inv(T) * Pn * U;

%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

% TODO compute average reprojection error
s = size(xy);
xy = [xy ; ones(1,s(2))];
XYZ = [XYZ ; ones(1,s(2))];
xy_pro = P*XYZ;
xy_pro = xy_pro ./ xy_pro(end,:);
diff = xy_pro - xy;
error = 0;
for i=1:s(2)
    error = error + norm(diff(:,i));
end
error = error / s(2);
end