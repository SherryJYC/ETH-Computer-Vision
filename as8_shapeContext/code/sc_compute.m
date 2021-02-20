function descriptor = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
%SC_COMPUTE 
% compute shape descriptor
% ? set of points, X (nx2)
% ? number of bins in the angular dimension, nbBins_theta 
% ? number of bins in the radial dimension, nbBins_r
% ? the length of the smallest radius, smallest_r
% ? the length of the biggest radius, biggest_r

X = X';
n = size(X, 1); % total number of points
descriptor = cell(n,1); % iniialize shape descriptor

% get def for log-polar coord system
minr = log(smallest_r);
maxr = log(biggest_r);
% build polar grid in radial dimension
dr = (maxr-minr)/nbBins_r; % equally radius interval
r = linspace(minr,maxr-dr,nbBins_r); % get all possible radius
% build polar grid in angular dimenstion
dtheta = 2*pi/nbBins_theta; % equally angle interval
theta = linspace(0,2*pi-dtheta,nbBins_theta);
norm_scale = mean2(sqrt(dist2(X,X))); 

% for each point, compute descriptor
for i=1:n
    temp_pt = X(i,:);
    
    % calculate distance from temp points to all other points of X
    % X_dist has size 1xm, where m is equal to num-1
    temp_repeat = repmat(temp_pt,n,1);
    dist = temp_repeat - X;
    dist(i,:) = []; % no need to compute dist for self-self pair
    
    % convert into polar coord
    [dist_theta,dist_r] = cart2pol(dist(:,1),dist(:,2));
    dist_r = dist_r / norm_scale; % normalization
    % build histogram (Bivariate histogram)
    descriptor{i} = hist3([dist_theta log(dist_r)],'Edges',{theta, r});
end

end

