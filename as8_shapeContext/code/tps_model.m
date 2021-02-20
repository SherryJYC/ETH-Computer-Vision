function [x_x x_y E] = tps_model(X,Y,lambda)
%TPS_MODEL Summary of this function goes here
% where the outputs w_x and w_y are the parameters (?i and ai ) in the two TPS models, 
% E is the total bending energy 
% and the inputs are as following:
% ? points in the template shape, X
% ? corresponding points in the target shape, Y 
% ? regularizationparameter,lambda
n = size(X, 1);

% compute K
K = sqrt(dist2(X,X)); % nxn dist measurement
K = K.^2 .* log(K.^2);
K(isnan(K)) = 0;

% compute P (the i-th row of P is (1,xi,yi)), nx3
P = [ones(n, 1), X];

% form linear system Ax = b
A = [ [K+lambda*eye(n) P]; [P' zeros(3)]]; % (n+3)x(n+3)
bx = [Y(:,1); zeros(3,1)]; % (n+3) x 1
by = [Y(:,2); zeros(3,1)]; % (n+3) x 1

% x = [w | a].' w: nx1, a: 3x1
x_x = A \ bx; % (n+3) x 1
x_y = A \ by; % (n+3) x 1
w_x = x_x(1:n, :);
w_y = x_y(1:n, :);

% E in 2 dim
E = w_x'*K*w_x + w_y'*K*w_y;
end

