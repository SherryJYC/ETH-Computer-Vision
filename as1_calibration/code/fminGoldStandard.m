%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

% TODO compute reprojection errors
% TODO compute cost function value
s = size(xy_normalized);
xy_pro = P*XYZ_normalized;
xy_pro = xy_pro ./ xy_pro(end,:); % let last coord = 1
diff = xy_pro - xy_normalized;
f = 0;
for i=1:s(2)
    f = f + norm(diff(:,i))^2;
end

end