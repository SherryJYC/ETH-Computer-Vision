function [map cluster] = EM(img)
img = double(img);
w = size(img, 1);
h = size(img,2);
L = w*h;
X = [reshape(img(:,:,1),L,1),reshape(img(:,:,2),L,1),reshape(img(:,:,3),L,1)];
K = 3;

% initialization:
% alpha as uniform weight
alpha = ones(1, K)*1/K;
% compute range in each dimension
delta_L = max(X(:,1)) - min(X(:,1));
delta_a = max(X(:,2)) - min(X(:,1));
delta_b = max(X(:,3)) - min(X(:,3));
% use function generate_mu to initialize mus
mu = generate_mu(delta_L, delta_a, delta_b, K);
% use function generate_cov to initialize covariances
cov = generate_cov(delta_L, delta_a, delta_b, K);

% iterate between maximization and expectation
diff = 1;
thresh = 0.8;
while diff>thresh
    % compute expectation
    P = expectation(mu,cov,alpha,X);
    % compute maximization
    [new_mu, new_cov, new_alpha] = maximization(P, X);
    % compute difference
    diff = norm(new_mu-mu);
%     disp(diff)
    % update parameters
    mu = new_mu;
    cov = new_cov;
    alpha = new_alpha;
end

% convert to map 
[m, map] = max(P, [], 2);
map = reshape(map,[w, h]);
% convert to cluster
cluster = mu;

alpha
mu
cov
end