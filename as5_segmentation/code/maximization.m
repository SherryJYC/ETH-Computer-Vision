function [mu, var, alpha] = maximization(P, X)
% P: NxK
K = size(P,2);
N = size(X,1);

% compute mu and var
mu = zeros(K,3);
var = zeros(3,3,K);

sum_all_L = sum(P,1); % 1xK

for k = 1:K
    mu(k,:) = P(:,k)'*X/sum_all_L(k);
    for i = 1:N
        var(:,:,k) = var(:,:,k) + P(i,k)*((X(i,:)-mu(k,:))'*(X(i,:)-mu(k,:)));
    end
    var(:,:,k) = var(:,:,k)/sum_all_L(k);
end

% compute alpha
alpha = mean(P,1);
alpha = alpha/sum(alpha);

end