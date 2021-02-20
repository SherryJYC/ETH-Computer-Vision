%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
% TODO fill the gaps in fminGoldstandard.m
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

% TODO: denormalize projection matrix
Pn_ = reshape(pn,[4,3]).';
P = inv(T)*Pn_*U;

%factorize prokection matrix into K, R and t
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